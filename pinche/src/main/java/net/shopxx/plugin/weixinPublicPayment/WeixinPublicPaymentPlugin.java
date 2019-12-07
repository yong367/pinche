/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.weixinPublicPayment;

import com.fasterxml.jackson.core.type.TypeReference;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.QueryOrderRefundStatusResponse;
import net.shopxx.plugin.QueryPayStatusResponse;
import net.shopxx.util.WebUtils;
import net.shopxx.util.WxPayUtil;
import net.shopxx.util.XmlUtils;
import net.shopxx.weixin.config.WxPayServerConfig;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.oltu.oauth2.client.OAuthClient;
import org.apache.oltu.oauth2.client.URLConnectionClient;
import org.apache.oltu.oauth2.client.request.OAuthClientRequest;
import org.apache.oltu.oauth2.client.request.OAuthClientRequest.TokenRequestBuilder;
import org.apache.oltu.oauth2.client.response.OAuthJSONAccessTokenResponse;
import org.apache.oltu.oauth2.common.OAuth;
import org.apache.oltu.oauth2.common.exception.OAuthProblemException;
import org.apache.oltu.oauth2.common.exception.OAuthSystemException;
import org.apache.oltu.oauth2.common.message.types.GrantType;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;

/**
 * Plugin - 微信支付(公众号支付)
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("weixinPublicPaymentPlugin")
public class WeixinPublicPaymentPlugin extends PaymentPlugin {

	/**
	 * code请求URL
	 */
	private static final String CODE_REQUEST_URL = "https://open.weixin.qq.com/connect/oauth2/authorize";

	/**
	 * openId请求URL
	 */
	private static final String OPEN_ID_REQUEST_URL = "https://api.weixin.qq.com/sns/oauth2/access_token";

	/**
	 * prepay_id请求URL
	 */
	private static final String PREPAY_ID_REQUEST_URL = "https://api.mch.weixin.qq.com/pay/unifiedorder";

	/**
	 * 查询订单请求URL
	 */
	private static final String ORDER_QUERY_REQUEST_URL = "https://api.mch.weixin.qq.com/pay/orderquery";

	/**
	 * 订单退款URL
	 * @return
	 */
	private static final String ORDER_REFUND_URL ="https://api.mch.weixin.qq.com/secapi/pay/refund";

    @Inject
    private WxPayServerConfig wxPayServerConfig;

	@Override
	public String getName() {
		return "微信支付(公众号支付)";
	}

	@Override
	public String getVersion() {
		return "1.0";
	}

	@Override
	public String getAuthor() {
		return "SHOP++";
	}

	@Override
	public String getSiteUrl() {
		return "http://www.shopxx.net";
	}

	@Override
	public String getInstallUrl() {
		return "weixin_public_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "weixin_public_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "weixin_public_payment/setting";
	}

	@Override
	public boolean supports(HttpServletRequest request) {
		String userAgent = request.getHeader("USER-AGENT");
		System.out.println("内置浏览器获取的用户代理信息------"+userAgent);
		return StringUtils.contains(userAgent.toLowerCase(), "micromessenger");
	}

	@Override
	public void prePayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		/*Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("redirect_uri", getPayUrl(paymentPlugin, paymentTransaction));
		parameterMap.put("response_type", "code");
		parameterMap.put("scope", "snsapi_base");

		modelAndView.addObject("requestUrl", CODE_REQUEST_URL);
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName("net/shopxx/plugin/weixinPublicPayment/pre_pay");*/
		System.out.println("支付订单进入微信支付前置处理-----------------------------------------------");
		modelAndView.setViewName("redirect:"+CODE_REQUEST_URL+"?appid="+getAppId()+"&redirect_uri="+ URLEncoder.encode(getPayUrl(paymentPlugin, paymentTransaction),"UTF-8")+"&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect");
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		System.out.println("微信支付处理payHandle 方法中------------------------------");
		String code = request.getParameter("code");
		System.out.println("微信支付处理payHandle 方法获取的CODE 值 "+code+"------------------------------");
		if (StringUtils.isEmpty(code)) {
			modelAndView.setViewName("common/error/unprocessable_entity");
			return;
		}
		System.out.println("微信支付处理payHandle  CODE 值验证通过------------------------------");
		String openId = getOpenId(code);
		System.out.println("-----------------获取的用户openID="+openId);
		Map<String, Object> parameterMap = new TreeMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("mch_id", getMchId());
		parameterMap.put("nonce_str", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
		parameterMap.put("body", StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 600));
		parameterMap.put("out_trade_no", paymentTransaction.getSn());
		parameterMap.put("total_fee", paymentTransaction.getAmount().multiply(new BigDecimal(100)).setScale(0).toString());
		parameterMap.put("spbill_create_ip", request.getLocalAddr());
		parameterMap.put("notify_url", getPostPayUrl(paymentPlugin, paymentTransaction));
		parameterMap.put("trade_type", "JSAPI");
		parameterMap.put("openid", openId);
		parameterMap.put("sign", generateSign(parameterMap));
		System.out.println(getPostPayUrl(paymentPlugin, paymentTransaction));
		String result = WebUtils.post(PREPAY_ID_REQUEST_URL, XmlUtils.toXml(parameterMap));
		Map<String, String> resultMap = XmlUtils.toObject(result, new TypeReference<Map<String, String>>() {
		});
		System.out.println("result--------------------="+result);
		String prepayId = resultMap.get("prepay_id");
		String tradeType = resultMap.get("trade_type");
		String resultCode = resultMap.get("result_code");
		if (StringUtils.equals(tradeType, "JSAPI") && StringUtils.equals(resultCode, "SUCCESS")) {
			Map<String, Object> modelMap = new TreeMap<>();
			modelMap.put("appId", getAppId());
			modelMap.put("timeStamp", new Date().getTime());
			modelMap.put("nonceStr", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
			modelMap.put("package", "prepay_id=" + prepayId);
			modelMap.put("signType", "MD5");
			modelMap.put("paySign", generateSign(modelMap));
			modelMap.put("postPayUrl", getPostPayUrl(paymentPlugin, paymentTransaction));
			modelAndView.addAllObjects(modelMap);
			modelAndView.setViewName("net/shopxx/plugin/weixinPublicPayment/pay");
		}
	}

	@Override
	public QueryPayStatusResponse queryPaySuccess(PaymentTransaction paymentTransaction) throws Exception {
		return null;
	}

	@Override
	public QueryOrderRefundStatusResponse queryOrderRefundSuccess(PaymentTransaction paymentTransaction) throws Exception {
		Map<String, String> parameterMap = new TreeMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("mch_id", getMchId());
		parameterMap.put("out_trade_no", paymentTransaction.getSn());
		parameterMap.put("nonce_str", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
		parameterMap.put("out_refund_no", UUID.randomUUID().toString());
        int amount = new Double(paymentTransaction.getAmount().doubleValue() * 100).intValue();
        parameterMap.put("total_fee", amount+"");
        parameterMap.put("refund_fee",amount+"");
        parameterMap.put("sign", generateSign(parameterMap));
        String returnInfo = WebUtils.postXmlToWx(ORDER_REFUND_URL,WxPayUtil.mapToXml(parameterMap),true,wxPayServerConfig);
        System.out.println(returnInfo);
		Map<String, String> resultMap = XmlUtils.toObject(returnInfo, new TypeReference<Map<String, String>>() {
		});
		String returnCode = resultMap.get("return_code");
		String resultCode = resultMap.get("result_code");
		QueryOrderRefundStatusResponse queryOrderRefundStatusResponse = new QueryOrderRefundStatusResponse();
		if ("SUCCESS".equals(returnCode)) {
			if ("SUCCESS".equals(resultCode)) {
				queryOrderRefundStatusResponse.setOrderRefundStatus(true);
			}
			else {
				String returnMsg = resultMap.get("err_code_des");
				queryOrderRefundStatusResponse.setOrderRefundStatus(false);
				queryOrderRefundStatusResponse.setMessage(returnMsg);
			}
		} else {
			queryOrderRefundStatusResponse.setOrderRefundStatus(false);
		}
		return queryOrderRefundStatusResponse;
	}

	@Override
	public void postPayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, boolean isPaySuccess, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		super.postPayHandle(paymentPlugin, paymentTransaction, paymentDescription, extra, isPaySuccess, request, response, modelAndView);

		String xml = IOUtils.toString(request.getInputStream(), "UTF-8");
		if (StringUtils.isEmpty(xml)) {
			return;
		}
		Map<String, String> resultMap = XmlUtils.toObject(xml, new TypeReference<Map<String, String>>() {
		});

		if (StringUtils.equals(resultMap.get("return_code"), "SUCCESS")) {
			modelAndView.addObject("message", "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>");
		}
	}

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> parameterMap = new TreeMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("mch_id", getMchId());
		parameterMap.put("out_trade_no", paymentTransaction.getSn());
		parameterMap.put("nonce_str", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
		parameterMap.put("sign", generateSign(parameterMap));
		String result = WebUtils.post(ORDER_QUERY_REQUEST_URL, XmlUtils.toXml(parameterMap));
		Map<String, String> resultMap = XmlUtils.toObject(result, new TypeReference<Map<String, String>>() {
		});
		return StringUtils.equals(resultMap.get("return_code"), "SUCCESS") && StringUtils.equals(resultMap.get("result_code"), "SUCCESS") && StringUtils.equals(resultMap.get("trade_state"), "SUCCESS")
				&& paymentTransaction.getAmount().multiply(new BigDecimal(100)).compareTo(new BigDecimal(resultMap.get("total_fee"))) == 0;
	}

	/**
	 * 获取AppID
	 * 
	 * @return AppID
	 */
	private String getAppId() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("appId");
	}

	/**
	 * 获取AppSecret
	 * 
	 * @return AppSecret
	 */
	private String getAppSecret() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("appSecret");
	}

	/**
	 * 获取商户号
	 * 
	 * @return 商户号
	 */
	private String getMchId() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("mchId");
	}

	/**
	 * 获取API密钥
	 * 
	 * @return API密钥
	 */
	private String getApiKey() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("apiKey");
	}

	/**
	 * 获取OpenID
	 * 
	 * @param code
	 *            code值
	 * @return OpenID
	 */
	private String getOpenId(String code) {
		try {
			OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());
			TokenRequestBuilder tokenRequestBuilder = OAuthClientRequest.tokenLocation(OPEN_ID_REQUEST_URL);
			tokenRequestBuilder.setParameter("appid", getAppId());
			tokenRequestBuilder.setParameter("secret", getAppSecret());
			tokenRequestBuilder.setCode(code);
			tokenRequestBuilder.setGrantType(GrantType.AUTHORIZATION_CODE);
			OAuthClientRequest accessTokenRequest = tokenRequestBuilder.buildQueryMessage();
			OAuthJSONAccessTokenResponse authJSONAccessTokenResponse = oAuthClient.accessToken(accessTokenRequest, OAuth.HttpMethod.GET);
			return authJSONAccessTokenResponse.getParam("openid");
		} catch (OAuthSystemException e) {
			throw new RuntimeException(e.getMessage(), e);
		} catch (OAuthProblemException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	/**
	 * 生成签名
	 * 
	 * @param parameterMap
	 *            参数
	 * @return 签名
	 */
	private String generateSign(Map<String, ?> parameterMap) {
		return StringUtils.upperCase(DigestUtils.md5Hex(joinKeyValue(new TreeMap<>(parameterMap), null, "&key=" + getApiKey(), "&", true)));
	}

}