package net.shopxx.entity.bo.weixin;

import net.shopxx.util.WxPayUtil;
import net.shopxx.weixin.config.WxPayServerConfig;
import org.springframework.stereotype.Repository;

/**
 * 微信查询付款请求
 */
@Repository
public class WxSearchRequest extends WxBaseRequest{
    

    public WxSearchRequest(WxPayServerConfig wxPayServerConfig) {
        super(wxPayServerConfig);
    }

    public String fillRequestData()throws Exception{
        loadBaseRequestParam();
        map.put("appid",mchAppid);
        map.put("mch_id",mchId);
        map.put("sign",generateSignString());

        String result = WxPayUtil.mapToXml(map);
        System.out.println("请求的参数:" + result);

        return result;
    }
}
