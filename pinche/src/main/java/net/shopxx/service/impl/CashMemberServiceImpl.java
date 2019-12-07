/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.CashDao;
import net.shopxx.dao.CashMemberDao;
import net.shopxx.entity.*;
import net.shopxx.service.BusinessService;
import net.shopxx.service.CashMemberService;
import net.shopxx.service.CashService;
import net.shopxx.service.MemberService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import javax.inject.Inject;
import java.math.BigDecimal;

/**
 * Service - 提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class CashMemberServiceImpl extends BaseServiceImpl<CashMember, Long> implements CashMemberService {

	@Inject
	private CashMemberDao cashMemberDao;
	@Inject
	private MemberService memberService;

	@Transactional(readOnly = true)
	public Page<CashMember> findPage(Member member, Pageable pageable) {
		return cashMemberDao.findPage(member, pageable);
	}

	public void applyCash(CashMember cashMember, Member member) {
		Assert.notNull(cashMember);
		Assert.notNull(member);
		Assert.isTrue(cashMember.getAmount().compareTo(BigDecimal.ZERO) > 0);

		cashMember.setStatus(CashMember.Status.pending);
		cashMember.setMember(member);
		cashMemberDao.persist(cashMember);
		memberService.addBalance(cashMember.getMember(), cashMember.getAmount().negate(), MemberDepositLog.Type.cash, null);
	}

	public void review(CashMember cashMember, Boolean isPassed) {
		Assert.notNull(cashMember);
		Assert.notNull(isPassed);

		if (isPassed) {
			Assert.notNull(cashMember.getAmount());
			Assert.notNull(cashMember.getMember());
			cashMember.setStatus(CashMember.Status.approved);
		} else {
			cashMember.setStatus(CashMember.Status.failed);
			memberService.addBalance(cashMember.getMember(), cashMember.getAmount(), MemberDepositLog.Type.jdBtlxReward, null);
		}
	}

}