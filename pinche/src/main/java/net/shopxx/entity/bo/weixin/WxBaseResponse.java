package net.shopxx.entity.bo.weixin;

import net.shopxx.util.WxPayUtil;

import java.util.Map;

/**
 * 公共类
 */
public class WxBaseResponse {
    protected String returnCode;//返回状态码
    protected String returnMsg;//返回信息
    protected String resultCode;//业务结果
    protected Map<String,String> result;

    /**
     * 通信标识
     * @return
     */
    public boolean isSuccess() {
        return "SUCCESS".equals(returnCode);
    }

    /**
     * 交易标识
     * @return
     */
    public boolean isPaySuccess() {
        return "SUCCESS".equals(resultCode);
    }

    public void load(String responseContent) throws Exception{
        
        result = WxPayUtil.xmlToMap(responseContent);
        this.returnCode = result.get("return_code");
        this.returnMsg = result.get("return_msg");
    }

    public String getReturnMsg() {
        return returnMsg;
    }

    public String getReturnCode() {
        return returnCode;
    }
}
