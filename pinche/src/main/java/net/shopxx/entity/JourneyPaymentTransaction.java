package net.shopxx.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 行程支付事务表
 */
@Entity
public class JourneyPaymentTransaction extends BaseEntity<Long> {
    /**
     * 编号
     */
    @Column(nullable = false, updatable = false, unique = true)
    private String sn;

    /**
     * 支付金额
     */
    @Column(nullable = false, updatable = false, precision = 21, scale = 6)
    private BigDecimal amount;

    /**
     * 是否成功
     */
    private Boolean paySuccess;

    /**
     * 过期时间
     */
    @Column(updatable = false)
    private Long expireTime;

    /**
     * 行程订单订单
     */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn( updatable = false)
    private JourneyOrder journeyOrder;

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Boolean getPaySuccess() {
        return paySuccess;
    }

    public void setPaySuccess(Boolean paySuccess) {
        this.paySuccess = paySuccess;
    }

    public Long getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(Long expireTime) {
        this.expireTime = expireTime;
    }

    public JourneyOrder getJourneyOrder() {
        return journeyOrder;
    }

    public void setJourneyOrder(JourneyOrder journeyOrder) {
        this.journeyOrder = journeyOrder;
    }
}
