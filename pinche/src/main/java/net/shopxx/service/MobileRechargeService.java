package net.shopxx.service;

import net.shopxx.Message;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.MobileRechargeLog;

import java.math.BigDecimal;

public interface MobileRechargeService extends BaseService<MobileRechargeLog, Long>{
    MobileRechargeLog mobileRecharge(String mobile, int amount,Member member);
    void mobileQueryRecharge(MobileRechargeLog mobileRechargeLog);
    Page<MobileRechargeLog> findPage(Member currentUser, Pageable pageable);
    //Page<MobileRechargeLog> findPage(Member currentUser, Pageable pageable,String mobile,String rechargeMonth);

    /**
     * 累计充值数量
     * @param currentUser
     * @return
     */
    Integer countRecharge(Member currentUser,String rechargeMonth);

    MobileRechargeLog prizemobileRecharge(String mobile, Integer virtualNumerical, Member member);
}
