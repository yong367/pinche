package net.shopxx.component;

import me.chanjar.weixin.mp.api.WxMpService;
import me.chanjar.weixin.mp.api.WxMpTemplateMsgService;
import me.chanjar.weixin.mp.bean.template.WxMpTemplateMessage;
import net.shopxx.weixin.template.message.BaseMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Component
public class WeiXinManage {
    private Logger logger = LoggerFactory.getLogger(getClass());
    @Resource
    private WxMpService wxMpService;

    /**
     * 发送微信公众号通知
     * @param baseMessage
     */

    public void sendTemplateMessage(BaseMessage baseMessage){
        try{
            WxMpTemplateMsgService wxMpTemplateMsgService=wxMpService.getTemplateMsgService();
            WxMpTemplateMessage wxMpTemplateMessage = new WxMpTemplateMessage();
            wxMpTemplateMessage.setToUser(baseMessage.getOpenId());
            wxMpTemplateMessage.setTemplateId(baseMessage.getTemplateId());
            wxMpTemplateMessage.setData(baseMessage.getData());
            if(baseMessage.getUrl()!=null){
                wxMpTemplateMessage.setUrl(baseMessage.getUrl());
            }
            wxMpTemplateMsgService.sendTemplateMsg(wxMpTemplateMessage);

        }catch (Exception e){
            logger.error("处理用户提现微信公众号消息通知出现异常",e);
        }
    }
}
