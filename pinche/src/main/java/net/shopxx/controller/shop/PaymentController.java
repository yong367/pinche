/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import java.util.*;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.shopxx.Results;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PaymentItem;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PaymentTransaction.LineItem;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.PaymentTransactionService;
import net.shopxx.service.PluginService;

/**
 * Controller - 支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopPaymentController")
@RequestMapping("/payment")
public class PaymentController extends BaseController {

	@Inject
	private PluginService pluginService;
	@Inject
	private PaymentTransactionService paymentTransactionService;

	/**
	 * 检查是否支付成功
	 */
	@PostMapping("/check_is_pay_success")
	public @ResponseBody boolean checkIsPaySuccess(String paymentTransactionSn) {
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		return paymentTransaction != null && paymentTransaction.getIsSuccess();
	}

	/**
	 * 首页
	 */
	@RequestMapping
	public ResponseEntity<?> index(String paymentPluginId, PaymentItemListForm paymentItemListForm) {
		Map<String, Object> data = new HashMap<>();
		System.out.println("进入支付方法1-----------------------------------------------"+paymentPluginId);
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		System.out.println("进入支付方法-----------------------------------------------"+paymentPlugin ==null ? "支付插件是空.":"支付插件不为空");
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			/*return UNPROCESSABLE_ENTITY_VIEW;*/
			return Results.UNPROCESSABLE_ENTITY;
		}
		System.out.println("进入支付方法验证支付插件通过-----------------------------------------------");
		List<PaymentItem> paymentItems = paymentItemListForm != null ? paymentItemListForm.getPaymentItemList() : null;
		if (CollectionUtils.isEmpty(paymentItems)) {
			/*return UNPROCESSABLE_ENTITY_VIEW;*/
			return Results.UNPROCESSABLE_ENTITY;
		}
		System.out.println("支付方法所有验证通过-----------------------------------------------");
		PaymentTransaction paymentTransaction = null;
		if (paymentItems.size() > 1) {
			System.out.println("paymentItems 大于0-----------------------------------------------");
			Set<PaymentTransaction.LineItem> lineItems = new HashSet<>();
			for (PaymentItem paymentItem : paymentItems) {
				LineItem lineItem = paymentTransactionService.generate(paymentItem);
				if (lineItem != null) {
					lineItems.add(lineItem);
				}
			}
			paymentTransaction = paymentTransactionService.generateParent(lineItems, paymentPlugin);
		} else {
			System.out.println("paymentItems 小于0-----------------------------------------------"+paymentItems.size());
			PaymentItem paymentItem = paymentItems.get(0);
			LineItem lineItem = paymentTransactionService.generate(paymentItem);
			paymentTransaction = paymentTransactionService.generate(lineItem, paymentPlugin);
		}
		String url=paymentPlugin.getPrePayUrl(paymentPlugin, paymentTransaction);
		System.out.println("请求微信支付的URL="+url);
		data.put("url", url);
		return ResponseEntity.ok(data);
		/*return "redirect:" + paymentPlugin.getPrePayUrl(paymentPlugin, paymentTransaction);*/
	}

	/**
	 * 支付前处理
	 */
	@RequestMapping({ "/pre_pay_{paymentTransactionSn:[^_]+}", "/pre_pay_{paymentTransactionSn[^_]+}_{extra}" })
	public ModelAndView prePay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("支付订单进入前置处理-----------------------------------------------");
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		if (paymentTransaction == null || paymentTransaction.hasExpired()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		if (paymentTransaction.getIsSuccess()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW, "errorMessage", message("shop.payment.payCompleted"));
		}
		System.out.println("支付订单进入前置处理所有验证通过-----------------------------------------------");
		String paymentPluginId = paymentTransaction.getPaymentPluginId();
		PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		ModelAndView modelAndView = new ModelAndView();
		paymentPlugin.prePayHandle(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 支付处理
	 */
	@RequestMapping({ "/pay_{paymentTransactionSn:[^_]+}", "/pay_{paymentTransactionSn[^_]+}_{extra}" })
	public ModelAndView pay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("支付订单进入支付处理-----------------------------------------------");
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		if (paymentTransaction == null || paymentTransaction.hasExpired()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		if (paymentTransaction.getIsSuccess()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW, "errorMessage", message("shop.payment.payCompleted"));
		}
		System.out.println("支付订单进入支付处理所有验证通过-----------------------------------------------");
		String paymentPluginId = paymentTransaction.getPaymentPluginId();
		PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		ModelAndView modelAndView = new ModelAndView();
		paymentPlugin.payHandle(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 支付后处理
	 */
	@RequestMapping({ "/post_pay_{paymentTransactionSn:[^_]+}", "/post_pay_{paymentTransactionSn:[^_]+}_{extra}" })
	public ModelAndView postPay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		if (paymentTransaction == null) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		String paymentPluginId = paymentTransaction.getPaymentPluginId();
		PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		boolean isPaySuccess = paymentPlugin.isPaySuccess(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response);
		if (isPaySuccess) {
			paymentTransactionService.handle(paymentTransaction);
		}
		ModelAndView modelAndView = new ModelAndView();
		paymentPlugin.postPayHandle(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, isPaySuccess, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 获取支付描述
	 * 
	 * @param paymentTransaction
	 *            支付事务
	 * @return 支付描述
	 */
	private String getPaymentDescription(PaymentTransaction paymentTransaction) {
		Assert.notNull(paymentTransaction);
		if (CollectionUtils.isEmpty(paymentTransaction.getChildren())) {
			Assert.notNull(paymentTransaction.getType());
		} else {
			return message("shop.payment.paymentDescription", paymentTransaction.getSn());
		}

		switch (paymentTransaction.getType()) {
		case ORDER_PAYMENT:
			return message("shop.payment.orderPaymentDescription", paymentTransaction.getOrder().getSn());
		case SVC_PAYMENT:
			return message("shop.payment.svcPaymentDescription", paymentTransaction.getSvc().getSn());
		case DEPOSIT_RECHARGE:
			return message("shop.payment.depositRechargeDescription", paymentTransaction.getSn());
		case BAIL_PAYMENT:
			return message("shop.payment.bailPaymentDescription", paymentTransaction.getSn());
		default:
			return message("shop.payment.paymentDescription", paymentTransaction.getSn());
		}
	}

	/**
	 * FormBean - 支付项
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	public static class PaymentItemListForm {

		/**
		 * 支付项
		 */
		private List<PaymentItem> paymentItemList;

		/**
		 * 获取支付项
		 * 
		 * @return 支付项
		 */
		public List<PaymentItem> getPaymentItemList() {
			return paymentItemList;
		}

		/**
		 * 设置支付项
		 * 
		 * @param paymentItemList
		 *            支付项
		 */
		public void setPaymentItemList(List<PaymentItem> paymentItemList) {
			this.paymentItemList = paymentItemList;
		}
	}

}