package net.shopxx.suning.model;

import com.suning.api.entity.govbus.ApplyRejectedAddRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 苏宁申请退货接口参数封装
 */
public class SuNingApplyRejected {
    private String orderId;
    private List<ApplyRejectedAddRequest.Skus> skus = new ArrayList<>();

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public List<ApplyRejectedAddRequest.Skus> getSkus() {
        return skus;
    }

    public void addSkuId(String skuId) {
        ApplyRejectedAddRequest.Skus sk = new ApplyRejectedAddRequest.Skus();
        sk.setSkuId(skuId);
        skus.add(sk);
    }
}
