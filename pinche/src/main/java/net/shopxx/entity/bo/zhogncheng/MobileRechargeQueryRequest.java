package net.shopxx.entity.bo.zhogncheng;

import net.shopxx.util.MD5Util;

import java.util.HashMap;
import java.util.Map;

public class MobileRechargeQueryRequest {

    private String userid=ZhongHuaConfig.userid;//商户编号
    private String sporderid;//合作商订单号 请确保订单号的唯一性
    private String chargetype="0";//充值类型
    private String sign;//MD5(userid + sporderid + mobile + price + chargetype + back_url +key)


    public void setSporderid(String sporderid) {
        this.sporderid = sporderid;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public Map<String,Object> getRequestMap(){
        Map<String,Object> result=new HashMap<>();
        result.put("userid",userid);
        result.put("sporderid",sporderid);
        result.put("chargetype",chargetype);
        result.put("sign", MD5Util.md5Encode(userid+sporderid+chargetype+ZhongHuaConfig.key));
        return result;
    }
}
