package net.shopxx.entity.bo.weixin;

import net.shopxx.util.WxPayUtil;
import net.shopxx.weixin.config.WxPayServerConfig;

import java.util.HashMap;
import java.util.Map;

public class WxBaseRequest {
    protected String mchAppid;//公众号
    protected String mchId;//商户号
    protected String merchantKey;
    protected String partnerTradeNo;//商户订单号
    protected Map<String,String> map = new HashMap<String,String>();

    public WxBaseRequest(WxPayServerConfig wxPayServerConfig) {
        mchAppid =wxPayServerConfig.getAppid();
        mchId = wxPayServerConfig.getMerchantId();
        merchantKey = wxPayServerConfig.getMerchantKey();
    }
    
    public void  loadBaseRequestParam() throws Exception{
        map.put("nonce_str", WxPayUtil.generateNonceStr());
        map.put("partner_trade_no",partnerTradeNo);
        
    }
    
    
    /**
     * 生成签名字符串
     * @return
     * @throws Exception
     */
    public String generateSignString() throws Exception {
        String url = WxPayUtil.formatUrlMap(map, false, false);
        url = url + "&key=" + merchantKey;
        String sign = WxPayUtil.MD5Encoding(url).toUpperCase();
        return sign;
    }

    public void setPartnerTradeNo(String partnerTradeNo) {
        this.partnerTradeNo = partnerTradeNo;
    }

    public String getPartnerTradeNo() {
        return partnerTradeNo;
    }
}
