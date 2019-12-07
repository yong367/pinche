package net.shopxx.entity.bo.suning;

import com.fasterxml.jackson.annotation.JsonValue;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class SnBaseResponse {
    protected String sign;
    protected String responseCode;
    protected String message;
    protected String error_code;
    protected String error_msg;
    protected JSONObject result;

    public void load(String returnInfo) {
        result= (JSONObject) JSONValue.parse(returnInfo);
        this.sign = result.get("sign").toString();
        this.responseCode =result.get("responseCode")!=null?result.get("responseCode").toString():"error";
        if(!isSuccess()){
            this.error_code = result.get("error_code").toString();
            this.error_msg = result.get("error_msg")!=null?result.get("error_msg").toString():"";
        }
    }
    public boolean isSuccess(){
        return responseCode.equals("00");
    }

    public String getError_code() {
        return error_code;
    }

    public String getError_msg() {
        return error_msg;
    }
}
