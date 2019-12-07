package net.shopxx.controller.notify;

import net.shopxx.controller.shop.BaseController;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.MobileRechargeLog;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.bo.zhogncheng.ZhongHuaConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.*;
import net.shopxx.util.MD5Util;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;

/**
 * 后台服务通知
 */
@Controller("serverNotifyController")
@RequestMapping("/notify")
public class ServerNotifyController extends BaseController {
    @Inject
    private PluginService pluginService;
    @Inject
    private PaymentTransactionService paymentTransactionService;
    @Inject
    private MobileRechargeService mobileRechargeService;
    @Inject
    private LogPrintService logPrintService;
    @Inject
    private MemberService memberService;



    /**
     * 支付后处理
     */
    @RequestMapping({ "/unicomCallBack_{paymentTransactionSn:[^_]+}", "/unicomCallBack_{paymentTransactionSn:[^_]+}_{extra}" })
    public void postPay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
        PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
        String returnMsg="SUCCESS";
        if (paymentTransaction == null) {
            returnMsg="ERROR";
        }
        String paymentPluginId = paymentTransaction.getPaymentPluginId();
        PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
        if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
            returnMsg="ERROR";
        }

        boolean isPaySuccess = paymentPlugin.isPaySuccess(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response);
        if (isPaySuccess) {
            paymentTransactionService.handle(paymentTransaction);
        }else{
            returnMsg="ERROR";
        }
        response.getWriter().write(returnMsg);
    }

    @RequestMapping({ "/alipayCallBack_{paymentTransactionSn:[^_]+}"})
    public void postAlipay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
        PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
        String returnMsg="SUCCESS";
        if (paymentTransaction == null) {
            returnMsg="ERROR";
        }
        String paymentPluginId = paymentTransaction.getPaymentPluginId();
        PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
        if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
            returnMsg="ERROR";
        }

        boolean isPaySuccess = paymentPlugin.isPaySuccess(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response);
        if (isPaySuccess) {
            paymentTransactionService.handle(paymentTransaction);
        }else{
            returnMsg="ERROR";
        }
        response.getWriter().write(returnMsg);
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
     * 话费充值通知
     */
    @PostMapping("/mobileRechargeNotify")
    public void mobileRechargeNotify(HttpServletRequest request, HttpServletResponse response,
                                     @RequestParam(value = "sporderid")String sporderid,@RequestParam(value = "orderid")String orderid,
                                     @RequestParam(value = "status")String status,
                                     @RequestParam(value = "finishmoney")String finishmoney,
                                     @RequestParam(value = "finishtime")String finishtime,
                                     @RequestParam(value = "voucherId",defaultValue = "")String voucherId,
                                     @RequestParam(value = "sign")String sign) throws Exception {

        logPrintService.printServerLog("recive zhongcheng mobile recharge notify body:[sporderid="+sporderid+",status="+status+",orderid="+orderid+"paymentTransactionSn="+sporderid+"]");
            String returnMsg="success";
            if(sign.equals(MD5Util.md5Encode(sporderid + orderid + status + finishmoney + finishtime + ZhongHuaConfig.key))){
                PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(sporderid);
                if (paymentTransaction == null) {
                    returnMsg="ERROR";
                }
                MobileRechargeLog mobileRechargeLog = mobileRechargeService.find("sn",sporderid);
               if(status.equals("success")){
                   if(!mobileRechargeLog.getRechargeStatus().equals(MobileRechargeLog.Status.completed)){
                       mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.completed);
                       mobileRechargeLog.setRequestCode("success");
                       mobileRechargeLog.setRequestMsg("success");
                       mobileRechargeService.update(mobileRechargeLog);
                   }
               }
                if(status.equals("fail")){
                    synchronized (mobileRechargeLog.getSn().intern()) {
                        if (mobileRechargeLog.getRechargeStatus().equals(MobileRechargeLog.Status.pendingProcess)) {
                            mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.failed);
                            mobileRechargeLog.setRequestCode("fail");
                            mobileRechargeLog.setRequestMsg("fail");
                            mobileRechargeService.update(mobileRechargeLog);
                            memberService.addBalance(mobileRechargeLog.getMember(), new BigDecimal(mobileRechargeLog.getAmount()), MemberDepositLog.Type.orderRefunds, "话费充值退款");
                        }
                    }
                }
            }else{
                returnMsg="ERROR";
            }
        response.getWriter().write(returnMsg);
    }


}
