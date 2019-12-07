package net.shopxx.entity;

import com.fasterxml.jackson.annotation.JsonView;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
public class MemberContributionLog extends BaseEntity<Long>{
    private static final long serialVersionUID = 168692131912351111L;


    /**
     * 类型
     */
    public enum Type {

        /**
         * 注册贡献
         */
        register,

        /**
         * 订单贡献
         */
        order,
        /**
         * 任务贡献
         */
        task
    }

    /**
     * 贡献方
     */
    @JsonView(BaseView.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(updatable = false)
    private Member senderMemeber;

    /**
     * 贡献接受方
     */
    @JsonView(BaseView.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(updatable = false)
    private Member receiverMember;

    /**
     * 类型
     */
    @JsonView(BaseView.class)
    @Column(nullable = false, updatable = false)
    private MemberContributionLog.Type type;

    /**
     * 贡献金额
     */
    @JsonView(BaseView.class)
    @Column(nullable = false, updatable = false, precision = 21, scale = 6)
    private BigDecimal amount;

    public Member getSenderMemeber() {
        return senderMemeber;
    }

    public void setSenderMemeber(Member senderMemeber) {
        this.senderMemeber = senderMemeber;
    }

    public Member getReceiverMember() {
        return receiverMember;
    }

    public void setReceiverMember(Member receiverMember) {
        this.receiverMember = receiverMember;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
}
