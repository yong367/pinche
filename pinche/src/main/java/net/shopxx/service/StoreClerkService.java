/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;


import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreClerk;


/**
 * Service - 店铺店员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface StoreClerkService extends BaseService<StoreClerk, Long> {
    /**
     * 判断openId是否存在
     *
     * @param openId 微信唯一标识
     *
     * @return 是否存在
     */
    boolean openIdExists(String openId);

    /**
     * 查找店铺店员分页
     *
     * @param store
     *            店铺
     * @param pageable
     *            分页
     * @return 店铺店员分页
     */
    Page<StoreClerk> findPage(Store store, Pageable pageable);

    StoreClerk findByOpenId(String userOpenid);
}