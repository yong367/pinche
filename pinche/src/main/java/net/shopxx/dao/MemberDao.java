/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAttribute;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Dao - 会员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface MemberDao extends BaseDao<Member, Long> {

	/**
	 * 查找会员分页
	 * 
	 * @param rankingType
	 *            排名类型
	 * @param pageable
	 *            分页信息
	 * @return 会员分页
	 */
	Page<Member> findPage(Member.RankingType rankingType, Pageable pageable);

	/**
	 * 查询会员注册数
	 * 
	 * @param beginDate
	 *            起始日期
	 * @param endDate
	 *            结束日期
	 * @return 会员注册数
	 */
	Long registerMemberCount(Date beginDate, Date endDate);

	/**
	 * 清除会员注册项值
	 * 
	 * @param memberAttribute
	 *            会员注册项
	 */
	void clearAttributeValue(MemberAttribute memberAttribute);

	/**
	 * 统计粉丝数量
	 * @param member
	 * @return
	 */
	Long checkFenSiCount(Member member);
	/**
	 * 查询获得粉丝记录
	 * @param member
	 * @param pageable
	 * @return
	 */
	List<Map<String, Object>> findFansPage(Member member, Pageable pageable);
}