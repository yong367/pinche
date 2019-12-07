package net.shopxx.entity;

import javax.persistence.*;

@Entity
public class FansGroup extends BaseEntity<Long>{

    private static final long serialVersionUID = -1309520426209831531L;
    /**
     * 组名称
     */
    @Column(nullable = false)
    private String name;
    /**
     * 排序
     */
    private int orderNo;

    /**
     * 商家id
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Business business;

    /**
     * 是否默认标识
     */
    private boolean isDefautFlag;

    public String getName() { return name; }

    public void setName(String name) { this.name = name; }

    public int getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(int orderNo) {
        this.orderNo = orderNo;
    }

    public Business getBusiness() { return business; }

    public void setBusiness(Business business) { this.business = business; }

    public boolean getDefautFlag() { return isDefautFlag; }

    public void setDefautFlag(boolean defautFlag) { isDefautFlag = defautFlag; }
}
