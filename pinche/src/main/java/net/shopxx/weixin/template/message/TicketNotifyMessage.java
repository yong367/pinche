package net.shopxx.weixin.template.message;

import me.chanjar.weixin.mp.bean.template.WxMpTemplateData;
import net.shopxx.weixin.template.WeiXinTemplate;

import java.util.List;

public class TicketNotifyMessage extends BaseMessage {

    public TicketNotifyMessage(){
        this.templateId = WeiXinTemplate.TICKET_NOTIFY_TEMPLATE.getTemplateId();
    }

    private String firstTile="您已成功购买激活码，请在软件中激活使用";
    private String remark="您可随时通过【我的订单】查看激活码，如有疑问请联系4009698198。";

    private String ticketCode;
    private String softName;

    @Override
    public List<WxMpTemplateData> getData() {
        data.add(createWxMpTemplateData("first",firstTile));
        data.add(createWxMpTemplateData("remark",remark));
        data.add(createWxMpTemplateData("keyword1",ticketCode));
        data.add(createWxMpTemplateData("keyword2",softName));
        return data;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public void setSoftName(String softName) {
        this.softName = softName;
    }
}
