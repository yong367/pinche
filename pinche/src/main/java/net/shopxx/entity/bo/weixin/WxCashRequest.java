package net.shopxx.entity.bo.weixin;

import net.shopxx.util.WxPayUtil;
import net.shopxx.weixin.config.WxPayServerConfig;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;

/**
 * 微信提现实体类请求
 */
@Repository
public class WxCashRequest extends WxBaseRequest{
  
    private String openId;//商户下用户的appid
  
    
    BigDecimal money;
    
    
    public WxCashRequest(WxPayServerConfig wxPayServerConfig) {
        super(wxPayServerConfig);
    }

    
    public String fillRequestData()throws Exception {
        loadBaseRequestParam();
        map.put("mch_appid",mchAppid);
        map.put("mchid",mchId);
        map.put("openid",openId);
        map.put("check_name","NO_CHECK");
        double b = money.doubleValue() * 100;
        map.put("amount", "" + new Double(b).intValue());
        map.put("desc","微信提现到零钱");//企业付款操作说明
        map.put("spbill_create_ip","47.93.47.54");
        /**Unicode码从小到大排序**/
        map.put("sign",generateSignString());

        String result = WxPayUtil.mapToXml(map);
        System.out.println("请求的参数:" + result);
        
        return result;
    }

    public void setMoney(BigDecimal money) {
        this.money = money;
    }

    public void setOpenId(String openId) {
        this.openId = openId;
    }
}
