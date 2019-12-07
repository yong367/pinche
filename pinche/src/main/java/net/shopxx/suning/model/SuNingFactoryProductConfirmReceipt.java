package net.shopxx.suning.model;

import com.suning.api.entity.govbus.FacProductConfirmRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 苏宁厂送商品确认接口请求参数封装类
 */
public class SuNingFactoryProductConfirmReceipt {
    //确认收货商品skuId 集合
    private List<FacProductConfirmRequest.SkuConfirmList> skuConfirmList = new ArrayList<>();
    private String orderId;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public List<FacProductConfirmRequest.SkuConfirmList> getSkuConfirmList() {
        return skuConfirmList;
    }

    /**
     *
     * @param confirmTime 2016-09-03 16:23:21
     * @param skuId
     */
    public void addFacProductConfirmReceiptSku(String confirmTime,String skuId){
        FacProductConfirmRequest.SkuConfirmList sku = new FacProductConfirmRequest.SkuConfirmList();
        sku.setSkuId(skuId);
        sku.setConfirmTime(confirmTime);
        skuConfirmList.add(sku);
    }
}
