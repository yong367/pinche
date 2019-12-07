package net.shopxx.weixin.template.message;

import me.chanjar.weixin.mp.bean.template.WxMpTemplateData;
import net.shopxx.weixin.template.WeiXinTemplate;

import java.util.List;

/**
 * 提现申请到账
 */
public class ProcessApplyCashNotifyMessage extends BaseMessage {
    private String firstTile="您的提现申请已审核完毕！";
    private String remark="请查看您的账户，如有疑问请联系4009698198";

    private String applyCashAmount;
    private String applyCashCreateTime;
    private String applyCashStatus;

    @Override
    public List<WxMpTemplateData> getData() {
        data.add(createWxMpTemplateData("first",firstTile));
        data.add(createWxMpTemplateData("remark",remark));
        data.add(createWxMpTemplateData("keyword1",applyCashCreateTime));
        data.add(createWxMpTemplateData("keyword2",applyCashAmount));
        data.add(createWxMpTemplateData("keyword3",applyCashStatus));
        return data;
    }

    public void setApplyCashAmount(String applyCashAmount) {
        this.applyCashAmount = applyCashAmount;
    }


    public void setApplyCashCreateTime(String applyCashCreateTime) {
        this.applyCashCreateTime = applyCashCreateTime;
    }

    public void setApplyCashStatus(String applyCashStatus) {
        this.applyCashStatus = applyCashStatus;
    }

    public ProcessApplyCashNotifyMessage() {
        this.templateId = WeiXinTemplate.APPLY_CASH_SUCCESS_TEMPLATE.getTemplateId();
    }

}
