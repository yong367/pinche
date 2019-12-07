package net.shopxx.entity.bo.weixin;

import java.math.BigDecimal;


public class WxSearchResponse extends WxBaseResponse{
    private String mchAppid;//商户appid
    private String partnerTradeNo;//商户单号
    private String mchId;//商户号
    private String errCode;//错误代码
    private String errCodeDes;//错误代码描述
    private String detailId;//付款单号
    private String status;//转账状态
    private String reason;//失败原因
    private String openid;//收款用户openid
    private BigDecimal paymentAmount;//付款金额
    private String transferTime;//转账时间
    private String paymentTime;//付款成功时间
    private String desc;//企业付款备注
    

    public void load(String responseContent) throws Exception{
        super.load(responseContent);
        if(isSuccess()) {
            this.resultCode = result.get("result_code");
            if(isPaySuccess()) {
                //都成功
                this.partnerTradeNo = result.get("partner_trade_no");
                this.mchAppid = result.get("mchAppid");
                this.mchId = result.get("mch_id");
                this.detailId = result.get("detail_id");
                this.status = result.get("status");
                this.reason = result.get("reason");
                this.openid = result.get("openid");
                this.paymentAmount = new BigDecimal(result.get("payment_amount"));
                this.transferTime = result.get("transfer_time");
                this.paymentTime = result.get("payment_time");
                this.desc = result.get("desc");
            } else {
                this.errCode = result.get("err_code");
                this.errCodeDes = result.get("err_code_des");
            }
        } 
    }

    public String getStatus() {
        return status;
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }
}
