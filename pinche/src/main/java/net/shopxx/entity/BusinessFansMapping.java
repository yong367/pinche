package net.shopxx.entity;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
public class BusinessFansMapping extends BaseEntity<Long>{

    private static final long serialVersionUID = -1309769426509847031L;

    /**
     * 商家id
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Business business;
    /**
     * 会员
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Member member;

    /**
     * 分组
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private FansGroup fansGroup;
    
 

    /**
     * 渠道累计收益总额
     * @return
     */
    @Column(nullable = false, precision = 27, scale = 12)
    private BigDecimal totalAmount;

    /**
     * 会员累计收入
     * @return
     */
    @Column(nullable = false, precision = 27, scale = 12)
    private BigDecimal memberAmount;

    /**
     * 购买金额
     * @return
     */
    @Column(nullable = false, precision = 27, scale = 12)
    private BigDecimal buyAmount;
    

    public Business getBusiness() { return business; }

    public void setBusiness(Business business) { this.business = business; }

    public Member getMember() { return member; }

    public void setMember(Member member) { this.member = member; }

    public FansGroup getFansGroup() { return fansGroup; }

    public void setFansGroup(FansGroup fansGroup) { this.fansGroup = fansGroup; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }

    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public BigDecimal getMemberAmount() { return memberAmount; }

    public void setMemberAmount(BigDecimal memberAmount) { this.memberAmount = memberAmount; }

    public BigDecimal getBuyAmount() { return buyAmount; }

    public void setBuyAmount(BigDecimal buyAmount) { this.buyAmount = buyAmount; }
}
