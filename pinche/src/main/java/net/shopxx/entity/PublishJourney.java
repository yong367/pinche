package net.shopxx.entity;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 发布行程表
 */
@Entity
public class PublishJourney extends BaseEntity<Long> {


    private Timestamp departDate;//出发日期
    private int departDateNum;//出发日期数字类型
    private String departTime;//出发时间
    private int departTimeNum;//出发时间
    private int  expireDate;//过期时间
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private CarLine carLine;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Member member;

    private String startSite;//出发地
    private String endSite;//终点
    private String pathwaySite;//途径位置
    private String carNumber;//汽车号牌
    private String carBrand;//汽车品牌
    private String carColor;//汽车颜色
    private int offerNum;//提供座位数量
    private BigDecimal price;//座位价格
    private String remark;//备注
    private int lockNum;//锁定座位数
    private int oddNum;//剩余座位数

    public int getDepartTimeNum() {
        return departTimeNum;
    }

    public void setDepartTimeNum(int departTimeNum) {
        this.departTimeNum = departTimeNum;
    }

    public Timestamp getDepartDate() {
        return departDate;
    }

    public void setDepartDate(Timestamp departDate) {
        this.departDate = departDate;
    }

    public int getDepartDateNum() {
        return departDateNum;
    }

    public void setDepartDateNum(int departDateNum) {
        this.departDateNum = departDateNum;
    }

    public String getDepartTime() {
        return departTime;
    }

    public void setDepartTime(String departTime) {
        this.departTime = departTime;
    }

    public int getExpireDate() {
        return expireDate;
    }

    public void setExpireDate(int expireDate) {
        this.expireDate = expireDate;
    }

    public CarLine getCarLine() {
        return carLine;
    }

    public void setCarLine(CarLine carLine) {
        this.carLine = carLine;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public String getStartSite() {
        return startSite;
    }

    public void setStartSite(String startSite) {
        this.startSite = startSite;
    }

    public String getEndSite() {
        return endSite;
    }

    public void setEndSite(String endSite) {
        this.endSite = endSite;
    }

    public String getPathwaySite() {
        return pathwaySite;
    }

    public void setPathwaySite(String pathwaySite) {
        this.pathwaySite = pathwaySite;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public int getLockNum() {
        return lockNum;
    }

    public void setLockNum(int lockNum) {
        this.lockNum = lockNum;
    }

    public int getOddNum() {
        return oddNum;
    }

    public void setOddNum(int oddNum) {
        this.oddNum = oddNum;
    }
}
