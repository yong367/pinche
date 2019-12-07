/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;


import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StoreClerkDao;

import net.shopxx.entity.*;

import net.shopxx.service.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;

/**
 * Service - 店铺店员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StoreClerkServiceImpl extends BaseServiceImpl<StoreClerk, Long> implements StoreClerkService {

	@Inject
	private StoreClerkDao storeClerkDao;
	@Transactional(readOnly = true)
	public Page<StoreClerk> findPage(Store store, Pageable pageable) {
		return storeClerkDao.findPage(store, pageable);
	}

	@Transactional(readOnly = true)
	public boolean openIdExists(String openId) {
		return storeClerkDao.openIdExists(openId);
	}

	@Override
	@Transactional(readOnly = true)
	public StoreClerk findByOpenId(String userOpenid) {
		return storeClerkDao.find("openId",userOpenid);
	}
}