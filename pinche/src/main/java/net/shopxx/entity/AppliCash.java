package net.shopxx.entity;

import com.fasterxml.jackson.annotation.JsonView;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

/**
 * 微信提现实体类
 */
@Entity
public class AppliCash extends BaseEntity<Long>{
    private static final long serialVersionUID = -1129619429301847031L;

    
    public enum Status {

        /**
         * 转账成功
         */
        SUCCESS,

        /**
         * 处理中
         */
        PROCESSING,

        /**
         * 转账失败
         */
        FAILED,
        /**
         * 提现异常
         */
        CashException
    }
    public enum cashMethod {
        
        /**
         * 微信提现
         */
        
        wxCash,
        
        /**
         *支付宝提现 
         */
        
        alipayCash,

        /**
         * 银行卡提现
         */
        bank
    }
    /**
     * 金额
     */
    @JsonView(BaseView.class)
    @NotNull
    @Column(nullable = false, updatable = false, precision = 21, scale = 2)
    private BigDecimal amount;

    /**
     * 实际转账金额
     */
    @JsonView(BaseView.class)
    @Column(nullable = false, updatable = false, precision = 21, scale = 2)
    private BigDecimal transferAmount;
    /**
     * 会员
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Member member;
    /**
     * 状态
     */
    @JsonView(BaseView.class)
    @NotNull(groups = Save.class)
    @Column(nullable = false)
    private AppliCash.Status status;
    /**
     * 用户openid
     */
    private String openid;
    /**
     * 转入账户
     */
    @JsonView(BaseView.class)
    private String account;
    /**
     * 商户订单号
     */
    private String orderId;
    /**
     * 返回状态码
     */
    
    private String returnCode;
    /**
     * 返回信息
     */
    
    private String returnMsg;
    /**
     * 失败后返回信息
     */
    private String subMsg;
    /**
     * 失败后返回的错误码
     */
    private String subCode;
    /**
     * 标识
     */
    @JsonView(BaseView.class)
    private AppliCash.cashMethod cashMethod;

    public BigDecimal getTransferAmount() {
        return transferAmount;
    }

    public void setTransferAmount(BigDecimal transferAmount) {
        this.transferAmount = transferAmount;
    }

    /**
     * 获取状态
     * @return
     */
    public AppliCash.Status getStatus() {
        return status;
    }

    /**
     * 设置状态
     * @param status
     */
    public void setStatus(AppliCash.Status status) {
        this.status = status;
    }

    /**
     * 获取金额
     * @return
     */
    public BigDecimal getAmount() {
        return amount;
    }

    /**
     * 设置金额
     * @param amount
     */
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public String getOpenid() {
        return openid;
    }

    public void setOpenid(String openid) {
        this.openid = openid;
    }

    public String getOrderId() { return orderId; }

    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getReturnCode() { return returnCode; }

    public void setReturnCode(String returnCode) { this.returnCode = returnCode; }

    public String getReturnMsg() { return returnMsg; }

    public void setReturnMsg(String returnMsg) { this.returnMsg = returnMsg; }

    public AppliCash.cashMethod getCashMethod() { return cashMethod; }

    public void setCashMethod(AppliCash.cashMethod cashMethod) { this.cashMethod = cashMethod; }

    public String getAccount() { return account; }

    public void setAccount(String account) { this.account = account; }

    public String getSubMsg() { return subMsg; }

    public void setSubMsg(String subMsg) { this.subMsg = subMsg; }

    public String getSubCode() { return subCode; }

    public void setSubCode(String subCode) { this.subCode = subCode; }
}
