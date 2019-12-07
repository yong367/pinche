/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cash;
import net.shopxx.entity.CashMember;
import net.shopxx.entity.Member;

/**
 * Dao - 提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface CashMemberDao extends BaseDao<CashMember, Long> {

	/**
	 * 查找提现记录分页
	 * 
	 * @param member
	 *            huiyuan
	 * @param pageable
	 *            分页信息
	 * @return 提现记录分页
	 */
	Page<CashMember> findPage(Member member, Pageable pageable);

}