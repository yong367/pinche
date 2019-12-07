package net.shopxx.entity;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 * 车主车辆信息关系表
 */
@Entity
public class CarMemberMapping extends BaseEntity<Long>{
    /**
     * 车主信息
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Member member;

    private String carNumber;//汽车号牌
    private String carBrand;//汽车品牌
    private String carColor;//汽车颜色
    private int offerNum;//提供座位数量
    private boolean defaultCar;//是否为默认车辆
    private boolean delStatus=false;

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public String getCarNumber() {
        return carNumber;
    }

    public void setCarNumber(String carNumber) {
        this.carNumber = carNumber;
    }

    public String getCarBrand() {
        return carBrand;
    }

    public void setCarBrand(String carBrand) {
        this.carBrand = carBrand;
    }

    public String getCarColor() {
        return carColor;
    }

    public void setCarColor(String carColor) {
        this.carColor = carColor;
    }

    public int getOfferNum() {
        return offerNum;
    }

    public void setOfferNum(int offerNum) {
        this.offerNum = offerNum;
    }

    public boolean getDefaultCar() {
        return defaultCar;
    }

    public void setDefaultCar(boolean defaultCar) {
        this.defaultCar = defaultCar;
    }

    public boolean getDelStatus() {
        return delStatus;
    }

    public void setDelStatus(boolean delStatus) {
        this.delStatus = delStatus;
    }
}
