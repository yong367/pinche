/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.alipayDualPayment;

import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.request.AlipayTradeRefundRequest;
import com.alipay.api.response.AlipayTradeRefundResponse;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.QueryOrderRefundStatusResponse;
import net.shopxx.plugin.QueryPayStatusResponse;
import net.shopxx.util.SystemUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Plugin - 支付宝(双接口)
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("alipayDualPaymentPlugin")
public class AlipayDualPaymentPlugin extends PaymentPlugin {

	@Override
	public String getName() {
		return "支付宝(双接口)";
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
		return "alipay_dual_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "alipay_dual_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "alipay_dual_payment/setting";
	}

    private static final String PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAldj+J9RY/H21wpPIBbb3QR6iZoieOZxiXB/5e8Lucsm4jQz6eUynVG4CSUz666tywkT9H5zVbW7CN6fxvM7EIJxnCyVIJlxwPZhbrCZmCLAWvjPbKtGvwkJJEIKok0LnFHmwGrvKeJxvh1tj3989c98naN3XUnCHlKjQHRe95jNJhanMYh6xpPiUcDQoWIgK6BUWNmSqLN0mIlKC4/u/FmJhaDWchk2eqi1lKHr5Z/wBXfOFLDpX+dbqs97yrINxl/YIJxoB3bH0RDzMC3Jh2i4hjC9W85f1l42/yqyGGsoA6pXUfn78nYMp6JFPzcRBgeL2+3yK7nHkjfKlRFaezwIDAQAB";
    private static final String PRIVATE_KEY = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCp8462lKLuEVr3/c1J4x+Sptpuj1wPi1tloYykNk2otU2XtOY3T0IuA7PEGwQytO3JcpVL9ztDYds1Ea5YEjZbtQGpK7dbtOtaOOqcqJDFSQFTK1dxFep/878hecL9w4BfoYYP+RZE7ulOkPQ/xuyWQI+IhSx3cZKWznD8qgY8uIzbYnVuBYNpv5pVwAIexdU0EjmnOgBhG82bduGjgEQyIrXCON0jdL7fKtYRczBZxm2wNPpx2CeojFhqT9aCOAkAcodLmdpu57HHvFTGH4kPTgQ2i+/rppS8j1blWoGvIqFERz0JMHGKiqe1Btyjnrwg2lfp4FZjO604KZo3kPOrAgMBAAECggEAf69DK52kg6R6ahM/JyIC2JWPSr1edzdGJacoGT/LPNNqRm5dAHUFzbhuWQnLL6WLeWwjCv3mgouEu+xaxkR4npHxe34itj3JDPHyIlzq164v1qKbgZTrp9IjaS0n+KvnSPH73QhRWNz+YE67kycLHR/INtOHQv4LGk5jyRCcuwTW9f0rh5U0NHFHAnzRhI/TZSQETs8W7ak/s0uTTHC4iM72GLOjv2sHhPnsVJG33pRhyDeN+dhQOy48TJo2+u3/n7Wzzouj04z9eoLWg+BSTsLs+xJ9/1SF6gtAZJEySbchmnaX0TRwzqsn9MKovBX4jwTdr2lPKmOB2IA27TUCkQKBgQD1z95hJ7lJcKbf2V0q2R5ruSl6qPdtCdmgmc1CcKxC2gAFPqnqXaSsM+5mzrPPvtxVzL63+i2vFtH9d5Anqkv2Sew6JsnXkk6VsFxhatVybMC5SpdcK9i48QeKwayJ/XHc+2D/o05+P+WBPeY++43kgexkkPnFcgpqZAAVajvfPwKBgQCw/smbG5EOF+OgVb8LTIKMtyve/tMgRyEp+ks4sLjsLOljo8Y0FyVF7EVhguqSAbkKteY4D8tHGzl6s2izsY6egEzSM4zQdurmFZBW+wwU1JU9Ci0TrrzPGx/sv/sr+Q7oW/LHaFXXXays7a1cnt6v5LzIbmuZ6uiDGgd6JYr8lQKBgQDBE56T55TVR6P7zgstPc90Q8N98jwurH8Bc+1TE5drBzre48KpMRbIoB3RKOj58+uzhRgFAIBjt+QHWKOlVFFISfZAEvmV1vjdAOL/LeAseZnDsQBEyLf5RHFtHwU8ehO2xMkC4y4jYmMN6iXxMLvaUebxcyKNYS8nNBcQuxn+FwKBgBO5ILAnHz/py5THWVWh/f4+PyZHUTGMm5Z47L7xenne+1b+Hg0Z8y5aiNS36PnCNWOLJ49huy4+S2Zv7Z/wjkr9UxItamikh8KB7qayrQL5OXQm2SUTWLjfdexE7HFW/KFJ9cDg0IgCSUav6Zyjm38QRzUykM0DD0vkr6ad3mINAoGAcU1G/ILTXdGJJwUc3qIaksQD8jbh+QARNrJQhbC89uqAL0ARdv++8Rjq6BuTn6LSmDBVyYQC+QJCjvlTFeWZv4LQQX1Ra4WUjJaYPDxNfUlRXoz29hDVCFDFDcDzBt9qUiCUJRSJLawSe/Mo9SyC52C67CaGy5/be06cxYtXtbc=";
    private static final String APPID = "2019011062856975";
	@Override
	public boolean supports(HttpServletRequest request) {
		String userAgent = request.getHeader("USER-AGENT");
		System.out.println("内置浏览器获取的用户代理信息------"+userAgent);
		return !StringUtils.contains(userAgent.toLowerCase(), "micromessenger");
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {

		Map<String, String> parameterMap = new HashMap<>();

		AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do", APPID, PRIVATE_KEY, "json", "UTF-8", PUBLIC_KEY, "RSA2"); //获得初始化的AlipayClient
		AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();//创建API对应的request
		alipayRequest.setReturnUrl(getPostPayUrl(paymentPlugin, paymentTransaction));
		alipayRequest.setNotifyUrl(SystemUtils.getSetting().getSiteUrl()+"/notify/alipayCallBack_"+paymentTransaction.getSn());//在公共参数中设置回跳和通知地址
		alipayRequest.setBizContent("{\"out_trade_no\":\""+ paymentTransaction.getSn()+"\", \"total_amount\":" + paymentTransaction.getAmount().setScale(2).toString() + ",\"subject\":\""+StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 60)+"\",\"product_code\":\"FAST_INSTANT_TRADE_PAY\"}");//填充业务参数
		String form = alipayClient.pageExecute(alipayRequest,"GET").getBody(); //调用SDK生成表单
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.addObject("requestUrl", form);
		modelAndView.addObject("requestMethod", "POST");
		modelAndView.setViewName(PaymentPlugin.DEFAULT_PAY_VIEW_NAME);
	}

	@Override
	public void postPayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, boolean isPaySuccess, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		super.postPayHandle(paymentPlugin, paymentTransaction, paymentDescription, extra, isPaySuccess, request, response, modelAndView);

		if (StringUtils.equals(extra, "notify")) {
			modelAndView.addObject("message", "success");
		}
	}

	@Override
	public QueryPayStatusResponse queryPaySuccess(PaymentTransaction paymentTransaction) throws Exception {
		return null;
	}

    @Override
    public QueryOrderRefundStatusResponse queryOrderRefundSuccess(PaymentTransaction paymentTransaction) throws Exception {
        AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do",APPID,PRIVATE_KEY,"json","GBK",PUBLIC_KEY,"RSA2");
        AlipayTradeRefundRequest request = new AlipayTradeRefundRequest();
        request.setBizContent("{ \"out_trade_no\":\""+paymentTransaction.getSn()+"\",\"refund_amount\":\""+paymentTransaction.getAmount()+"\" }");
        AlipayTradeRefundResponse response = alipayClient.execute(request);
        QueryOrderRefundStatusResponse queryOrderRefundStatusResponse = new QueryOrderRefundStatusResponse();
        if (response.isSuccess()) {
            queryOrderRefundStatusResponse.setOrderRefundStatus(true);
        } else {
            queryOrderRefundStatusResponse.setOrderRefundStatus(false);
            queryOrderRefundStatusResponse.setMessage(response.getSubMsg());
        }
        return queryOrderRefundStatusResponse;
    }

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//获取支付宝GET过来反馈信息
		Map<String,String> params = new HashMap<String,String>();
		Map requestParams = request.getParameterMap();
		for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
			String name = (String) iter.next();
			String[] values = (String[]) requestParams.get(name);
			String valueStr = "";
			for (int i = 0; i < values.length; i++) {
				valueStr = (i == values.length - 1) ? valueStr + values[i]
						: valueStr + values[i] + ",";
			}
			//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
			valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
			params.put(name, valueStr);
		}

		//获取支付宝的通知返回参数
		//商户订单号

		String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");

		//支付宝交易号

		String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");

		//获取支付宝的通知返回参数
		//计算得出通知验证结果
		boolean verify_result = AlipaySignature.rsaCheckV1(params, PUBLIC_KEY, "UTF-8", "RSA2");
		String trade_status = new String((request.getParameter("trade_status")!= null?request.getParameter("trade_status"):"") .getBytes("ISO-8859-1"),"UTF-8");
		//获取支付宝的通知返回参数
		//计算得出通知验证结果
		if(verify_result) {
			//验证成功
			return trade_status.equals("TRADE_SUCCESS");
		}
		return false;
	}

	

}