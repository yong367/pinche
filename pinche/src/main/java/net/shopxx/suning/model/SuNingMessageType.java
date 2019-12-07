package net.shopxx.suning.model;

public enum SuNingMessageType {
    PRODUCT_POOL_MESSAGE("10","商品池 上架、下架、添加、删除、修改"),
    ORDER_MESSAGE("11","订单 实时创建、预占成功、确认预占、取消预占、异常订单取消"),
    SHIP_MESSAGE("12","物流 商品出库、商品妥投、商品拒收、商品退货"),
    CATEGORY_MESSAGE("13","目录 添加、修改、删除");

    private String num;
    private String des;

    private SuNingMessageType(String num,String des){
        this.num=num;
        this.des=des;
    }

    public String getNum() {
        return num;
    }

}
