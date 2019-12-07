/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.weixinLogin;

import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.LoginPlugin;
import net.shopxx.service.MemberService;
import net.shopxx.service.SocialUserService;
import net.shopxx.util.JsonUtils;
import net.shopxx.util.MapGetter;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
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
import java.net.URLEncoder;
import java.util.Map;

/**
 * Plugin - 微信登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("weixinLoginPlugin")
public class WeixinLoginPlugin extends LoginPlugin {
	@Inject
	private SocialUserService socialUserService;
	@Inject
	private MemberService memberService;
	/**
	 * code请求URL
	 */
	private static final String CODE_REQUEST_URL = "https://open.weixin.qq.com/connect/oauth2/authorize";

	/**
	 * openId请求URL
	 */
	private static final String OPEN_ID_REQUEST_URL = "https://api.weixin.qq.com/sns/oauth2/access_token";

	/**
	 * 用户信息请求URL
	 * @return
	 */
	private static final String USER_INFO_REQUEST_URL = "https://api.weixin.qq.com/sns/userinfo";
	@Override
	public String getName() {
		return "微信登录";
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
		return "weixin_login/install";
	}

	@Override
	public String getUninstallUrl() {
		return "weixin_login/uninstall";
	}

	@Override
	public boolean supports(HttpServletRequest request) {
		String userAgent = request.getHeader("USER-AGENT");
		return StringUtils.contains(userAgent.toLowerCase(), "micromessenger");
	}

	@Override
	public void signInHandle(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		/*Map<String, Object> parameterMap = new TreeMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("redirect_uri", getPostSignInUrl(loginPlugin));
		parameterMap.put("response_type", "code");
		parameterMap.put("scope", "snsapi_userinfo");*/
		System.out.println("获取codeurl----------------------------"+CODE_REQUEST_URL+"?appid="+getAppId()+"&redirect_uri="+URLEncoder.encode(getPostSignInUrl(loginPlugin),"UTF-8")+"&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect");
//		modelAndView.addObject("requestUrl", CODE_REQUEST_URL+"?appid="+getAppId()+"&redirect_uri="+ URLEncoder.encode(getPostSignInUrl(loginPlugin),"UTF-8")+"&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect");
//		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName("redirect:"+CODE_REQUEST_URL+"?appid="+getAppId()+"&redirect_uri="+ URLEncoder.encode(getPostSignInUrl(loginPlugin),"UTF-8")+"&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect");

	}
	

    @Override
	public boolean isSignInSuccess(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		if (StringUtils.isEmpty(code)) {
			return false;
		}
		try {
			OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());
			TokenRequestBuilder tokenRequestBuilder = OAuthClientRequest.tokenLocation(OPEN_ID_REQUEST_URL);
			tokenRequestBuilder.setParameter("appid", getAppId());
			tokenRequestBuilder.setParameter("secret", getAppSecret());
			tokenRequestBuilder.setCode(code);
			tokenRequestBuilder.setGrantType(GrantType.AUTHORIZATION_CODE);
			OAuthClientRequest accessTokenRequest = tokenRequestBuilder.buildQueryMessage();
			OAuthJSONAccessTokenResponse authJSONAccessTokenResponse = oAuthClient.accessToken(accessTokenRequest, OAuth.HttpMethod.GET);
			String openId = authJSONAccessTokenResponse.getParam("openid");
			String accessToken = authJSONAccessTokenResponse.getParam("access_token");
			//请求用户信息
			HttpClient httpClient =  HttpClients.createDefault();//创建httpClient对象
			HttpPost httpPost = new HttpPost(USER_INFO_REQUEST_URL + "?access_token=" + accessToken + "&openid=" + openId);
			HttpResponse httpResponse = httpClient.execute(httpPost);
			String userInfo = "";
			if (httpResponse.getStatusLine().getStatusCode() == 200) {
				HttpEntity resEntity = httpResponse.getEntity();
				userInfo = EntityUtils.toString(resEntity, "utf-8");
			} else {
				System.out.println("请求失败");
			}
			Map<String,Object> param = JsonUtils.toObject(userInfo, Map.class);
			//获取头像
			String headImgUrl = MapGetter.getString(param,"headimgurl");
			//获取昵称
			String nickName = MapGetter.getString(param,"nickname");
			
			if (StringUtils.isNotEmpty(openId) && StringUtils.isNotEmpty(accessToken)) {
				request.setAttribute("openid", openId);
				request.setAttribute("access_token", accessToken);
				
				if(StringUtils.isNotEmpty(headImgUrl)){
					request.setAttribute("headimgurl",headImgUrl);
				}
				if(StringUtils.isNotEmpty(nickName)){
					request.setAttribute("nickname",nickName);
				}
				return true;
			}
		} catch (OAuthSystemException e) {
			throw new RuntimeException(e.getMessage(), e);
		} catch (OAuthProblemException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
		return false;
	}
	

    @Override
	public String getSettingUrl() {
		return "weixin_login/setting";
	}

	@Override
	public String getUniqueId(HttpServletRequest request) {
		String openId = (String) request.getAttribute("openid");
		return StringUtils.isNotEmpty(openId) ? openId : null;
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

}