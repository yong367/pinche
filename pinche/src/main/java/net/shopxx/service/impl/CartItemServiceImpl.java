/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import net.shopxx.dao.CartItemDao;
import org.springframework.stereotype.Service;

import net.shopxx.entity.CartItem;
import net.shopxx.service.CartItemService;

import javax.inject.Inject;

/**
 * Service - 购物车项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class CartItemServiceImpl extends BaseServiceImpl<CartItem, Long> implements CartItemService {

    @Inject
    private CartItemDao cartItemDao;

    @Override
    public void updateCartItemSettlementFlag(Long id) {
        cartItemDao.updateCartItemSettlementFlag(id);
    }

    @Override
    public void updateCartItemFlag(CartItem cartItem) {
        cartItemDao.updateCartItemFlag(cartItem);
    }
}