package net.shopxx.entity;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.math.BigDecimal;

/**
 * 行程订单表
 */
@Entity
public class JourneyOrder extends BaseEntity<Long> {

    public enum PaymentType{
        balance,weixin
    }

    public enum OrderStatus{
        /**
         * 等待付款
         */
        pendingPayment,
        /**
         * 支付成功
         */
        success,
        /**
         * 已完成
         */
        completed,

        /**
         * 已失败
         */
        failed,

        /**
         * 已取消
         */
        canceled,
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private PublishJourney publishJourney;//订单行程对象

    private OrderStatus orderStatus;//订单状态

    private int orderNum;//订购数量
    private BigDecimal orderPrice; //订单金额
    private String sn;//订单编号
    private PaymentType paymentType;//支付方式

    public PublishJourney getPublishJourney() {
        return publishJourney;
    }

    public void setPublishJourney(PublishJourney publishJourney) {
        this.publishJourney = publishJourney;
    }

    public OrderStatus getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }

    public int getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(int orderNum) {
        this.orderNum = orderNum;
    }

    public BigDecimal getOrderPrice() {
        return orderPrice;
    }

    public void setOrderPrice(BigDecimal orderPrice) {
        this.orderPrice = orderPrice;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public PaymentType getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(PaymentType paymentType) {
        this.paymentType = paymentType;
    }
}
