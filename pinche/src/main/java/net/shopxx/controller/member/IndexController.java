/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import me.chanjar.weixin.common.bean.WxJsapiSignature;
import me.chanjar.weixin.common.exception.WxErrorException;
import me.chanjar.weixin.mp.api.WxMpService;
import net.shopxx.controller.shop.BaseController;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.inject.Inject;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

/**
 * Controller - 首页
 *
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberIndexController")
@RequestMapping("/member/index")
public class IndexController extends BaseController {

    /**
     * 最新订单数量
     */
    private static final int NEW_ORDER_SIZE = 3;

    @Inject
    private OrderService orderService;
    @Inject
    private CouponCodeService couponCodeService;
    @Inject
    private MessageService messageService;
    @Inject
    private ProductFavoriteService productFavoriteService;
    @Inject
    private ProductNotifyService productNotifyService;
    @Inject
    private ReviewService reviewService;
    @Inject
    private ConsultationService consultationService;

    @Inject
    private StoreFavoriteService storeFavoriteService;
    @Inject
    private WxMpService wxService;
    @Inject
    private LogPrintService logPrintService;
    @Inject
    private FansService fansService;
    @Inject
    private ServletContext servletContext;
    @Inject
    private MemberService memberService;
    @Inject
    private ShareCodeService shareCodeService;

    /**
     * 首页
     */
    @GetMapping
    public String index(@CurrentUser Member currentUser, ModelMap model, HttpServletRequest request) throws Exception{
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
        model.addAttribute("pendingPaymentOrderCount", orderService.count(null, Order.Status.pendingPayment, null, currentUser, null, null, null, null, null, null, false));
        model.addAttribute("pendingShipmentOrderCount", orderService.count(null, Order.Status.pendingShipment, null, currentUser, null, null, null, null, null, null, null));
        model.addAttribute("shippedOrderCount", orderService.count(null, Order.Status.shipped, null, currentUser, null, null, null, null, null, null, null));
        model.addAttribute("accomplishOrderCount", orderService.count(null, Order.Status.shipped, null, currentUser, null, null, null, null, null, null, null));
        model.addAttribute("messageCount", messageService.count(currentUser, false));
        model.addAttribute("couponCodeCount", couponCodeService.count(null, currentUser, null, false, false));
        model.addAttribute("productFavoriteCount", productFavoriteService.count(currentUser));
        model.addAttribute("productNotifyCount", productNotifyService.count(currentUser, null, null, null));
        model.addAttribute("reviewCount", reviewService.count(currentUser, null, null, null));
        model.addAttribute("storeFavoriteCount", storeFavoriteService.count(currentUser));
        model.addAttribute("consultationCount", consultationService.count(currentUser, null, null));
        model.addAttribute("newOrders", orderService.findList(null, null, null, currentUser, null, null, null, null, null, null, null, NEW_ORDER_SIZE, null, null));
        model.addAttribute("point",currentUser.getPoint());
        if(currentUser.getShareCodeImgUrl() == null) {
            currentUser.setShareCodeImgUrl(shareCodeService.generateShareCodeImgUrl(currentUser));
            memberService.update(currentUser);
        }
        Long fansCount = fansService.checkFenSiCount(currentUser);
        BigDecimal toDayYongJin=fansService.toDayYongJinSum(currentUser);
        model.addAttribute("fansCount",fansCount);
        model.addAttribute("toDayYongJin",toDayYongJin);
        model.addAttribute("myTaskCount",0);
        model.addAttribute("participateCount",0);
        return "member/index";
    }

    //设置
    @GetMapping("/setting")
    public String setting(@CurrentUser Member currentUser, ModelMap model) {
        return "member/shezhi";
    }

    //设置
    @GetMapping("page/{pageName}")
    public String about(@PathVariable("pageName") String pageName) {

        return "member/"+pageName;
    }
}