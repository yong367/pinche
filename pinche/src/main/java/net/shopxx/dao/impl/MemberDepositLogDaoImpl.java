/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.MemberDepositLogDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.util.DateCollect;
import org.springframework.stereotype.Repository;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.Map;

/**
 * Dao - 会员预存款记录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class MemberDepositLogDaoImpl extends BaseDaoImpl<MemberDepositLog, Long> implements MemberDepositLogDao {

	public Page<MemberDepositLog> findPage(Member member, Pageable pageable, Map<String,Object> paramMap) {
        if (member == null) {
			return Page.emptyPage(pageable);
		}
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<MemberDepositLog> criteriaQuery = criteriaBuilder.createQuery(MemberDepositLog.class);
		Root<MemberDepositLog> root = criteriaQuery.from(MemberDepositLog.class);
		criteriaQuery.select(root);
        Predicate restrictions = criteriaBuilder.conjunction();
        restrictions = criteriaBuilder.equal(root.get("member"), member);
        try {
            restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.between(root.get("createdDate"), DateCollect.convertTimeToDate(paramMap.get("startTime")+""),DateCollect.convertTimeToDate(paramMap.get("endTime")+"")));
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(paramMap.get("type")!=null){
            restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), paramMap.get("type")));
        }
        criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

}