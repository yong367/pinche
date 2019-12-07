package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberContributionLog;

import java.math.BigDecimal;

/**
 * Dao - 用户贡献值
 *
 * @author aibangban Team
 * @version 5.0
 */
public interface MemberContributionDao extends BaseDao<MemberContributionLog,Long> {
    /**
     * 查找贡献记录
     * @param member
     * @param pageable
     * @return
     */
    Page<MemberContributionLog> findPage(Member member, Pageable pageable);
    /**
     * 查询获得总佣金
     * @param member
     * @return
     */
    BigDecimal yongJinSum(Member member);

    BigDecimal toDayYongJinSum(Member currentUser);
}
