package net.shopxx.service.weixin;

import net.shopxx.component.WeiXinManage;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;

@Component
public class WeiXinNotifyService {

    @Resource
    private WeiXinManage weiXinManage;

//    @Async("notifyExecutor")
    /*public void sendApplyCashSuccessNotify(ApplyCash applyCash){
        User user = applyCash.getUser();
        if(StringUtils.hasText(user.getOpenId())){
            ApplyCashNotifyMessage applyCashNotifyMessage = new ApplyCashNotifyMessage();
            applyCashNotifyMessage.setApplyCashAmount(String.valueOf(applyCash.getAmount().intValue())+"元");
            applyCashNotifyMessage.setApplyCashCreateTime(DateCollect.ConvertToStandardtime(applyCash.getCreateTime()));
            applyCashNotifyMessage.setApplyCashSuccessTime(DateCollect.ConvertToStandardtime(applyCash.getPayTime()));
            applyCashNotifyMessage.setOpenId(user.getOpenId());
            applyCashNotifyMessage.setApplyCashType(applyCash.getApplyCashPluginType().equals(ApplyCashPluginType.ALIPAY)?"支付宝":"微信");
            weiXinManage.sendTemplateMessage(applyCashNotifyMessage);
        }
    }*/
}
