/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import com.fasterxml.jackson.annotation.JsonView;
import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AppliCashService;
import net.shopxx.service.MemberDepositLogService;
import net.shopxx.service.PluginService;
import net.shopxx.util.DateCollect;
import net.shopxx.util.WebUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller - 预存款
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberDepositController")
@RequestMapping("/member/deposit")
public class DepositController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private MemberDepositLogService memberDepositLogService;
	@Inject
	private AppliCashService appliCashService;
	@Inject
	private PluginService pluginService;

	/**
	 * 计算支付手续费
	 */
	@PostMapping("/calculate_fee")
	public ResponseEntity<?> calculateFee(String paymentPluginId, BigDecimal rechargeAmount) {
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		if (paymentPlugin == null) {
			return Results.NOT_FOUND;
		}
		if (!paymentPlugin.getIsEnabled() || rechargeAmount == null || rechargeAmount.compareTo(BigDecimal.ZERO) < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Map<String, Object> data = new HashMap<>();
		data.put("fee", paymentPlugin.calculateFee(rechargeAmount));
		return ResponseEntity.ok(data);
	}

	/**
	 * 检查余额
	 */
	@PostMapping("/check_balance")
	public ResponseEntity<?> checkBalance(@CurrentUser Member currentUser) {
		Map<String, Object> data = new HashMap<>();
		data.put("balance", currentUser.getBalance());
		return ResponseEntity.ok(data);
	}

	/**
	 * 充值
	 */
	@GetMapping("/recharge")
	public String recharge(ModelMap model) {
		List<PaymentPlugin> paymentPlugins = pluginService.getActivePaymentPlugins(WebUtils.getRequest());
		if (!paymentPlugins.isEmpty()) {
			model.addAttribute("defaultPaymentPlugin", paymentPlugins.get(0));
			model.addAttribute("paymentPlugins", paymentPlugins);
		}
		return "member/deposit/recharge";
	}

	/**
	 * 记录
	 */
	@GetMapping("/log")
	public String log(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
        Map<String,Object> paramMap=new HashMap<>();
        String startTime="2015-01-01 00:00:00";
        String endTime= DateCollect.getYMD();
        paramMap.put("startTime",startTime);
        paramMap.put("endTime",endTime);
        model.addAttribute("page", memberDepositLogService.findPage(currentUser, pageable,paramMap));
		return "member/deposit/walletDetail";
	}

	/**
	 * 提现记录
	 */
	@GetMapping("/appliCashLog")
	public String appliCashLog(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", appliCashService.findPage(currentUser, pageable));
		return "member/deposit/appliCashLog";
	}
	/**
	 * 提现记录
	 */
	@GetMapping(path = "/appliCashLog", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> appliCashLog(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(appliCashService.findPage(currentUser, pageable).getContent());
	}
	
	/**
	 * 记录
	 */
	@GetMapping(path = "/log", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> log(Integer pageNumber, @CurrentUser Member currentUser,
                                 @RequestParam(value = "startTime",defaultValue = "")String startTime,
                                 @RequestParam(value = "endTime",defaultValue = "")String endTime,
                                 @RequestParam(value = "type",defaultValue = "")String type) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
        Map<String,Object> paramMap=new HashMap<>();
        if(StringUtils.isEmpty(startTime)){
            startTime="2015-01-01 00:00:00";
        }else{
            startTime = startTime+" 00:00:00";
        }
        if(StringUtils.isEmpty(endTime)){
            endTime= DateCollect.getYMD();
        }
        endTime = endTime+" 00:00:00";
        if(StringUtils.isNotEmpty(type)){
            endTime= DateCollect.getYMD();
        }
        paramMap.put("startTime",startTime);
        paramMap.put("endTime",endTime);
        if(StringUtils.isNotEmpty(type)){
            paramMap.put("type", MemberDepositLog.Type.valueOf(type));
        }
		return ResponseEntity.ok(memberDepositLogService.findPage(currentUser, pageable,paramMap).getContent());
	}
	
}