package net.shopxx.suning.model;

/**
 * 苏宁获取订单物流详情 参数封装
 */
public class SuNingQueryOrderLogist {
    private String orderId;
    private String orderItemId;
    private String skuId;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(String orderItemId) {
        this.orderItemId = orderItemId;
    }

    public String getSkuId() {
        return skuId;
    }

    public void setSkuId(String skuId) {
        this.skuId = skuId;
    }
}
