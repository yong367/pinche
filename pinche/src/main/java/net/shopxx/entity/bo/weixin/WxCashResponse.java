package net.shopxx.entity.bo.weixin;

/**
 * 微信提现响应
 */

public class WxCashResponse extends WxBaseResponse{
    
    private String mchAppid;//商户appid
    private String partnerTradeNo;//商户单号
    private String mchId;//商户号
    private String paymentNo;//微信付款单号
    private String paymentTime;//付款成功时间
    private String nonceStr;//随机字符串
    private String errCode;//错误代码
    private String errCodeDes;//错误代码描述
    /**
     * 失败后是否重试
     */
  private boolean isRetry = false;
    
    public void load(String responseContent) throws Exception{
        super.load(responseContent);
        if(isSuccess()) {
            this.mchAppid = result.get("mch_appid");
            this.mchId = result.get("mchid");
            this.nonceStr = result.get("nonce_str");
            this.resultCode = result.get("result_code");
            
            if(isPaySuccess()) {
                //提现成功
                this.partnerTradeNo = result.get("partner_trade_no");
                this.paymentNo = result.get("payment_no");
                this.paymentTime = result.get("payment_time");
            } else {
                //提现失败
                this.errCode = result.get("err_code");
                this.errCodeDes = result.get("err_code_des");
               if("SYSTEMERROR".equals(errCode)) {
                   isRetry = true;
               }
            }
        } 
        
    }

    public String getErrCode() {
        return errCode;
    }

    public String getErrCodeDes() {
        return errCodeDes;
    }

    public String getPartnerTradeNo() {
        return partnerTradeNo;
    }
}
