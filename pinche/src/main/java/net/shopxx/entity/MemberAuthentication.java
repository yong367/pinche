package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 * @author zhangmengfei
 * @date 2019-9-6 - 10:05
 */
@Entity
public class MemberAuthentication extends BaseEntity<Long>{

    @Column(name = "member_id")
    private Long memberId;

    @Column(name = "real_name")
    private String realName;

    @Column(name = "id_card")
    private String idCard;

    @Column(name = "idCard_front")
    private String idcardFront;

    @Column(name = "idCard_reverse")
    private String idCardReverse;

    @Column(name = "authentication_status",nullable = false)
    private boolean authenticationStatus=false;

    @Column(name = "return_code")
    private String returnCode;

    @Column(name = "return_msg")
    private String returnMsg;

    @Column(name = "faile_number")
    private Integer faileNumber=0;

    public void setFaileNumber(Integer faileNumber) {
        this.faileNumber = faileNumber;
    }

    public Integer getFaileNumber() {
        return faileNumber;
    }

    public String getRealName() {
        return realName;
    }

    public String getIdCard() {
        return idCard;
    }

    public boolean getAuthenticationStatus() {
        return authenticationStatus;
    }

    public String getReturnCode() {
        return returnCode;
    }

    public String getReturnMsg() {
        return returnMsg;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public void setAuthenticationStatus(boolean authenticationStatus) {
        this.authenticationStatus = authenticationStatus;
    }

    public void setReturnCode(String returnCode) {
        this.returnCode = returnCode;
    }

    public void setReturnMsg(String returnMsg) {
        this.returnMsg = returnMsg;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setIdcardFront(String idcardFront) {
        this.idcardFront = idcardFront;
    }

    public void setIdCardReverse(String idCardReverse) {
        this.idCardReverse = idCardReverse;
    }

    public String getIdcardFront() {
        return idcardFront;
    }

    public String getIdCardReverse() {
        return idCardReverse;
    }
}

