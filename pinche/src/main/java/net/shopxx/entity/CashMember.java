/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

/**
 * Entity - 提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class CashMember extends BaseEntity<Long> {

	private static final long serialVersionUID = -1129619429301847081L;

	/**
	 * 状态
	 */
	public enum Status {

		/**
		 * 等待审核
		 */
		pending,

		/**
		 * 审核通过
		 */
		approved,

		/**
		 * 审核失败
		 */
		failed
	}

	/**
	 * 状态
	 */
	@NotNull(groups = Save.class)
	@Column(nullable = false)
	private CashMember.Status status;

	/**
	 * 金额
	 */
	@NotNull
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal amount;

	/**
	 * 收款银行
	 */
	@NotNull
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String bank;

	/**
	 * 收款账号
	 */
	@NotNull
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String account;

	/**
	 * 收款账户名称
	 */
	@NotNull
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String accountName;

	/**
	 * 商家
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private Member member;

	/**
	 * 获取状态
	 *
	 * @return 状态
	 */
	public CashMember.Status getStatus() {
		return status;
	}

	/**
	 * 设置状态
	 *
	 * @param status
	 *            状态
	 */
	public void setStatus(CashMember.Status status) {
		this.status = status;
	}

	/**
	 * 获取金额
	 * 
	 * @return 金额
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * 设置金额
	 * 
	 * @param amount
	 *            金额
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * 获取收款银行
	 * 
	 * @return 收款银行
	 */
	public String getBank() {
		return bank;
	}

	/**
	 * 设置收款银行
	 * 
	 * @param bank
	 *            收款银行
	 */
	public void setBank(String bank) {
		this.bank = bank;
	}

	/**
	 * 获取收款账号
	 * 
	 * @return 收款账号
	 */
	public String getAccount() {
		return account;
	}

	/**
	 * 设置收款账号
	 * 
	 * @param account
	 *            收款账号
	 */
	public void setAccount(String account) {
		this.account = account;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public String getAccountName() {
		return accountName;
	}

	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}
}