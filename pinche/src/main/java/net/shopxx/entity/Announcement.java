package net.shopxx.entity;

import javax.persistence.Entity;
import javax.persistence.Lob;

@Entity
public class Announcement extends BaseEntity<Long>{

    private String title;
    @Lob
    private String introduction;
    private boolean showFlag;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public boolean isShowFlag() {
        return showFlag;
    }

    public void setShowFlag(boolean showFlag) {
        this.showFlag = showFlag;
    }
}
