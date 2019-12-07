package net.shopxx.entity;

import javax.inject.Inject;
import javax.persistence.Entity;

/**
 * 微信通知信息发送类
 */
@Entity
public class WxNotifyMessageLog extends BaseEntity<Long>{

    public enum NotifyType{
        LimitOfCarNo//限号通知
    }

    private String title;
    private String content;
    private NotifyType notifyType;

    public NotifyType getNotifyType() {
        return notifyType;
    }

    public void setNotifyType(NotifyType notifyType) {
        this.notifyType = notifyType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
