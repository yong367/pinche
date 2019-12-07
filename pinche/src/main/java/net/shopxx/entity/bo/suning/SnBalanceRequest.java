package net.shopxx.entity.bo.suning;

import com.suning.epps.merchantsignature.SignatureUtil;
import com.suning.epps.merchantsignature.common.Digest;
import com.suning.epps.merchantsignature.common.RSAUtil;

import java.io.UnsupportedEncodingException;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class SnBalanceRequest extends SnBaseRequest{
    public SnBalanceRequest(){
        this.service="suning.fosps.apiremoteservice.getaccountbalance.execute";
    }
    public Map<String,Object> loadParamterMap(PrivateKey privateKey){
        baseParameterMap();
        String digestData = Digest.mapToString(generateBaseSignMap());
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


}
