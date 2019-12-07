package net.shopxx.entity.bo.zhogncheng;

import net.shopxx.util.XmlUtils;

import java.util.Map;

public class MobileRechargeResponse {
    /**
     * <result>0000</result>//通信状态
     *   <sporderid>2009042800001</sporderid>//合作商订单号
     *   <orderid>090428000003</orderid>//系统订单号
     *   <status>1000</status>//订单状态
     *   <desc>创建订单成功</desc>//状态描述
     *   <account>2009042800001</account>//扣款金额,单位：元
     *   <fundbalance>100000</fundbalance>//账户余额
     */
    private String result;
    private String sporderid;
    private String orderid;
    private String status;
    private String rechargeDesc;
    private String account;
    private String fundbalance;
    private boolean queryFlag=false;

    public String getSporderid() {
        return sporderid;
    }

    public String getOrderid() {
        return orderid;
    }

    public String getStatus() {
        return status;
    }

    public void load(String result) {
        Map<String,String> map=XmlUtils.toObject(result,Map.class);
        this.result=map.get("result");
            this.sporderid=map.get("sporderid");
            this.orderid=map.get("orderid");
            this.account=map.get("account");
            this.fundbalance=map.get("fundbalance");
        this.status=map.get("status");
        this.rechargeDesc=map.get("desc");
        this.queryFlag = "0016".equals(result);
    }

    public boolean isQueryFlag() {
        return queryFlag;
    }

    public boolean isOrderSuccess(){
        return "1000".equals(status);
    }

    public boolean isRequestSuccess(){
        return "0000".equals(result);
    }

    public String getResult() {
        return result;
    }

    public String getRechargeDesc() {
        return rechargeDesc;
    }
}
