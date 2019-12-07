package net.shopxx.entity.bo.suning;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.math.BigDecimal;
import java.util.List;

public class SnBalanceResponse extends SnBaseResponse{

    private SuNingAccount accountInfo=new SuNingAccount();

    public void load(String responseInfo){
        super.load(responseInfo);
        if(isSuccess()){
            //获取对应的金额
            JSONArray accountInfos = (JSONArray) result.get("accountInfo");
            for (int i = 0; i < accountInfos.size(); i++) {
                JSONObject obj = (JSONObject) accountInfos.get(i);
                if(obj.get("accountType").toString().equals("01")){
                    accountInfo.setAccountType(obj.get("accountType").toString());
                    accountInfo.setAvailableAmount(processSnAmount(obj.get("availableAmount").toString()));
                    accountInfo.setFrozenAmount(processSnAmount(obj.get("frozenAmount").toString()));
                    break;
                }
            }
        }else{
            //是否需要补偿重试
        }
    }

    public SuNingAccount getAccountInfo() {
        return accountInfo;
    }

    private int processSnAmount(String amount){
        BigDecimal snamount=new BigDecimal(amount);
        return snamount.divide(new BigDecimal(100)).intValue();
    }
}
