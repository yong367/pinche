package net.shopxx.entity;

import com.fasterxml.jackson.annotation.JsonView;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.sql.Timestamp;
import java.util.Date;

/**
 * 话费充值日志
 */
@Entity
public class MobileRechargeLog extends BaseEntity<Long> {
    /**
     * 充值状态
     */
    public enum Status {

        /**
         * 等待处理
         */
        pendingProcess,

        /**
         * 已完成
         */
        completed,

        /**
         * 已失败
         */
        failed

    }

    @JsonView(BaseView.class)
    private String mobile;
    @JsonView(BaseView.class)
    private int amount;
    @JsonView(BaseView.class)
    private Status rechargeStatus;
    private Timestamp payTime;//到账时间
    private String requestMsg;
    private String requestCode;
    private String zcOrderNo;
    private String sn;
    private int rechargeDate;//充值月份
    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    /**
     * 会员
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, updatable = false)
    private Member member;

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public Status getRechargeStatus() {
        return rechargeStatus;
    }

    public void setRechargeStatus(Status rechargeStatus) {
        this.rechargeStatus = rechargeStatus;
    }

    public Timestamp getPayTime() {
        return payTime;
    }

    public void setPayTime(Timestamp payTime) {
        this.payTime = payTime;
    }

    public String getRequestMsg() {
        return requestMsg;
    }

    public void setRequestMsg(String requestMsg) {
        this.requestMsg = requestMsg;
    }

    public String getRequestCode() {
        return requestCode;
    }

    public void setRequestCode(String requestCode) {
        this.requestCode = requestCode;
    }

    public String getZcOrderNo() {
        return zcOrderNo;
    }

    public void setZcOrderNo(String zcOrderNo) {
        this.zcOrderNo = zcOrderNo;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public int getRechargeDate() {
        return rechargeDate;
    }

    public void setRechargeDate(int rechargeDate) {
        this.rechargeDate = rechargeDate;
    }
}
