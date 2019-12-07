/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import net.shopxx.entity.Member;
import net.shopxx.entity.OrderItem;
import net.shopxx.entity.Product;

import java.util.List;

/**
 * Dao - 订单项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface OrderItemDao extends BaseDao<OrderItem, Long> {

    List<OrderItem> limitProductBuyCount(Product product, Member member);
}