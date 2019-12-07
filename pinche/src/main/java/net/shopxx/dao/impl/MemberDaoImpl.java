/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.MemberDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAttribute;
import org.springframework.stereotype.Repository;

import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.*;

/**
 * Dao - 会员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class MemberDaoImpl extends BaseDaoImpl<Member, Long> implements MemberDao {

	public Page<Member> findPage(Member.RankingType rankingType, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Member> criteriaQuery = criteriaBuilder.createQuery(Member.class);
		Root<Member> root = criteriaQuery.from(Member.class);
		criteriaQuery.select(root);
		if (rankingType != null) {
			switch (rankingType) {
			case point:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("point")));
				break;
			case balance:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("balance")));
				break;
			case amount:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("amount")));
				break;
			}
		}
		return super.findPage(criteriaQuery, pageable);
	}

	public Long registerMemberCount(Date beginDate, Date endDate) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Member> criteriaQuery = criteriaBuilder.createQuery(Member.class);
		Root<Member> root = criteriaQuery.from(Member.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (beginDate != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.greaterThanOrEqualTo(root.<Date>get("createdDate"), beginDate));
		}
		if (endDate != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.lessThanOrEqualTo(root.<Date>get("createdDate"), endDate));
		}
		criteriaQuery.where(restrictions);
		return super.count(criteriaQuery, null);
	}

	public void clearAttributeValue(MemberAttribute memberAttribute) {
		if (memberAttribute == null || memberAttribute.getType() == null || memberAttribute.getPropertyIndex() == null) {
			return;
		}

		String propertyName;
		switch (memberAttribute.getType()) {
		case text:
		case select:
		case checkbox:
			propertyName = Member.ATTRIBUTE_VALUE_PROPERTY_NAME_PREFIX + memberAttribute.getPropertyIndex();
			break;
		default:
			propertyName = String.valueOf(memberAttribute.getType());
			break;
		}
		String jpql = "update Member mem set mem." + propertyName + " = null";
		entityManager.createQuery(jpql).executeUpdate();
	}

	@Override
	public Long checkFenSiCount(Member member) {
		//if (member != null) {
		String hql = "SELECT mem.shareCode from Member mem where mem.id = " + member.getId();
		String shareCode = entityManager.createQuery(hql, String.class).getSingleResult();
		String jpql = "SELECT count(*) from Member mem where mem.recommendCode = '"+shareCode+"'";
		//String jpql = "select count(*) from MemberAttribute memberAttribute where memberAttribute.propertyIndex = :propertyIndex";
		return entityManager.createQuery(jpql, Long.class).getSingleResult();
	}
	
	@Override
	public List<Map<String, Object>> findFansPage(Member member, Pageable pageable) {
        int pageNumber = pageable.getPageNumber();
        int pageSize = pageable.getPageSize();

        int firstIndex = pageSize * (pageNumber - 1);
        Query query = entityManager.createNativeQuery("select c.amount,m.nickName,m.username,m.imageUrl from Member m LEFT JOIN(select sum(amount) as amount,senderMemeber_id from MemberContributionLog where receiverMember_id="+member.getId()+" GROUP BY senderMemeber_id) c on m.id=c.senderMemeber_id where m.recommendCode='"+member.getShareCode()+"' limit " + firstIndex +"," + pageSize);
        List<Object[]> list = query.getResultList();
        List<Map<String, Object>> mapList = new ArrayList<>();
        if (list.size() > 0 && list != null) {
            for (Object[] obj : list) {
                Map<String,Object> map = new HashMap<>();
                map.put("amount",obj[0]);
                map.put("nickName",obj[1]);
                map.put("username",obj[2]);
                map.put("imageUrl",obj[3]);
                mapList.add(map);
            }
        }
		return mapList;
        
	}
}