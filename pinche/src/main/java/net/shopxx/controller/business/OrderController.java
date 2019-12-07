/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.entity.*;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.QueryOrderRefundStatusResponse;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.*;
import net.shopxx.util.DateCollect;
import net.shopxx.util.SystemUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Controller - 订单
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessOrderController")
@RequestMapping("/business/order")
public class OrderController extends BaseController {

	@Inject
	private AreaService areaService;
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
    @Inject
    private LogPrintService logPrintService;
	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long orderId, @CurrentStore Store currentStore, ModelMap model) {
		Order order = orderService.find(orderId);
		if (order != null && !currentStore.equals(order.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("order", order);
	}

	/**
	 * 获取订单锁
	 */
	@PostMapping("/acquire_lock")
	public @ResponseBody boolean acquireLock(@ModelAttribute(binding = false) Order order) {
		return order != null && orderService.acquireLock(order);
	}

	/**
	 * 计算
	 */
	@PostMapping("/calculate")
	public ResponseEntity<?> calculate(@ModelAttribute(binding = false) Order order, BigDecimal freight, BigDecimal tax, BigDecimal offsetAmount) {
		if (order == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		Map<String, Object> data = new HashMap<>();
		data.put("amount", orderService.calculateAmount(order.getPrice(), order.getFee(), freight, tax, order.getPromotionDiscount(), order.getCouponDiscount(), offsetAmount));
		return ResponseEntity.ok(data);
	}

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public ResponseEntity<?> transitStep(Long shippingId, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		OrderShipping orderShipping = orderShippingService.find(shippingId);
		if (orderShipping == null || !currentStore.equals(orderShipping.getOrder().getStore())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(orderShipping.getDeliveryCorpCode()) || StringUtils.isEmpty(orderShipping.getTrackingNo())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		data.put("transitSteps", orderShippingService.getTransitSteps(orderShipping));
		return ResponseEntity.ok(data);
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) Order order, ModelMap model) {
		if (order == null || order.hasExpired() || (!Order.Status.pendingPayment.equals(order.getStatus()) && !Order.Status.pendingReview.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		model.addAttribute("order", order);
		return "business/order/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute(binding = false) Order order, Long areaId, Long paymentMethodId, Long shippingMethodId, BigDecimal freight, BigDecimal tax, BigDecimal offsetAmount, Long rewardPoint, BigDecimal rewardDuiBan ,BigDecimal rewardYongJin,String consignee, String address, String zipCode, String phone, String invoiceTitle,
			String memo, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		Area area = areaService.find(areaId);
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		ShippingMethod shippingMethod = shippingMethodService.find(shippingMethodId);

		if (order == null || !orderService.acquireLock(order)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (order.hasExpired() || (!Order.Status.pendingPayment.equals(order.getStatus()) && !Order.Status.pendingReview.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Invoice invoice = StringUtils.isNotEmpty(invoiceTitle) ? new Invoice(invoiceTitle, null) : null;
		order.setTax(invoice != null ? tax : BigDecimal.ZERO);
		order.setOffsetAmount(offsetAmount);
		order.setRewardPoint(rewardPoint);
		order.setRewardDuiBan(rewardDuiBan);
		order.setRewardYongJin(rewardYongJin);
		order.setMemo(memo);
		order.setInvoice(invoice);
		order.setPaymentMethod(paymentMethod);
		if (order.getIsDelivery()) {
			order.setFreight(freight);
			order.setConsignee(consignee);
			order.setAddress(address);
			order.setZipCode(zipCode);
			order.setPhone(phone);
			order.setArea(area);
			order.setShippingMethod(shippingMethod);
			if (!isValid(order, Order.Delivery.class)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		} else {
			order.setFreight(BigDecimal.ZERO);
			order.setConsignee(null);
			order.setAreaName(null);
			order.setAddress(null);
			order.setZipCode(null);
			order.setPhone(null);
			order.setShippingMethodName(null);
			order.setArea(null);
			order.setShippingMethod(null);
			if (!isValid(order)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		}
		orderService.modify(order);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false) Order order, ModelMap model) {
		if (order == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Setting setting = SystemUtils.getSetting();

        isActivityProduct(order, model);
        model.addAttribute("methods", OrderPayment.Method.values());
        model.addAttribute("refundsMethods", OrderRefunds.Method.values());
        model.addAttribute("paymentMethods", paymentMethodService.findAll());
        model.addAttribute("shippingMethods", shippingMethodService.findAll());
        model.addAttribute("deliveryCorps", deliveryCorpService.findAll());
        model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("order", order);
		return "business/order/view";
	}
    /**
     * 判断是否为活动商品
     * @param order
     * @return
     */
    public void isActivityProduct(@ModelAttribute(binding = false) Order order, ModelMap model) {
        int activityProductSku = 1751;
        for (OrderItem orderItem : order.getOrderItems()) {
            boolean flag = false;
            if (orderItem.getSku() != null) {
                if (activityProductSku == orderItem.getSku().getId()) {
                    flag = true;
                 }
             model.addAttribute("flag",flag);
            }
        }
    }
    
   
	/**
	 * 审核
	 */
	@PostMapping("/review")
	public String review(@ModelAttribute(binding = false) Order order, Boolean passed, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.hasExpired() || !Order.Status.pendingReview.equals(order.getStatus()) || passed == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.review(order, passed);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 收款
	 */
	@PostMapping("/payment")
	public String payment(OrderPayment orderPaymentForm, @ModelAttribute(binding = false) Order order, Long paymentMethodId, @CurrentUser Business currentUser, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (order == null || !Store.Type.self.equals(currentStore.getType())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderPaymentForm.setOrder(order);
		orderPaymentForm.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(orderPaymentForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderPaymentForm.setFee(BigDecimal.ZERO);
		orderService.payment(order, orderPaymentForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 退款
	 */
	@PostMapping("/refunds")
	public String refunds(OrderRefunds orderRefundsForm, @ModelAttribute(binding = false) Order order, Long paymentMethodId, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes)throws Exception {
		if (order == null || order.getRefundableAmount().compareTo(BigDecimal.ZERO) <= 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderRefundsForm.setOrder(order);
		orderRefundsForm.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(orderRefundsForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (OrderRefunds.Method.deposit.equals(orderRefundsForm.getMethod()) && orderRefundsForm.getAmount().compareTo(order.getStore().getBusiness().getBalance()) > 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
        try{
            if (OrderRefunds.Method.deposit.equals(orderRefundsForm.getMethod())){
                //memberService.addBalance(order.getMember(),order.getAmount(), MemberDepositLog.Type.orderRefunds,"订单退款");
                orderService.refunds(order, orderRefundsForm);
            } else {
                for (PaymentTransaction paymentTransaction : order.getPaymentTransactions()) {
                    String paymentPluginId = paymentTransaction.getPaymentPluginId();
                    PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
                    if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
                        addFlashMessage(redirectAttributes, "支付插件不能为空");
                    } else {
                        // if (){}
                        QueryOrderRefundStatusResponse queryOrderRefundStatusResponse = paymentPlugin.queryOrderRefundSuccess(paymentTransaction);
                        if (queryOrderRefundStatusResponse.isOrderRefundStatus()) {
                            paymentTransactionService.handle(paymentTransaction);
                            addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
                            BigDecimal amount = order.getAmountPaid().subtract(paymentTransaction.getAmount());
                            if (amount.compareTo(BigDecimal.ZERO) == 1) {
                                memberService.addBalance(order.getMember(), amount, MemberDepositLog.Type.orderRefunds, "订单退款");
                            }
                            orderService.refunds(order, orderRefundsForm);
                            addFlashMessage(redirectAttributes, "订单退款成功" );
                        } else {
                            addFlashMessage(redirectAttributes, "订单退款失败," + queryOrderRefundStatusResponse.getMessage());
                        }
                    }

                }
            }

        }catch (Exception e){
            logPrintService.printServerLog(e.getMessage());
        }

		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 发货
	 */
	@PostMapping("/shipping")
	public String shipping(OrderShipping orderShippingForm, @ModelAttribute(binding = false) Order order, Long shippingMethodId, Long deliveryCorpId, Long areaId, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.getShippableQuantity() <= 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		boolean isDelivery = false;
		for (Iterator<OrderShippingItem> iterator = orderShippingForm.getOrderShippingItems().iterator(); iterator.hasNext();) {
			OrderShippingItem orderShippingItem = iterator.next();
			if (orderShippingItem == null || StringUtils.isEmpty(orderShippingItem.getSn()) || orderShippingItem.getQuantity() == null || orderShippingItem.getQuantity() <= 0) {
				iterator.remove();
				continue;
			}
			OrderItem orderItem = order.getOrderItem(orderShippingItem.getSn());
			if (orderItem == null || orderShippingItem.getQuantity() > orderItem.getShippableQuantity()) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			Sku sku = orderItem.getSku();
			if (sku != null && orderShippingItem.getQuantity() > sku.getStock()) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			orderShippingItem.setName(orderItem.getName());
			orderShippingItem.setIsDelivery(orderItem.getIsDelivery());
			orderShippingItem.setSku(sku);
			orderShippingItem.setOrderShipping(orderShippingForm);
			orderShippingItem.setSpecifications(orderItem.getSpecifications());
			if (orderItem.getIsDelivery()) {
				isDelivery = true;
			}
		}
		orderShippingForm.setOrder(order);
		orderShippingForm.setShippingMethod(shippingMethodService.find(shippingMethodId));
		orderShippingForm.setDeliveryCorp(deliveryCorpService.find(deliveryCorpId));
		orderShippingForm.setArea(areaService.find(areaId));
		if (isDelivery) {
			if (!isValid(orderShippingForm, OrderShipping.Delivery.class)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		} else {
			orderShippingForm.setShippingMethod((String) null);
			orderShippingForm.setDeliveryCorp((String) null);
			orderShippingForm.setDeliveryCorpUrl(null);
			orderShippingForm.setDeliveryCorpCode(null);
			orderShippingForm.setTrackingNo(null);
			orderShippingForm.setFreight(null);
			orderShippingForm.setConsignee(null);
			orderShippingForm.setArea((String) null);
			orderShippingForm.setAddress(null);
			orderShippingForm.setZipCode(null);
			orderShippingForm.setPhone(null);
			if (!isValid(orderShippingForm)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.shipping(order, orderShippingForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 退货
	 */
	@PostMapping("/returns")
	public String returns(OrderReturns orderReturnsForm, @ModelAttribute(binding = false) Order order, Long shippingMethodId, Long deliveryCorpId, Long areaId, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.getReturnableQuantity() <= 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		for (Iterator<OrderReturnsItem> iterator = orderReturnsForm.getOrderReturnsItems().iterator(); iterator.hasNext();) {
			OrderReturnsItem orderReturnsItem = iterator.next();
			if (orderReturnsItem == null || StringUtils.isEmpty(orderReturnsItem.getSn()) || orderReturnsItem.getQuantity() == null || orderReturnsItem.getQuantity() <= 0) {
				iterator.remove();
				continue;
			}
			OrderItem orderItem = order.getOrderItem(orderReturnsItem.getSn());
			if (orderItem == null || orderReturnsItem.getQuantity() > orderItem.getReturnableQuantity()) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			orderReturnsItem.setName(orderItem.getName());
			orderReturnsItem.setOrderReturns(orderReturnsForm);
			orderReturnsItem.setSpecifications(orderItem.getSpecifications());
		}
		orderReturnsForm.setOrder(order);
		orderReturnsForm.setShippingMethod(shippingMethodService.find(shippingMethodId));
		orderReturnsForm.setDeliveryCorp(deliveryCorpService.find(deliveryCorpId));
		orderReturnsForm.setArea(areaService.find(areaId));
		if (!isValid(orderReturnsForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.returns(order, orderReturnsForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 完成
	 */
	@PostMapping("/complete")
	public String complete(@ModelAttribute(binding = false) Order order, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.hasExpired() || !Order.Status.received.equals(order.getStatus())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.complete(order);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}
	/**
	 * 失败
	 */
	@PostMapping("/fail")
	public String fail(@ModelAttribute(binding = false) Order order, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.hasExpired() || (!Order.Status.pendingShipment.equals(order.getStatus()) && !Order.Status.shipped.equals(order.getStatus()) && !Order.Status.received.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.fail(order);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Order.Type type, Order.Status status, String memberUsername, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isAllocatedStock, Boolean hasExpired, Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
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
			model.addAttribute("page", orderService.findPage(type, status, currentStore, member, null, isPendingReceive, isPendingRefunds, null, null, isAllocatedStock, hasExpired, pageable));
		}
		return "business/order/list";
	}

	/**
	 * 导出列表
	 * @param type
	 * @param status
	 * @param memberUsername
	 * @param isPendingReceive
	 * @param isPendingRefunds
	 * @param isAllocatedStock
	 * @param hasExpired
	 * @param pageable
	 * @param currentStore
	 * @param model
	 * @return
	 */
	@GetMapping("/list/export")
	public String exportOrder(Order.Type type, Order.Status status, String memberUsername, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isAllocatedStock, Boolean hasExpired, Pageable pageable, @CurrentStore Store currentStore, ModelMap model,HttpServletResponse response) throws IOException {
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
			result.append(order.getMemo()).append(",");
			
			result.append(order.getSpecifications()).append(",");
			result.append("\n");
		}
		return result;
	}

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

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentUser Business currentUser, @CurrentStore Store currentStore) {
		if (ids != null) {
			for (Long id : ids) {
				Order order = orderService.find(id);
				if (order == null || !currentStore.equals(order.getStore())) {
					return Results.UNPROCESSABLE_ENTITY;
				}
				if (!orderService.acquireLock(order, currentUser)) {
					return Results.unprocessableEntity("business.order.deleteLockedNotAllowed", order.getSn());
				}
				if (!order.canDelete()) {
					return Results.unprocessableEntity("business.order.deleteStatusNotAllowed", order.getSn());
				}
			}
			orderService.delete(ids);
		}
		return Results.OK;
	}

}