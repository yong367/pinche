/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;


import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StoreClerkDao;


import net.shopxx.entity.Store;
import net.shopxx.entity.StoreClerk;

import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;


/**
 * Dao - 店铺店员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class StoreClerkDaoImpl extends BaseDaoImpl<StoreClerk, Long> implements StoreClerkDao {

	public Page<StoreClerk> findPage(Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<StoreClerk> criteriaQuery = criteriaBuilder.createQuery(StoreClerk.class);
		Root<StoreClerk> root = criteriaQuery.from(StoreClerk.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

	public boolean openIdExists(String openId) {
			String jpql = "select count(*) from StoreClerk storeClerk where storeClerk.openId = :openId";
			Long count = entityManager.createQuery(jpql, Long.class).setParameter("openId", openId).getSingleResult();
			if (count == 0) {
				return false;
			}
			return true;
	}

}