package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.AppliCash;

import java.math.BigDecimal;

public interface AppliCashDao extends BaseDao<AppliCash,Long> {
    /**
     * 查找提现记录分页
     *
     * @param member
     *            huiyuan
     * @param pageable
     *            分页信息
     * @return 提现记录分页
     */
    Page<AppliCash> findPage(Member member, Pageable pageable);

    BigDecimal findByApplyCashPluginTypeAndStatus(AppliCash.cashMethod cashMethod, Member currentUser);
}
