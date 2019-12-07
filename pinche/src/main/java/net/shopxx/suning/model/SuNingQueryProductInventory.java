package net.shopxx.suning.model;

import com.suning.api.entity.govbus.InventoryGetRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 苏宁单个商品的精准库存查询接口的请求封装数据对象
 *
 */
public class SuNingQueryProductInventory {
    /**
     * 市
     */
    private String cityId;

    /**
     * 区县
     */
    private String countyId;



    private List<InventoryGetRequest.SkuIds> skuIds = new ArrayList<>();

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public String getCountyId() {
        return countyId;
    }

    public void setCountyId(String countyId) {
        this.countyId = countyId;
    }

    public void addQueryProductInfoToArray(String skuId,String buyNum){
        InventoryGetRequest.SkuIds sku=new InventoryGetRequest.SkuIds();
        sku.setNum(buyNum);
        sku.setSkuId(skuId);
        skuIds.add(sku);
    }

    public List<InventoryGetRequest.SkuIds> getSkuIds() {
        return skuIds;
    }
}
