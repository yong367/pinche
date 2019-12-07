package net.shopxx.entity.bo.suning;

import com.suning.epps.merchantsignature.common.Digest;
import com.suning.epps.merchantsignature.common.RSAUtil;

import java.io.UnsupportedEncodingException;
import java.security.PrivateKey;
import java.util.Map;

public class SnRechargeRequest extends SnBaseRequest{
    private String merchantOrderNo;
    private String orderTime;
    private String channel=SnConstant.channel;
    private String amount;
    private String mobile;
    private String autoRegiste="1";

    public SnRechargeRequest(){
            super.service="suning.fosps.apiremoteservice.agentrecharge.execute";
    }
    public Map<String,Object> loadParamterMap(PrivateKey privateKey){
        loadPatameterMap();
        Map<String,String> signMap=generateBaseSignMap();
        signMap.put("merchantOrderNo",merchantOrderNo);
        signMap.put("orderTime",orderTime);
        signMap.put("channel",channel);
        signMap.put("amount",amount);
        signMap.put("mobile",mobile);
        signMap.put("autoRegiste",autoRegiste);
        String digestData = Digest.mapToString(signMap);
        try {
            digestData = Digest.digest(digestData);
        } catch (UnsupportedEncodingException e) {
            digestData="";
        }
        try {
            this.sign = RSAUtil.sign(digestData,privateKey);
        } catch (Exception e) {
            this.sign="";
        }
        parameterMap.put("sign",this.sign);
        return parameterMap;
    }

    private void loadPatameterMap(){
        baseParameterMap();
        parameterMap.put("merchantOrderNo",merchantOrderNo);
        parameterMap.put("orderTime",orderTime);
        parameterMap.put("channel",channel);
        parameterMap.put("amount",amount);
        parameterMap.put("mobile",mobile);
        parameterMap.put("autoRegiste",autoRegiste);
    }

    public String getMerchantOrderNo() {
        return merchantOrderNo;
    }

    public void setMerchantOrderNo(String merchantOrderNo) {
        this.merchantOrderNo = merchantOrderNo;
    }

    public String getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(String orderTime) {
        this.orderTime = orderTime;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }
}
