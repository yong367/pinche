/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import net.shopxx.dao.OrderItemDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.entity.Product;
import org.springframework.stereotype.Service;

import net.shopxx.entity.OrderItem;
import net.shopxx.service.OrderItemService;

import javax.inject.Inject;
import java.util.List;

/**
 * Service - 订单项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class OrderItemServiceImpl extends BaseServiceImpl<OrderItem, Long> implements OrderItemService {

    @Inject
    private OrderItemDao orderItemDao;

    @Override
    public int limitProductBuyCount(Product product, Member member) {
        List<OrderItem> list = orderItemDao.limitProductBuyCount(product,member);
        int buyCount=0;
        if(list!=null && list.size()>0){
            for (OrderItem orderItem:list) {
                int count = orderItem.getQuantity();
                buyCount = buyCount + count;
            }
        }
       return buyCount;

    }
}