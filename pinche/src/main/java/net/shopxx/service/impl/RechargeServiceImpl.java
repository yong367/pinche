package net.shopxx.service.impl;

import com.fasterxml.jackson.annotation.JsonValue;
import com.github.rholder.retry.Retryer;
import com.github.rholder.retry.RetryerBuilder;
import com.github.rholder.retry.StopStrategies;
import com.github.rholder.retry.WaitStrategies;
import com.google.common.base.Predicates;
import net.shopxx.Setting;
import net.shopxx.dao.PaymentTransactionDao;
import net.shopxx.dao.SnDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.Sn;
import net.shopxx.entity.bo.QueryRechargeStatusResponse;
import net.shopxx.entity.bo.RechargeResponse;
import net.shopxx.service.*;
import net.shopxx.util.DateCollect;
import net.shopxx.util.SystemUtils;
import net.shopxx.util.WebUtils;
import org.apache.commons.lang.time.DateUtils;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import javax.imageio.ImageIO;
import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.TimeUnit;

@Service
public class RechargeServiceImpl implements RechargeService {

    private final String hostIp="http://pay.lifeabb.com";//"http://pay.lifeabb.com"

    @Inject
    private LogPrintService logPrintService;
    @Inject
    private SnDao snDao;
    @Inject
    private PaymentTransactionService paymentTransactionService;

    @Inject
    private MemberService memberService;

    @Override
    @Transactional
    public RechargeResponse pointRecharge(Member currentUser, String orderNo, String amount) {
        Map<String,Object> requestMap = new HashMap<>();

        RechargeResponse rechargeResponse = null;
        requestMap.put("mobile",currentUser.getUsername());
        requestMap.put("orderNo",orderNo);
        requestMap.put("amount",amount);
        requestMap.put("comment","爱帮伴用户充值");
        requestMap.put("operatorType","mobile");
        requestMap.put("chargeType","jifen");
        logPrintService.printServerLog("post to  ruyi recharge "+ requestMap.toString());
        String result = WebUtils.post(hostIp+"/ruyi/ws/recharge",requestMap);
        logPrintService.printServerLog("recive ruyi response "+result);
        if(StringUtils.hasText(result)){
            rechargeResponse = new RechargeResponse(result);
            if(rechargeResponse.isSuccess()){
                PaymentTransaction paymentTransaction = new PaymentTransaction();
                paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
                paymentTransaction.setType(PaymentTransaction.Type.DEPOSIT_RECHARGE);
                paymentTransaction.setAmount(new BigDecimal(amount));
                paymentTransaction.setFee(BigDecimal.ZERO);
                paymentTransaction.setIsSuccess(false);
                paymentTransaction.setParent(null);
                paymentTransaction.setChildren(null);
                paymentTransaction.setUser(currentUser);
                paymentTransaction.setExtendOne(rechargeResponse.getOrderId());//设置第三方订单号
                paymentTransactionService.save(paymentTransaction);
            }
        }
        return rechargeResponse;
    }



    @Override
    @Transactional
    public RechargeResponse rongXuPointRecharge(Member currentUser, String mobile,String amount,String realAmount) {
        Map<String,Object> requestMap = new HashMap<>();
        RechargeResponse rechargeResponse = null;
        requestMap.put("mobile",mobile);
        requestMap.put("comment","爱帮伴用户充值");
        requestMap.put("operatorType","mobile");
        requestMap.put("amount",realAmount);
        requestMap.put("chargeType","jifen");
        requestMap.put("chargeStyle","rongXuPay");
        logPrintService.printServerLog("post to  ruyi recharge "+ requestMap.toString());
        String result = WebUtils.post(hostIp+"/ruyi/ws/rongXuRecharge",requestMap);
        logPrintService.printServerLog("recive ruyi response "+result);
        if(StringUtils.hasText(result)){
            rechargeResponse = new RechargeResponse(result);
            if(rechargeResponse.isSuccess()){
                PaymentTransaction paymentTransaction = new PaymentTransaction();
                paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
                paymentTransaction.setType(PaymentTransaction.Type.DEPOSIT_RECHARGE);
                paymentTransaction.setAmount(new BigDecimal(amount));
                paymentTransaction.setFee(BigDecimal.ZERO);
                paymentTransaction.setIsSuccess(false);
                paymentTransaction.setParent(null);
                paymentTransaction.setChildren(null);
                paymentTransaction.setUser(currentUser);
                paymentTransaction.setExtendOne(rechargeResponse.getOrderId());//设置第三方订单号
                paymentTransactionService.save(paymentTransaction);
            }
        }
        return rechargeResponse;
    }

    @Override
    @Transactional
    public RechargeResponse unicomRecharge(Member currentUser, String mobile, String amount, String realAmount,String code) {
        Map<String,Object> requestMap = new HashMap<>();
        RechargeResponse rechargeResponse = null;
        requestMap.put("mobile",mobile);
        requestMap.put("amount",realAmount);
        requestMap.put("dynamicCode",code);
        logPrintService.printServerLog("post to  ruyi recharge "+ requestMap.toString());
        String result = WebUtils.post(hostIp+"/ruyi/ws/unicomRecharge",requestMap);
        logPrintService.printServerLog("recive ruyi response "+result);
        if(StringUtils.hasText(result)){
            rechargeResponse = new RechargeResponse(result);
            PaymentTransaction paymentTransaction = new PaymentTransaction();
            paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
            paymentTransaction.setType(PaymentTransaction.Type.DEPOSIT_RECHARGE);
            paymentTransaction.setAmount(new BigDecimal(amount));
            paymentTransaction.setFee(BigDecimal.ZERO);
            paymentTransaction.setIsSuccess(rechargeResponse.isSuccess());
            paymentTransaction.setParent(null);
            paymentTransaction.setChildren(null);
            paymentTransaction.setUser(currentUser);
            paymentTransaction.setExtendOne(rechargeResponse.getOrderId());//设置第三方订单号
            paymentTransactionService.save(paymentTransaction);
            if(rechargeResponse.isSuccess()){
                memberService.addBalance(currentUser, paymentTransaction.getAmount(), MemberDepositLog.Type.recharge, "联通积分充值");
                processRechargeRerund(currentUser);
            }

        }
        return rechargeResponse;
    }

    /**
     * 处理积分充值奖励(邀请人赠送佣金)
     * @param currentUser
     */
    private void processRechargeRerund(Member currentUser) {
        Member member = memberService.findByRecommendCode(currentUser.getRecommendCode());
        memberService.addBalance(member,new BigDecimal(1), MemberDepositLog.Type.recharge, "积分充值赠送");
    }

    @Override
    @Transactional
    public QueryRechargeStatusResponse queryRechargeStatus(Member currentUser,PaymentTransaction paymentTransaction) {
        Map<String,Object> requestMap = new HashMap<>();
        QueryRechargeStatusResponse queryRechargeStatusResponse = null;
        requestMap.put("orderId",paymentTransaction.getExtendOne());
        logPrintService.printServerLog("post to  ruyi  recharge query"+ requestMap.toString());
        String result = WebUtils.post(hostIp+"/ruyi/ws/checkPayStatus",requestMap);
        logPrintService.printServerLog("recive ruyi query response "+result);
        if(StringUtils.hasText(result)){
            queryRechargeStatusResponse = new QueryRechargeStatusResponse(result);
            if(queryRechargeStatusResponse.isSuccess() && queryRechargeStatusResponse.isPaySuccess() && !paymentTransaction.getIsSuccess()){
                if(queryRechargeStatusResponse.getAmount().compareTo(paymentTransaction.getAmount()) != 0){
                paymentTransaction.setAmount(queryRechargeStatusResponse.getAmount());
                }
                paymentTransaction.setIsSuccess(true);
                paymentTransactionService.update(paymentTransaction);
                try {
                    memberService.addBalance(currentUser, paymentTransaction.getAmount(), MemberDepositLog.Type.recharge, "电信积分充值");
                    processRechargeRerund(currentUser);
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        }
        return queryRechargeStatusResponse;
    }

    private int processRechargeAmount(int rechargeAmount){
        switch (rechargeAmount){
            case 1:return 0;
            case 3:return 1;
            case 5:return 3;
            case 10:return 5;
            case 20:return 10;
            case 30:return 20;
            case 50:return 30;
            case 100:return 50;
            default:return 0;
        }
    }

    @Override
    @Async("taskExecutor")
    @Transactional
    public void autoUpdateRechargeStatus(String orderId, final Long memberId){
        final PaymentTransaction paymentTransaction = paymentTransactionService.findByExtendOne(orderId);
        if (paymentTransaction != null) {
        try{
            Retryer<Boolean> retryer = RetryerBuilder.<Boolean>newBuilder()
                    .retryIfException()
                    .retryIfResult(Predicates.equalTo(false))
                    .withWaitStrategy(WaitStrategies.incrementingWait(60, TimeUnit.SECONDS, 30, TimeUnit.SECONDS))
                    .withStopStrategy(StopStrategies.stopAfterAttempt(5))
                    .build();
            retryer.call(new Callable<Boolean>() {
                @Override
                public Boolean call() throws Exception {
                    Member member = memberService.find(memberId);
                    QueryRechargeStatusResponse queryRechargeStatusResponse = null;
                    Map<String,Object> requestMap = new HashMap<>();
                    requestMap.put("orderId",paymentTransaction.getExtendOne());
                    logPrintService.printServerLog("post to  ruyi  recharge query"+ requestMap.toString());
                    String result = WebUtils.post(hostIp+"/ruyi/ws/checkPayStatus",requestMap);
                    logPrintService.printServerLog("recive ruyi query response "+result);
                    if(StringUtils.hasText(result)){
                        queryRechargeStatusResponse = new QueryRechargeStatusResponse(result);
                        if(queryRechargeStatusResponse.isSuccess() && queryRechargeStatusResponse.isPaySuccess() && !paymentTransaction.getIsSuccess()){
                            int rechargeAmount = queryRechargeStatusResponse.getAmount().intValue();//用户实际兑换金额
                            int userAmount = paymentTransaction.getAmount().intValue();//用户上报金额
                            int userAddAmount =0;
                            if(userAmount>=rechargeAmount){
                             userAddAmount =processRechargeAmount(rechargeAmount);
                            }else{
                                userAddAmount=userAmount;
                            }
                             paymentTransaction.setAmount(new BigDecimal(userAddAmount));
                            paymentTransaction.setIsSuccess(true);
                            paymentTransactionService.update(paymentTransaction);
                            try {
                                memberService.addBalance(member, paymentTransaction.getAmount(), MemberDepositLog.Type.recharge, "积分充值");
                                processRechargeRerund(member);
                            }catch (Exception e){
                                e.printStackTrace();
                            }
                        }
                    }
                       return  queryRechargeStatusResponse.isPaySuccess();
                }
            });
        }catch (Exception e){
            logPrintService.printServerLog(memberId+"用户充值"+paymentTransaction.getAmount().intValue()+"兑伴，订单ID："+paymentTransaction.getExtendOne()+"尝试10次失败！");
        }
        }
    }
}
