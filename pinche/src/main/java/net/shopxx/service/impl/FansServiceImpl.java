package net.shopxx.service.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.MemberContributionDao;
import net.shopxx.dao.MemberDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberContributionLog;
import net.shopxx.service.FansService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
public class FansServiceImpl extends BaseServiceImpl<Member,Long> implements FansService{
    @Inject
    private MemberDao memberDao;
    @Inject
    private MemberContributionDao memberContributionDao;
    /**
     * 统计粉丝数量
     * @param member
     * @return
     */
    @Override
    public Long checkFenSiCount(Member member) {
        return memberDao.checkFenSiCount(member);
    }

    /**
     * 统计获得佣金
     * @param member
     * @return
     */
    @Override
    public BigDecimal yongJinSum(Member member) {
        return memberContributionDao.yongJinSum(member);
    }
    /**
     * 分页查找粉丝记录
     * @param member
     * @param pageable
     * @return
     */
    @Override
    public List<Map<String, Object>> findFansPage(Member member, Pageable pageable) {
        return memberDao.findFansPage(member,pageable);
    }
    /**
     * 查找贡献记录
     * @param member
     * @param pageable
     * @return
     */
    @Override
    public Page<MemberContributionLog> findPage(Member member, Pageable pageable) {
        return memberContributionDao.findPage(member,pageable);
    }

    @Override
    public BigDecimal toDayYongJinSum(Member currentUser) {
        return memberContributionDao.toDayYongJinSum(currentUser);
    }
}
