package net.shopxx.entity.bo.suning;

import net.shopxx.util.DateCollect;

import java.util.Date;
import java.util.Map;
import java.util.TreeMap;

public class SnBaseRequest {
    protected String version="1.0";
    protected String app_id=SnConstant.app_id;
    protected String sign_type="RSA2";
    protected String signkey_index=SnConstant.signkey_index;
    protected String sign;
    protected String service;
    protected String timestamp=DateCollect.getDateStr(new Date(),DateCollect.SDF_yyyyMMddHHmmss);
    protected String merchantNo=SnConstant.merchantNo;
    protected Map<String,Object> parameterMap = new TreeMap<String,Object>();


    public void baseParameterMap(){
        parameterMap.put("version",version);
        parameterMap.put("app_id",app_id);
        parameterMap.put("sign_type",sign_type);
        parameterMap.put("signkey_index",signkey_index);
        parameterMap.put("service",service);
        parameterMap.put("timestamp",timestamp);
        parameterMap.put("merchantNo",merchantNo);
    }

    public Map<String,String> generateBaseSignMap(){
        Map<String,String> map=new TreeMap<>();
        map.put("version",version);
        map.put("app_id",app_id);
        map.put("service",service);
        map.put("timestamp",timestamp);
        map.put("merchantNo",merchantNo);
        return map;
    }
}
