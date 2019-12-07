package net.shopxx.entity.bo;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import java.math.BigDecimal;

/**
 * 充值响应
 */
public class QueryRechargeStatusResponse {

    private String status;
    private String orderId;
    private String mobile;
    private BigDecimal amount;
    private String payStatus;
    private String msg;

    public QueryRechargeStatusResponse(String responseBody) {
        JSONObject ret = (JSONObject) JSONValue.parse(responseBody);
        status = ret.get("status").toString();
        if(isSuccess()){
            orderId = ret.get("orderId").toString();
            mobile = ret.get("mobile").toString();
            amount = new BigDecimal(ret.get("amount").toString());
            payStatus = ret.get("payStatus").toString();
        }
            msg = ret.get("msg")!=null?ret.get("msg").toString():null;

    }

    public BigDecimal getAmount() {
        return amount;
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

    public boolean isPaySuccess(){
        return "paysuccess".equals(payStatus);
    }

    public String getPayStatus() {
        return payStatus;
    }
}
