package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 *
 *
 * @Author zhangmengfei
 * @Date 2019-9-17 - 16:09
 */
@Entity
public class Cities extends BaseEntity<Long>{

    @Column
    private String cityid;
    @Column
    private String city;
    @Column
    private String provinceid;

    public void setCityid(String cityid) {
        this.cityid = cityid;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setProvinceid(String provinceid) {
        this.provinceid = provinceid;
    }

    public String getCityid() {
        return cityid;
    }

    public String getCity() {
        return city;
    }

    public String getProvinceid() {
        return provinceid;
    }
}
