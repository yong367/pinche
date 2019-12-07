package net.shopxx.service;

import net.shopxx.entity.Member;
import net.shopxx.entity.MemberContributionLog;

import java.math.BigDecimal;

/**
 * Service - 用户贡献值
 *
 * @author aibangban Team
 * @version 5.0
 */
public interface MemberContributionService extends BaseService<MemberContributionLog,Long> {
    /**
     *
     * @param member 贡献提供方
     * @param recommendMember 贡献接受方
     * @param type 贡献类型
     * @param memberParentDonationAmount 贡献金额
     */
    void addContributionLog(Member member, Member recommendMember, MemberContributionLog.Type type, BigDecimal memberParentDonationAmount);

   
}
