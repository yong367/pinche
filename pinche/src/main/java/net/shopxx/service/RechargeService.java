package net.shopxx.service;

import net.shopxx.entity.Member;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.bo.QueryRechargeStatusResponse;
import net.shopxx.entity.bo.RechargeResponse;

import java.util.Map;

public interface RechargeService {

    RechargeResponse pointRecharge(Member currentUser, String orderNo, String amount);
    QueryRechargeStatusResponse queryRechargeStatus(Member currentUser, PaymentTransaction paymentTransaction);
    void autoUpdateRechargeStatus(String orderId,Long memberId);

    RechargeResponse rongXuPointRecharge(Member currentUser, String mobile,String amount,String realAmount);
    RechargeResponse unicomRecharge(Member currentUser, String mobile,String amount,String realAmount,String code);
}
