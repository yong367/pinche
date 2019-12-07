package net.shopxx.entity;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 会员常用路线表
 */
@Entity
public class MemberCommonLine extends BaseEntity<Long> {

    public enum LineDirection{
        forward,//正向
        inversion//反向
    }
    private String departTime;//出发时间
    private int departTimeNum;//出发时间
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private CarLine carLine;
    private LineDirection lineDirection;
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


    public String getDepartTime() {
        return departTime;
    }

    public void setDepartTime(String departTime) {
        this.departTime = departTime;
    }

    public CarLine getCarLine() {
        return carLine;
    }

    public void setCarLine(CarLine carLine) {
        this.carLine = carLine;
    }

    public LineDirection getLineDirection() {
        return lineDirection;
    }

    public void setLineDirection(LineDirection lineDirection) {
        this.lineDirection = lineDirection;
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

    public int getDepartTimeNum() {
        return departTimeNum;
    }

    public void setDepartTimeNum(int departTimeNum) {
        this.departTimeNum = departTimeNum;
    }
}
