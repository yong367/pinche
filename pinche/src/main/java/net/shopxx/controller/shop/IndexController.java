/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import me.chanjar.weixin.common.bean.WxJsapiSignature;
import me.chanjar.weixin.common.exception.WxErrorException;
import me.chanjar.weixin.mp.api.WxMpService;
import net.shopxx.service.LogPrintService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

/**
 * Controller - 首页
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopIndexController")
@RequestMapping("/")
public class IndexController extends BaseController {

	@Inject
	private WxMpService wxService;
    @Inject
    private LogPrintService logPrintService;

	/**
	 * 首页
	 */
	@GetMapping
	public String index(ModelMap model, HttpServletRequest request) {
		WxJsapiSignature signature;
		try {
			signature = wxService.createJsapiSignature(request.getRequestURL().toString());
			model.addAttribute("appId", signature.getAppId());
			model.addAttribute("timestamp", signature.getTimestamp());
			model.addAttribute("nonceStr",signature.getNonceStr());
			model.addAttribute("signature",signature.getSignature());
		} catch (WxErrorException e) {
			logPrintService.printServerLog("微信二维码扫描获取相关认证信息出错"+e.getMessage());
		}
		return "shop/index";
	}
}