package net.shopxx.entity.bo.zhogncheng;

import net.shopxx.util.MD5Util;
import net.shopxx.util.SystemUtil;
import net.shopxx.util.SystemUtils;

import java.util.HashMap;
import java.util.Map;

public class MobileRechargeRequest {

    private String userid=ZhongHuaConfig.userid;//商户编号
    private String sporderid;//合作商订单号 请确保订单号的唯一性
    private String mobile;//充值手机号
    private String price;//充值金额
    private String chargetype="0";//充值类型
    private String back_url;//代理商回调地址 无传 “www”
    private String spordertime;//代理商订单时间 不参与加密 格式：yyyy-MM-dd HH:mm:ss
    private String sign;//MD5(userid + sporderid + mobile + price + chargetype + back_url +key)

    public MobileRechargeRequest() {
    }


    public void setSporderid(String sporderid) {
        this.sporderid = sporderid;
    }


    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public void setPrice(String price) {
        this.price = price;
    }


    public void setBack_url(String back_url) {
        this.back_url = back_url;
    }

    public void setSpordertime(String spordertime) {
        this.spordertime = spordertime;
    }
    public Map<String,Object> getRequestMap(){
        Map<String,Object> result=new HashMap<>();
        result.put("userid",userid);
        result.put("sporderid",sporderid);
        result.put("mobile",mobile);
        result.put("price",price);
        result.put("chargetype",chargetype);
        result.put("back_url",back_url);
        result.put("spordertime",spordertime);
        result.put("sign", MD5Util.md5Encode(userid+sporderid+mobile+price+chargetype+back_url+ZhongHuaConfig.key));
        return result;
    }

    @Override
    public String toString() {
        return "MobileRechargeRequest{" +
                "userid='" + userid + '\'' +
                ", sporderid='" + sporderid + '\'' +
                ", mobile='" + mobile + '\'' +
                ", price='" + price + '\'' +
                ", chargetype='" + chargetype + '\'' +
                ", back_url='" + back_url + '\'' +
                ", spordertime='" + spordertime + '\'' +
                ", sign='" + sign + '\'' +
                '}';
    }
}
