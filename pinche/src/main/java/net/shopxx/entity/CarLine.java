package net.shopxx.entity;

import javax.persistence.Entity;

/**
 * 汽车线路
 */
@Entity
public class CarLine extends BaseEntity<Long>{
    private String fromSite;//开始位置
    private String toSite;//到什么位置
    private boolean useStatus=true;//启动状态

    public String getFromSite() {
        return fromSite;
    }

    public void setFromSite(String fromSite) {
        this.fromSite = fromSite;
    }

    public String getToSite() {
        return toSite;
    }

    public void setToSite(String toSite) {
        this.toSite = toSite;
    }

    public boolean getUseStatus() {
        return useStatus;
    }

    public void setUseStatus(boolean useStatus) {
        this.useStatus = useStatus;
    }
}
