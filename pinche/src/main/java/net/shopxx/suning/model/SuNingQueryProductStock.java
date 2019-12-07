package net.shopxx.suning.model;

import com.suning.api.entity.govbus.MpStockQueryRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 多商品的库存批量查询接口 参数请求封装实体类
 */
public class SuNingQueryProductStock {

    private String cityId;

    private List<MpStockQueryRequest.SkuIds> skuIds = new ArrayList<>();

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public void addSkuIdsToArray(String skuid){
        MpStockQueryRequest.SkuIds sk=new MpStockQueryRequest.SkuIds();
        sk.setSkuId(skuid);
        skuIds.add(sk);
    }

    public List<MpStockQueryRequest.SkuIds> getSkuIds() {
        return skuIds;
    }
}
