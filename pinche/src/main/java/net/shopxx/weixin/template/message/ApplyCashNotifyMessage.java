package net.shopxx.weixin.template.message;

import me.chanjar.weixin.mp.bean.template.WxMpTemplateData;
import net.shopxx.weixin.template.WeiXinTemplate;

import java.util.List;

/**
 * 提现申请
 */
public class ApplyCashNotifyMessage extends BaseMessage {
    private String firstTile="您的提现申请已被成功受理！";
    private String remark="随后请关注提现结果通知。";

    private String applyCashAmount;
    private String applyCashType;
    private String applyCashCreateTime;
    private String username;

    @Override
    public List<WxMpTemplateData> getData() {
        data.add(createWxMpTemplateData("first",firstTile));
        data.add(createWxMpTemplateData("remark",remark));
        data.add(createWxMpTemplateData("keyword1",username));
        data.add(createWxMpTemplateData("keyword2",applyCashCreateTime));
        data.add(createWxMpTemplateData("keyword3",applyCashAmount));
        data.add(createWxMpTemplateData("keyword4",applyCashType));
        return data;
    }

    public void setApplyCashAmount(String applyCashAmount) {
        this.applyCashAmount = applyCashAmount;
    }

    public void setApplyCashType(String applyCashType) {
        this.applyCashType = applyCashType;
    }

    public void setApplyCashCreateTime(String applyCashCreateTime) {
        this.applyCashCreateTime = applyCashCreateTime;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public ApplyCashNotifyMessage() {
        this.templateId = WeiXinTemplate.APPLY_CASH_TEMPLATE.getTemplateId();
    }

}
