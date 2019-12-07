package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.MobileRechargeDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MobileRechargeLog;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.sql.DataSource;
import java.math.BigDecimal;

@Repository
public class MobileRechargeDaoImpl extends BaseDaoImpl<MobileRechargeLog, Long> implements MobileRechargeDao {
    @Inject
    private DataSource dataSource;
    protected JdbcTemplate jdbcTemplate;
    @PostConstruct
    private void afterConstruct() {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }
    @Override
    public Page<MobileRechargeLog> findPage(Member currentUser, Pageable pageable) {
        if (currentUser == null) {
            return Page.emptyPage(pageable);
        }
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<MobileRechargeLog> criteriaQuery = criteriaBuilder.createQuery(MobileRechargeLog.class);
        Root<MobileRechargeLog> root = criteriaQuery.from(MobileRechargeLog.class);
        criteriaQuery.select(root);
        Predicate restrictions = criteriaBuilder.conjunction();
        restrictions = criteriaBuilder.and(restrictions,criteriaBuilder.equal(root.get("member"), currentUser));
//        if (mobile != null) {
//            restrictions = criteriaBuilder.and(restrictions,criteriaBuilder.like(root.get("mobile"), "%"+mobile+"%"));
//        }
//        if (rechargeMonth != null) {
//            restrictions = criteriaBuilder.and(restrictions,criteriaBuilder.equal(root.get("rechargeDate"), rechargeMonth));
//        }
        criteriaQuery.where(restrictions);
        return super.findPage(criteriaQuery, pageable);
    }

    /**
     * 累计充值金额
     * @param currentUser
     * @return
     */
    @Override
    public Integer countRecharge(Member currentUser,String rechargeMonth) {
        String sql = "select sum(amount) from MobileRechargeLog where member_id="+currentUser.getId()+" and rechargeStatus ="+MobileRechargeLog.Status.completed.ordinal()+" and rechargeDate = "+rechargeMonth+"";
        Integer countRecharge = jdbcTemplate.queryForObject(sql,Integer.class);
        if (countRecharge == null){
            countRecharge = 0;
        }
        return countRecharge;
    }

}

