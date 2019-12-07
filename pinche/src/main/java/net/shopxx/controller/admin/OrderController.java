/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.Setting;
import net.shopxx.entity.*;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.QueryPayStatusResponse;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.*;
import net.shopxx.util.DateCollect;
import net.shopxx.util.SystemUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import javax.management.Query;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller - 订单
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminOrderController")
@RequestMapping("/admin/order")
public class OrderController extends BaseController {

	@Inject
	private OrderService orderService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private PaymentMethodService paymentMethodService;
	@Inject
	private DeliveryCorpService deliveryCorpService;
	@Inject
	private OrderShippingService orderShippingService;
	@Inject
	private MemberService memberService;
	@Inject
	private PluginService pluginService;
	@Inject
	private PaymentTransactionService paymentTransactionService;

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public @ResponseBody Map<String, Object> transitStep(Long shippingId) {
		Map<String, Object> data = new HashMap<>();
		OrderShipping orderShipping = orderShippingService.find(shippingId);
		if (orderShipping == null) {
			data.put("message", ERROR_MESSAGE);
			return data;
		}
		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(orderShipping.getDeliveryCorpCode()) || StringUtils.isEmpty(orderShipping.getTrackingNo())) {
			data.put("message", ERROR_MESSAGE);
			return data;
		}
		data.put("message", SUCCESS_MESSAGE);
		data.put("transitSteps", orderShippingService.getTransitSteps(orderShipping));
		return data;
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(Long id, ModelMap model) {
		Setting setting = SystemUtils.getSetting();
		model.addAttribute("methods", OrderPayment.Method.values());
		model.addAttribute("refundsMethods", OrderRefunds.Method.values());
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		model.addAttribute("deliveryCorps", deliveryCorpService.findAll());
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("order", orderService.find(id));
		return "admin/order/view";
	}

	/**
	 * 列表
	 */
	@GetMapping("/queryPayStatus")
	@ResponseBody
	public Object queryPayStatus(Long orderId) throws Exception {
		Map<String,String> result= new HashMap<>();
		String status="success";
		String msg="";
		Order order=orderService.find(orderId);
		if (order == null) {
			status="error";
			msg="param error!";
		}else{
			if(Order.Status.pendingPayment.equals(order.getStatus())){
				for (PaymentTransaction paymentTransaction:order.getPaymentTransactions()) {
					String paymentPluginId = paymentTransaction.getPaymentPluginId();
					PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
					if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
						status="error";
						msg="支付插件不能为空";
					}else{
						QueryPayStatusResponse queryPayStatusResponse=paymentPlugin.queryPaySuccess(paymentTransaction);
						if(queryPayStatusResponse.isPayStatus()){
							paymentTransactionService.handle(paymentTransaction);
						}
					}
				}
			}else{
				status="error";
				msg="当前订单已支付成功！";
			}
		}
		result.put("status",status);
		result.put("msg",msg);
		return  result;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Order.Type type, Order.Status status, String memberUsername, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isAllocatedStock, Boolean hasExpired, Pageable pageable, ModelMap model) {
		model.addAttribute("types", Order.Type.values());
		model.addAttribute("statuses", Order.Status.values());
		model.addAttribute("type", type);
		model.addAttribute("status", status);
		model.addAttribute("memberUsername", memberUsername);
		model.addAttribute("isPendingReceive", isPendingReceive);
		model.addAttribute("isPendingRefunds", isPendingRefunds);
		model.addAttribute("isAllocatedStock", isAllocatedStock);
		model.addAttribute("hasExpired", hasExpired);

		Member member = memberService.findByUsername(memberUsername);
		if (StringUtils.isNotEmpty(memberUsername) && member == null) {
			model.addAttribute("page", Page.emptyPage(pageable));
		} else {
			model.addAttribute("page", orderService.findPage(type, status, null, member, null, isPendingReceive, isPendingRefunds, null, null, isAllocatedStock, hasExpired, pageable));
		}
		return "admin/order/list";
	}

	/**
	 * 列表导出
	 */
	@GetMapping("/list/export")
	public String exportOrder(Order.Type type, Order.Status status, String memberUsername, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isAllocatedStock, Boolean hasExpired, Pageable pageable, @CurrentStore Store currentStore, ModelMap model, HttpServletResponse response) throws IOException {
		Member member = memberService.findByUsername(memberUsername);
		if (StringUtils.isNotEmpty(memberUsername) && member == null) {
			return null;
		} else {
			StringBuilder result = new StringBuilder("编号,订单金额,会员,店铺,收货人,收货地址,配送方式,创建时间,订单状态,买家留言,商品规格\n");;
			pageable.setPageNumber(1);
			Page<Order> pageList=orderService.findPage(type, status, currentStore, member, null, isPendingReceive, isPendingRefunds, null, null, isAllocatedStock, hasExpired, pageable);
			int totalPages = pageList.getTotalPages();
			for(int i=1;i<totalPages+1;i++){
				Page<Order> list = null;
				if(i==1){
					list =  pageList;
				}else{
					pageable.setPageNumber(i);
					list=orderService.findPage(type, status, currentStore, member, null, isPendingReceive, isPendingRefunds, null, null, isAllocatedStock, hasExpired, pageable);
				}
				result= jointResult(result,list);
			}
			String filename = "exportOrder.csv";
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=" + filename);
			response.setContentType("application/octet-stream;charset=GBK");
			response.getWriter().write(result.toString());
		}
		return null;
	}

	private StringBuilder jointResult(StringBuilder result,Page<Order> list){
		for (Order order : list.getContent()) {
			result.append("\t"+order.getSn()).append(",");
			result.append(order.getAmount()).append(",");
			result.append("\t"+order.getMember().getUsername()).append(",");
			result.append("\t"+order.getStore().getName()).append(",");
			result.append(order.getConsignee()).append(",");
			result.append(order.getAreaName()+order.getAddress()).append(",");
			result.append(order.getShippingMethod()!=null?order.getShippingMethod().getName():"null").append(",");
			result.append(DateCollect.getDateStr(order.getCreatedDate(),DateCollect.SDF_VERSION2)).append(",");
			result.append(processOrderStatus(order.getStatus())).append(",");
			//result.append(processOrderItems(order.getOrderItems())).append(",");
			result.append(order.getMemo()).append(",");
            result.append(order.getSpecifications()).append(",");
			result.append("\n");
		}
		return result;
	}

//	private String processOrderItems(List<OrderItem> list){
//		if(list.size()>0){
//			String str="[";
//			for (OrderItem item: list) {
//
//				str+= "{商品名称:"+item.getName()+";商品价格:"+item.getSku().getPrice()+";商品数量:"+item.getQuantity()+"}-";
//			}
//			 str = str.substring(0,str.length()-1)+"]";
//			return str;
//		}
//
//		return "";
//	}

	private String processOrderStatus(Order.Status status){
		switch (status){
			case failed:
				return "已失败";
			case denied:
				return "已拒绝";
			case completed:
				return "已完成";
			case canceled:
				return "已取消";
			case pendingReview:
				return "等待审核";
			case pendingPayment:
				return "等待付款";
			case pendingShipment:
				return "等待发货";
			case shipped:
				return "已发货";
			case received:
				return "已收货";
			default:return "";
		}
	}


}