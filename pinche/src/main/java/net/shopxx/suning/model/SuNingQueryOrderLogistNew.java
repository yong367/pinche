package net.shopxx.suning.model;

import com.suning.api.entity.govbus.OrderlogistnewGetRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 苏宁获取订单物流详情(新) 参数封装
 */
public class SuNingQueryOrderLogistNew {
    private String orderId;
    private List<OrderlogistnewGetRequest.OrderItemIds> orderItemIds =new ArrayList<>();

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public List<OrderlogistnewGetRequest.OrderItemIds> getOrderItemIds() {
        return orderItemIds;
    }

    public void addOrderItemId(String orderItemId,String skuId){
        OrderlogistnewGetRequest.OrderItemIds orderitem = new OrderlogistnewGetRequest.OrderItemIds();
        orderitem.setOrderItemId(orderItemId);
        orderitem.setSkuId(skuId);
        orderItemIds.add(orderitem);
    }
}

