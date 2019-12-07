/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import com.fasterxml.jackson.annotation.JsonView;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.search.annotations.*;
import org.hibernate.search.annotations.Index;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Entity - 店铺店员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Indexed
@Entity
public class StoreClerk extends BaseEntity<Long> {


	private static final long serialVersionUID = -1432043984669298178L;
	/**
	 * 店员微信ID
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String openId;

	/**
	 * 电话
	 */
	@Length(max = 200)
	private String phone;


	/**
	 * 姓名
	 */
	@Length(max = 200)
	private String name;


	/**
	 * 店铺
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Store store;
	
	

	public String getOpenId() {
		return openId;
	}

	public void setOpenId(String openId) {
		this.openId = openId;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Store getStore() {
		return store;
	}

	public void setStore(Store store) {
		this.store = store;
	}

    
}