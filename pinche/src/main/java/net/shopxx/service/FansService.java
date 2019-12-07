package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberContributionLog;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface FansService extends BaseService<Member,Long>{
    /**
     * 统计粉丝数量
     * @param member
     * @return
     */
    Long checkFenSiCount(Member member);
    /**
     * 统计获得佣金
     * @param member
     * @return
     */
    BigDecimal yongJinSum(Member member);

    /**
     * 分页查找粉丝记录
     * @param member
     * @param pageable
     * @return
     */
    List<Map<String, Object>> findFansPage(Member member, Pageable pageable);
    /**
     * 分页查找贡献记录
     */
    public Page<MemberContributionLog> findPage(Member member, Pageable pageable);

    BigDecimal toDayYongJinSum(Member currentUser);
}
