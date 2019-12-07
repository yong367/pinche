package net.shopxx.controller.wx;


import net.shopxx.entity.Business;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreClerk;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.LogPrintService;
import net.shopxx.service.MemberService;
import net.shopxx.service.StoreClerkService;
import net.shopxx.service.StoreService;
import net.shopxx.weixin.service.WeixinService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@Controller("weixinController")
@RequestMapping("/weixin")
public class WeixinController {
    @Inject
    private WeixinService weixinService;
    @Inject
    private StoreClerkService storeClerkService;
    @Inject
    private StoreService storeService;
    
    public static final String LOCK = "table_a_b_lock";

    @Inject
    private LogPrintService logger;
    /**
     * Get请求验证Token，Post请求是消息回调信息
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(path = "/callback",method = {RequestMethod.GET,RequestMethod.POST})
    public void check( HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("进入回调---------------");
        boolean isGet = request.getMethod().toLowerCase().equals("get");
                PrintWriter print;
                if (isGet) {
                    // 微信加密签名
                    String signature = request.getParameter("signature");
                    // 时间戳
                    String timestamp = request.getParameter("timestamp");
                    // 随机数
                    String nonce = request.getParameter("nonce");
                    // 随机字符串
                    String echostr = request.getParameter("echostr");
                    // 通过检验signature对请求进行校验，若校验成功则原样返回echostr，表示接入成功，否则接入失败
                    if (signature != null && weixinService.checkSignature(signature, timestamp, nonce)) {
                        try {
                            print = response.getWriter();
                            print.write(echostr);
                            print.flush();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
            }else{
                     synchronized (LOCK){//代码块全局锁
                        //如果是post请求，则是消息回调信息
                         System.out.println("进入店员绑定---------------");
                        Map<String,String> map=weixinService.handlePublicMsg(request);//获取信息
                         if(map!=null){
                             StoreClerk storeClerk=new StoreClerk();
                             storeClerk.setOpenId(map.get("FromUserName"));
                             if(storeClerkService.openIdExists(map.get("FromUserName"))){
                                 if("SCAN".equals(map.get("Event"))){//已经关注扫描二维码
                                     logger.printServerLog("此微信号已绑定了其他店铺:openId=" +map.get("FromUserName")+"----来自商店ID："+map.get("EventKey")+"的消息" );
                                 }else if("subscribe".equals(map.get("Event"))) {//未关注订阅公众号事件
                                     logger.printServerLog("此微信号已绑定了其他店铺:openId=" +map.get("FromUserName")+"----来自商店ID："+map.get("EventKey").replace("qrscene_","")+"的消息" );
                                 }
                             }else{//此openid未在其他店铺保存
                                 if("SCAN".equals(map.get("Event"))){//已经关注扫描二维码
                                     storeClerk.setStore(storeService.find(Long.parseLong(map.get("EventKey"))));
                                     //已关注事件下直接得到参数ID (EventKey),根据ID查询店铺
                                     storeClerkService.save(storeClerk);
                                 }else if("subscribe".equals(map.get("Event"))){//未关注订阅公众号事件
                                     storeClerk.setStore(storeService.find(Long.parseLong(map.get("EventKey").replace("qrscene_",""))));
                                     //未关注事件下qrscene_XX,XX是ID,根据ID查询店铺
                                     storeClerkService.save(storeClerk);
                                 }
                             }
                         }
                        
                    }
                }
        }
}
