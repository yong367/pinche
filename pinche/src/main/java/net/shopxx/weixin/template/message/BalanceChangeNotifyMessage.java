package net.shopxx.weixin.template.message;

import me.chanjar.weixin.mp.bean.template.WxMpTemplateData;
import net.shopxx.util.SystemUtil;
import net.shopxx.util.SystemUtils;
import net.shopxx.weixin.template.WeiXinTemplate;

import java.util.List;

/**
 * 余额变动通知
 */
public class BalanceChangeNotifyMessage extends BaseMessage {
    private String firstTile="您的兑伴儿余额发生变动！";
    private String remark="详情查询【交易记录】，如有疑问请联系4009698198";

    private String createTime;
    private String changeType;
    private String amount;
    private String balance;

    @Override
    public List<WxMpTemplateData> getData() {
        data.add(createWxMpTemplateData("first",firstTile));
        data.add(createWxMpTemplateData("remark",remark));
        data.add(createWxMpTemplateData("keyword1",createTime));
        data.add(createWxMpTemplateData("keyword2",changeType));
        data.add(createWxMpTemplateData("keyword3",amount));
        data.add(createWxMpTemplateData("keyword4",balance));
        return data;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public void setChangeType(String changeType) {
        this.changeType = changeType;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public void setBalance(String balance) {
        this.balance = balance;
    }

    public BalanceChangeNotifyMessage() {
        this.url = SystemUtils.getSetting().getSiteUrl()+ "/member/deposit/log";
        this.templateId = WeiXinTemplate.USER_BALANCE_CHANGE_TEMPLATE.getTemplateId();
    }

}
