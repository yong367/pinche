package net.shopxx.suning.model;

import com.suning.api.entity.govbus.ShipCarriageGetRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 物流运费接口查询参数封装
 */
public class SuNingShipCarriage extends SuNingShipBase {
    private List<ShipCarriageGetRequest.SkuIds> skuIds=new ArrayList<>();

    public List<ShipCarriageGetRequest.SkuIds> getSkuIds() {
        return skuIds;
    }

    public void addSkuidToArray(String skuid,String buyCount){
        ShipCarriageGetRequest.SkuIds sk=new ShipCarriageGetRequest.SkuIds();
        sk.setPiece(buyCount);
        sk.setSkuId(skuid);
        skuIds.add(sk);
    }
}
