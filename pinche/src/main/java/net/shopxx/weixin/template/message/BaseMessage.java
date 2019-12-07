package net.shopxx.weixin.template.message;

import me.chanjar.weixin.mp.bean.template.WxMpTemplateData;

import java.util.ArrayList;
import java.util.List;

public abstract class BaseMessage {
    protected String templateId;
    protected String openId;
    protected String url;
    protected List<WxMpTemplateData> data = new ArrayList<>();

    public abstract List<WxMpTemplateData> getData();

    public String getTemplateId() {
        return templateId;
    }

    public String getOpenId() {
        return openId;
    }

    public void setOpenId(String openId) {
        this.openId = openId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    protected WxMpTemplateData createWxMpTemplateData(String name, String value){
        WxMpTemplateData wxMpTemplateData = new WxMpTemplateData();
        wxMpTemplateData.setName(name);
        wxMpTemplateData.setValue(value);
        return wxMpTemplateData;
    }


}
