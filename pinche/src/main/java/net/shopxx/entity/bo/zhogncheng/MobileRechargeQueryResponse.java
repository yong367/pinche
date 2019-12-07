package net.shopxx.entity.bo.zhogncheng;

import net.shopxx.util.XmlUtils;

import java.util.Map;

public class MobileRechargeQueryResponse {
    /**
     * <order>
     *   <result>0000</result>//通信状态
     *   <sporderid>2009042800001</sporderid>//合作商订单号
     *   <orderid>090428000003</orderid>//系统订单号
     *   <status>success</status>//订单状态
     *   <desc>充值成功</desc>//状态描述
     * <voucherId>090428000003</voucherId>//充值凭证
     * </order>
     */
    private String result;
    private String sporderid;
    private String orderid;
    private String status;
    private String rechargeDesc;
    private String voucherId;

    public String getSporderid() {
        return sporderid;
    }

    public String getOrderid() {
        return orderid;
    }

    public String getRechargeDesc() {
        return rechargeDesc;
    }

    public void load(String result) {
        Map<String,String> map= XmlUtils.toObject(result,Map.class);
        this.result=map.get("result");
            this.sporderid=map.get("sporderid");
            this.orderid=map.get("orderid");
            this.status=map.get("status");
            this.rechargeDesc=map.get("desc");
    }

    public String getStatus() {
        return status;
    }

    public String getResult() {
        return result;
    }

    public boolean isRequestSuccess(){
        return "0000".equals(result);
    }
}
