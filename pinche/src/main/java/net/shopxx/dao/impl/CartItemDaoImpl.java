/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import net.shopxx.dao.CartItemDao;
import net.shopxx.entity.CartItem;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.sql.DataSource;

/**
 * Dao - 购物车项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class CartItemDaoImpl extends BaseDaoImpl<CartItem, Long> implements CartItemDao {

    @Inject
    private DataSource dataSource;
    protected JdbcTemplate jdbcTemplate;
    @PostConstruct
    private void afterConstruct() {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }
    @Override
    public void updateCartItemSettlementFlag(Long id) {
        String sql="update CartItem set settlementFlag=0 WHERE cart_id= ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public void updateCartItemFlag(CartItem cartItem) {
        String sql="update CartItem set settlementFlag=1 WHERE id= "+cartItem.getId();
        jdbcTemplate.update(sql);
    }
}