/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cash;
import net.shopxx.entity.CashMember;
import net.shopxx.entity.Member;

/**
 * Service - 提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface CashMemberService extends BaseService<CashMember, Long> {

	/**
	 * 申请提现
	 * 
	 * @param cash
	 *            提现
	 * @param member
	 *            商家
	 */
	void applyCash(CashMember cash, Member member);

	/**
	 * 查找提现记录分页
	 * 
	 * @param member
	 *            会员
	 * @param pageable
	 *            分页信息
	 * @return 提现记录分页
	 */
	Page<CashMember> findPage(Member member, Pageable pageable);

	/**
	 * 审核提现
	 * 
	 * @param cashMember
	 *            提现
	 * @param isPassed
	 *            是否审核通过
	 */
	void review(CashMember cashMember, Boolean isPassed);
}