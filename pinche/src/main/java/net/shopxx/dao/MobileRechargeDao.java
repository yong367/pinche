package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.MobileRechargeLog;

import java.math.BigDecimal;

public interface MobileRechargeDao extends BaseDao<MobileRechargeLog, Long>{
    Page<MobileRechargeLog> findPage(Member currentUser, Pageable pageable);
    //Page<MobileRechargeLog> findPage(Member currentUser, Pageable pageable,String mobile,String rechargeMonth);

    /**
     * 累计充值金额
     * @param currentUser
     * @return
     */
    Integer countRecharge(Member currentUser,String rechargeMonth);

}
