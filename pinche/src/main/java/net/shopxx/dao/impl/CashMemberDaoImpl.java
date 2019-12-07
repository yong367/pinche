/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.CashDao;
import net.shopxx.dao.CashMemberDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cash;
import net.shopxx.entity.CashMember;
import net.shopxx.entity.Member;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

/**
 * Dao - 提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class CashMemberDaoImpl extends BaseDaoImpl<CashMember, Long> implements CashMemberDao {

	@Override
	public Page<CashMember> findPage(Member member, Pageable pageable) {
		if (member == null) {
			return Page.emptyPage(pageable);
		}
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<CashMember> criteriaQuery = criteriaBuilder.createQuery(CashMember.class);
		Root<CashMember> root = criteriaQuery.from(CashMember.class);
		criteriaQuery.select(root);
		criteriaQuery.where(criteriaBuilder.equal(root.get("business"), member));
		return super.findPage(criteriaQuery, pageable);
	}

}