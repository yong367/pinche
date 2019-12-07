package net.shopxx.controller.business;

import me.chanjar.weixin.common.bean.WxJsapiSignature;
import me.chanjar.weixin.common.exception.WxErrorException;
import me.chanjar.weixin.mp.api.WxMpService;
import me.chanjar.weixin.mp.bean.result.WxMpOAuth2AccessToken;
import net.shopxx.Setting;
import net.shopxx.entity.*;
import net.shopxx.service.*;
import net.shopxx.util.AESUtils;
import net.shopxx.util.PassWordUtil;
import net.shopxx.util.SystemUtils;
import net.shopxx.util.WorkThread;
import org.apache.commons.lang.BooleanUtils;
import org.apache.poi.ss.util.NumberToTextConverter;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.persistence.OptimisticLockException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 订单二维码核销控制类
 */
@Controller("orderQrCodeController")
@RequestMapping("/qrCode")
public class OrderQrCodeController extends BaseController {

    @Inject
    private WxMpService wxService;

    @Inject
    private OrderService orderService;

    @Inject
    private StoreClerkService storeClerkService;

    @Inject
    private LogPrintService logPrintService;

    @Inject
    private SkuService skuService;

    private final String error_view ="/business/error";

    private ExecutorService executorService = Executors.newFixedThreadPool(15);
    /**
     *
     * @param code
     * @return
     */
    @GetMapping("/preOrderQRcodeInfo")
    public ModelAndView preOrderQRcode(String code){
        Setting setting = SystemUtils.getSetting();
        String redirect_uri =wxService.oauth2buildAuthorizationUrl(setting.getSiteUrl()+"/qrCode/orderQRcodeInfo/"+ code,"snsapi_base","STATUS");
      ModelAndView modelAndView = new ModelAndView();
      modelAndView.setViewName("redirect:"+redirect_uri);
        return modelAndView;
    }



  /*  @PostMapping("/test")
    public void test(HttpServletRequest request,HttpServletResponse response) throws IOException {
        *//*Map map=request.getParameterMap();
        Set keSet=map.entrySet();
        for(Iterator itr = keSet.iterator(); itr.hasNext();){
            Map.Entry me=(Map.Entry)itr.next();
            Object ok=me.getKey();
            Object ov=me.getValue();
            String[] value=new String[1];
            if(ov instanceof String[]){
                value=(String[])ov;
            }else{
                value[0]=ov.toString();
            }

            for(int k=0;k<value.length;k++){
                System.out.println(ok+"="+value[k]);
            }
        }
        BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream(),"utf-8"));
        String line = null;
        StringBuilder responseBody = new StringBuilder();
        while ((line = br.readLine()) != null) {
            responseBody.append(line);
        }
       XMLSerializer xmlSerializer = new XMLSerializer();
        xmlSerializer.setRootName("xml");
        xmlSerializer.read(responseBody.toString());
        JSON jsonObject = xmlSerializer.read(responseBody.toString());
        System.out.println(jsonObject.toString());
        String echostr = request.getParameter("echostr");
        PrintWriter out = response.getWriter();
        out.print(echostr);
        out.close();
        out = null;*//*
        File file=new File("d:/test.xlsx");//获取Excel文件对象
        FileInputStream fs=new FileInputStream(file);//把文件对象转换成IO流
        XSSFWorkbook workbook = new XSSFWorkbook(fs);
        XSSFSheet sheet = workbook.getSheetAt(0);
        int rowCount = sheet.getPhysicalNumberOfRows();
        System.out.println("hangshu"+rowCount);
        for (int i = 1; i <rowCount ; i++) {
            XSSFRow row = sheet.getRow(i);
            if(row != null){
                XSSFCell mobile= row.getCell(0);
                XSSFCell time=row.getCell(1);
//               saveUser(NumberToTextConverter.toText(mobile.getNumericCellValue()),time.getDateCellValue());
                executorService.execute(new WorkThread(NumberToTextConverter.toText(mobile.getNumericCellValue()),time.getDateCellValue()));
            }
        }
    }*/


    @RequestMapping("/orderQRcodeInfo/{code}")
    public ModelAndView orderQRcodeInfo(@PathVariable String code,HttpServletRequest request) throws WxErrorException {//已经能正确获取到用户的openid
        System.out.println("进入二维码核销入口--------------------");
        ModelAndView modelAndView = new ModelAndView();
        String msg="";
        String viewName="";
        String wxcode = request.getParameter("code");
        String result="";
        try{
            WxMpOAuth2AccessToken wxMpOAuth2AccessToken= wxService.oauth2getAccessToken(wxcode);
            String userOpenid = wxMpOAuth2AccessToken.getOpenId();
            Setting setting = SystemUtils.getSetting();
            result = AESUtils.dcodes(code,setting.getOrderQrCodeSignKey());
            String[] ret = result.split("&");
            String orderNo = ret[0];
            String createTime = ret[1];
            long currentTime = System.currentTimeMillis();
            long qrCreateTime = Long.parseLong(createTime);
            long time = (currentTime-qrCreateTime)/60000;
            long expireTime = Long.valueOf(setting.getOrderQrCodeExpireTime());
            if(time <= expireTime){
                synchronized (orderNo.intern()) {
                Order order = orderService.findBySn(orderNo);
                if(order!=null && !order.hasExpired()){
                        if (!Order.Status.completed.equals(order.getStatus())) {
                            //通过店铺ID 和用户的opengId 区查找是否该店铺下存在该店员。如果店员不存在 则提示非法操作。如果不是则打开订单详情页面
                            StoreClerk storeClerk = storeClerkService.findByOpenId(userOpenid);
                            if (storeClerk != null && order.getStore().getId().equals(storeClerk.getStore().getId())) {
                                order.setStoreClerkId(storeClerk.getId());
                                order.setStatus(Order.Status.received);
                                orderService.qrOrdercomplete(order);
                                logPrintService.printServerLog("店铺" + order.getStore().getName() + "通过微信快捷完成订单，订单号：" + orderNo + ",操作员openid=" + userOpenid);
                                msg = "操作成功！";
                                viewName = "business/order/result";
                            } else {
                                msg = "非该店铺操作人员请勿操作！";
                                viewName = error_view;
                            }
                        } else {
                            msg = "操作成功！";
                            viewName = "business/order/result";
                        }

                }else{
                    msg="订单号不存在,或者订单已经过期！";
                    viewName=error_view;
                }
                }
            }else{
                msg="订单二维码失效！";
                viewName=error_view;
            }
        }catch (Exception e){
            e.printStackTrace();
            msg = "访问失败，请重试！";
            viewName=error_view;
            logPrintService.printServerLog(result,e);
        }
        modelAndView.addObject("msg",msg);
        modelAndView.setViewName(viewName);
        return modelAndView;
    }

}
