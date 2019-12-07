/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import net.shopxx.entity.*;
import net.shopxx.entity.Order;
import org.springframework.stereotype.Repository;

import net.shopxx.dao.OrderItemDao;

import javax.persistence.criteria.*;
import java.util.List;

/**
 * Dao - 订单项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class OrderItemDaoImpl extends BaseDaoImpl<OrderItem, Long> implements OrderItemDao {

    @Override
    public List<OrderItem> limitProductBuyCount(Product product, Member member) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<OrderItem> criteriaQuery = criteriaBuilder.createQuery(OrderItem.class);
        Root<OrderItem> root = criteriaQuery.from(OrderItem.class);
        criteriaQuery.select(root);
        Predicate predicates = criteriaBuilder.conjunction();

        Subquery<Sku> skuSubquery = criteriaQuery.subquery(Sku.class);
        Root<Sku> skuSubqueryRoot = skuSubquery.from(Sku.class);
        skuSubquery.select(skuSubqueryRoot);
        skuSubquery.where(criteriaBuilder.equal(skuSubqueryRoot.get("product"), product));

        predicates = criteriaBuilder.and(predicates,criteriaBuilder.in(root.get("sku")).value(skuSubquery));

        Subquery<Order> orderSubquery = criteriaQuery.subquery(Order.class);
        Root<Order> orderRoot = orderSubquery.from(Order.class);
        orderSubquery.select(orderRoot);
        Path<Object> path = orderRoot.get("status");
        CriteriaBuilder.In<Object> in = criteriaBuilder.in(path);
        in.value(Order.Status.completed);
        in.value(Order.Status.pendingShipment);
        in.value(Order.Status.shipped);
        in.value(Order.Status.received);
        orderSubquery.where(criteriaBuilder.equal(orderRoot.get("member"),member),criteriaBuilder.and(in));

        predicates = criteriaBuilder.and(predicates,criteriaBuilder.in(root.get("order")).value(orderSubquery));
        criteriaQuery.where(predicates);
        return super.findList(criteriaQuery);
    }
}