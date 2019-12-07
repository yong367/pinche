package net.shopxx.entity.bo;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

/**
 * 充值响应
 */
public class RechargeResponse {

    private String status;
    private String orderId;
    private String mobile;
    private String amount;
    private String msg;

    public RechargeResponse(String responseBody) {
        JSONObject ret = (JSONObject) JSONValue.parse(responseBody);
        status = ret.get("status").toString();
        if(isSuccess()){
            orderId = ret.get("orderId").toString();
            mobile = ret.get("mobile").toString();
//            amount = ret.get("amount").toString();
        }else{
            msg = ret.get("msg").toString();
        }
    }

    public boolean isSuccess(){
        return "success".equals(status);
    }

    public String getOrderId() {
        return orderId;
    }

    public String getMsg() {
        return msg;
    }

    public String getStatus() {
        return status;
    }
}
