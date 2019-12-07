package net.shopxx.suning.model;

import com.suning.api.entity.govbus.ShipTimeGetRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 物流时效接口 参数封装
 */
public class SuNingShipTime extends SuNingShipBase{

    private List<ShipTimeGetRequest.SkuIds> skuIds=new ArrayList<>();

    public List<ShipTimeGetRequest.SkuIds> getSkuIds() {
        return skuIds;
    }

    public void addSkuIdToArray(String skuId){
        ShipTimeGetRequest.SkuIds sk=new ShipTimeGetRequest.SkuIds();
        sk.setSkuId(skuId);
        skuIds.add(sk);
    }
}
