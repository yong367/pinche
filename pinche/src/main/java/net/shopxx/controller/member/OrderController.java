/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import net.shopxx.entity.*;
import net.shopxx.service.ProductCouponService;
import net.shopxx.util.AESUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.OrderService;
import net.shopxx.service.OrderShippingService;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 订单
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberOrderController")
@RequestMapping("/member/order")
public class OrderController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private OrderService orderService;
	@Inject
	private OrderShippingService orderShippingService;

	@Inject
	private ProductCouponService productCouponService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(String orderSn, String orderShippingSn, @CurrentUser Member currentUser, ModelMap model) {
		Order order = orderService.findBySn(orderSn);
		if (order != null && !currentUser.equals(order.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("order", order);

		OrderShipping orderShipping = orderShippingService.findBySn(orderShippingSn);
		if (orderShipping != null && orderShipping.getOrder() != null && !currentUser.equals(orderShipping.getOrder().getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("orderShipping", orderShipping);
	}

	/**
	 * 检查锁定
	 */
	@PostMapping("/check_lock")
	public ResponseEntity<?> checkLock(@ModelAttribute(binding = false) Order order) {
		if (order == null) {
			return Results.NOT_FOUND;
		}

		if (!orderService.acquireLock(order)) {
			return Results.unprocessableEntity("member.order.locked");
		}
		return Results.OK;
	}

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public ResponseEntity<?> transitStep(@ModelAttribute(binding = false) OrderShipping orderShipping, @CurrentUser Member currentUser) {
		Map<String, Object> data = new HashMap<>();
		if (orderShipping == null) {
			return Results.NOT_FOUND;
		}

		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(orderShipping.getDeliveryCorpCode()) || StringUtils.isEmpty(orderShipping.getTrackingNo())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		data.put("transitSteps", orderShippingService.getTransitSteps(orderShipping));
		return ResponseEntity.ok(data);
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Order.Status status, Boolean hasExpired, Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		Setting setting = SystemUtils.getSetting();
		model.addAttribute("status", status);
		model.addAttribute("hasExpired", hasExpired);
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("page", orderService.findPage(null, status, null, currentUser, null, null, null, null, null, null, hasExpired, pageable));
		return "member/order/list";
	}

	/**
	 * 券码数据
	 */
	@GetMapping(path = "/productCoupon")
	@ResponseBody
	public Object productCoupon(String orderSn,@CurrentUser Member currentUser) {
			Map<String,Object> result = new HashMap<>();
			String status="error";
			Order order=orderService.findBySn(orderSn);
			if(order !=null && order.getMember().getId().equals(currentUser.getId())){
				List<ProductCoupon> list=productCouponService.findListByOrderSn(orderSn);
				List<Map<String,Object>> results=new ArrayList<>();
				if(list!=null && list.size()>0){
					status="success";
					for (ProductCoupon productCoupon:list) {
					Map<String,Object> m=new HashMap<>();
					m.put("codeValue",productCoupon.getCodeValue());
					m.put("softName",productCoupon.getSoftName());
					results.add(m);
					}
					result.put("list",results);
				}
			}
			result.put("status",status);
			return result;
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Order.Status status, Boolean hasExpired, Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(orderService.findPage(null, status, null, currentUser, null, null, null, null, null, null, hasExpired, pageable).getContent());
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false) Order order, @CurrentUser Member currentUser, ModelMap model) {
		if (order == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Setting setting = SystemUtils.getSetting();
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("order", order);
		generateOrderQRcode(model,order);
		return "member/order/view";
	}

	private void generateOrderQRcode(ModelMap model,Order order){
		if(order.getStatus().equals(Order.Status.pendingShipment)){
			Setting setting = SystemUtils.getSetting();
			String key = setting.getOrderQrCodeSignKey();
			String signStr = order.getSn()+"&"+System.currentTimeMillis();
//			model.addAttribute("qrCodeUrl", setting.getSiteUrl()+"/qrCode/orderQRcodeComplete?code="+AESUtils.AESEncode(key,signStr));
			model.addAttribute("qrCodeUrl", setting.getSiteUrl()+"/qrCode/preOrderQRcodeInfo?code="+AESUtils.ecodes(signStr,key));
		}
	}

	/**
	 * 取消
	 */
	@PostMapping("/cancel")
	public ResponseEntity<?> cancel(@ModelAttribute(binding = false) Order order, @CurrentUser Member currentUser) {
		if (order == null) {
			return Results.NOT_FOUND;
		}

		if (order.hasExpired() || (!Order.Status.pendingPayment.equals(order.getStatus()) && !Order.Status.pendingReview.equals(order.getStatus()))) {
			return Results.NOT_FOUND;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.unprocessableEntity("member.order.locked");
		}
		orderService.cancel(order);
		return Results.OK;
	}

	/**
	 * 收货
	 */
	@PostMapping("/receive")
	public ResponseEntity<?> receive(@ModelAttribute(binding = false) Order order, @CurrentUser Member currentUser) {
		if (order == null) {
			return Results.NOT_FOUND;
		}

		if (order.hasExpired() || !Order.Status.shipped.equals(order.getStatus())) {
			return Results.NOT_FOUND;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.unprocessableEntity("member.order.locked");
		}
		orderService.receive(order);
		return Results.OK;
	}

}