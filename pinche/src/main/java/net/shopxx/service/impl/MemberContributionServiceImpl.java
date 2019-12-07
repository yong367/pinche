package net.shopxx.service.impl;

import net.shopxx.dao.MemberContributionDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberContributionLog;
import net.shopxx.service.MemberContributionService;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.inject.Inject;
import java.math.BigDecimal;

/**
 * Service - 用户贡献值
 *
 * @author aibangban Team
 * @version 5.0
 */
@Service
public class MemberContributionServiceImpl extends BaseServiceImpl<MemberContributionLog,Long> implements MemberContributionService {
    @Inject
    private MemberContributionDao memberContributionDao;
    @Override
    public void addContributionLog(Member member, Member recommendMember, MemberContributionLog.Type type, BigDecimal memberParentDonationAmount) {
        Assert.notNull(member);
        Assert.notNull(recommendMember);
        Assert.notNull(type);
        Assert.notNull(memberParentDonationAmount);

        if (memberParentDonationAmount.compareTo(BigDecimal.ZERO) == 0) {
            return;
        }
        MemberContributionLog memberContribution = new MemberContributionLog();//保存贡献值记录
        memberContribution.setSenderMemeber(member);
        memberContribution.setReceiverMember(recommendMember);
        memberContribution.setType(MemberContributionLog.Type.order);
        memberContribution.setAmount(memberParentDonationAmount);
        memberContributionDao.persist(memberContribution);
    }
    
}
