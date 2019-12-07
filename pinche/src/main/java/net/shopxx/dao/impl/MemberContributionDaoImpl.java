package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.MemberContributionDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberContributionLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.math.BigDecimal;


/**
 * Dao - 用户贡献值
 *
 * @author aibangban Team
 * @version 5.0
 */
@Repository
public class MemberContributionDaoImpl extends BaseDaoImpl<MemberContributionLog,Long> implements MemberContributionDao {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Override
    public Page<MemberContributionLog> findPage(Member member, Pageable pageable) {
        if (member == null) {
            return Page.emptyPage(pageable);
        }
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<MemberContributionLog> criteriaQuery = criteriaBuilder.createQuery(MemberContributionLog.class);
        Root<MemberContributionLog> root = criteriaQuery.from(MemberContributionLog.class);
        criteriaQuery.select(root);
        criteriaQuery.where(criteriaBuilder.equal(root.get("receiverMember"), member));
        return super.findPage(criteriaQuery, pageable);
    }

    /**
     * 查找佣金总额
     * @param member
     * @return
     */
    @Override
    public BigDecimal yongJinSum(Member member) {
        String jpql = "SELECT sum(mem.amount) from MemberContributionLog mem where mem.receiverMember = "+member.getId();
        BigDecimal yongJin = entityManager.createQuery(jpql, BigDecimal.class).getSingleResult();
        if (yongJin == null) {
            return BigDecimal.valueOf(0);
        }
        return yongJin;
    }

    @Override
    public BigDecimal toDayYongJinSum(Member currentUser) {
        String sql="SELECT sum(mem.amount) from MemberContributionLog mem where mem.receiverMember_id = ? and TO_DAYS(mem.createdDate)=TO_DAYS(NOW())";
        BigDecimal toDayYongJin = jdbcTemplate.queryForObject(sql, BigDecimal.class, currentUser.getId());
        if (toDayYongJin == null) {
            return BigDecimal.valueOf(0);
        }
        return toDayYongJin;
    }
}
