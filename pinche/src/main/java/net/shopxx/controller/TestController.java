package net.shopxx.controller;

import com.suning.api.exception.SuningApiException;
import me.chanjar.weixin.common.bean.WxJsapiSignature;
import me.chanjar.weixin.common.exception.WxErrorException;
import me.chanjar.weixin.mp.api.WxMpService;
import net.shopxx.component.SystemLock;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.MemberService;
import net.shopxx.service.UserService;
import net.shopxx.suning.model.*;
import net.shopxx.util.DateCollect;
import net.shopxx.util.WorkThread;
import org.apache.poi.ss.util.NumberToTextConverter;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Controller("testController")
@RequestMapping("/myTest")
public class TestController {

    private String cityId="311"; //城市ID

    private String skuId="601771351";//商品skuid

    private String countyId="23";//区县ID

    private String districtId="23";// 区编码

    private String townId ="04";//镇编码

    private String orderID="100000106839";
    private String orderItemId="10000010683901";

    @Inject
    private UserService userService;
    @Inject
    private MemberService memberService;
    @Inject
    private MemberRankService memberRankService;

    @Inject
    private WxMpService wxService;
    @Inject
    private SystemLock systemLock;


    private ExecutorService executorService = Executors.newFixedThreadPool(10);
    private int a=0;
    private int b=100;

    @GetMapping("/test1")
    @ResponseBody
    public Object test1() throws SuningApiException, WxErrorException {
        synchronized (systemLock.getAndCreateLock(1L, SystemLock.TASK_INFO_LOCK)){
            System.out.println(a++);
        }
        return a;
    }

    @GetMapping("/test2")
    @ResponseBody
    public Object test2() throws SuningApiException, WxErrorException {
        synchronized (systemLock.getAndCreateLock(1L, SystemLock.TASK_NOTIFY_LOCK)){
            System.out.println(b++);
        }
        return b;
    }


    @GetMapping("/getweixinBaseInfo")
    @ResponseBody
    public Object getweixinBaseInfo(String url) throws SuningApiException, WxErrorException {
        Map<String,Object> result = new HashMap<>();
        WxJsapiSignature signature = wxService.createJsapiSignature(url);
        result.put("appId", signature.getAppId());
        result.put("timestamp", signature.getTimestamp());
        result.put("nonceStr",signature.getNonceStr());
        result.put("signature",signature.getSignature());
        return result;
    }



}
