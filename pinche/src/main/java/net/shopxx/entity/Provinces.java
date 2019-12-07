package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 *
 *
 * @Author zhangmengfei
 * @Date 2019-9-19 - 8:49
 */
@Entity
public class Provinces extends BaseEntity<Long>{

    @Column(nullable = false)
    private Long provinceid;
    @Column(nullable = false)
    private String province;

    public void setProvinceid(Long provinceid) {
        this.provinceid = provinceid;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public Long getProvinceid() {
        return provinceid;
    }

    public String getProvince() {
        return province;
    }
}
