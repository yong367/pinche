package net.shopxx.entity.bo.suning;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class SnRechargeResponse extends SnBaseResponse{
    private String orderNo;

    public String getOrderNo() {
        return orderNo;
    }

    public void load(String responseInfo){
        super.load(responseInfo);
        if(isSuccess()){
            //获取对应的金额
            orderNo = result.get("orderNo").toString();
        }
    }
}
