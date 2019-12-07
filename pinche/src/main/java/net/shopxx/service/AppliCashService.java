package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.AppliCash;
import net.shopxx.entity.Member;

import java.math.BigDecimal;

/**
 * 提现service
 */
public interface AppliCashService extends BaseService<AppliCash,Long> {

    /**
     * 申请提现
     *
     * @param appliCash
     *            提现
     * @param member
     *            会员
     */
    void applyCash(AppliCash appliCash, Member member);

    /**
     * 提现审核通过转账
     */
    void applyCashTransfer(AppliCash appliCash);
    /**
     * 查找提现记录分页
     *
     * @param member
     *            会员
     * @param pageable
     *            分页信息
     * @return 提现记录分页
     */
    Page<AppliCash> findPage(Member member, Pageable pageable);

    
    void queryCashStatus(String orderId, Long id);

    void wxNotifyMessage(AppliCash appliCash, Member member);

    BigDecimal findByApplyCashPluginTypeAndStatus(AppliCash.cashMethod cashMethod, Member currentUser);
}
