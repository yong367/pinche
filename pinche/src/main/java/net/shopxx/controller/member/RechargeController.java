package net.shopxx.controller.member;

import com.google.common.collect.Maps;
import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Member;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.bo.QueryRechargeStatusResponse;
import net.shopxx.entity.bo.RechargeResponse;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.PaymentTransactionService;
import net.shopxx.service.RechargeService;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 积分充值
 */
@Controller("rechargeController")
@RequestMapping("/member/recharge")
public class RechargeController extends BaseController{

    @Inject
    private RechargeService rechargeService;

    @Inject
    private PaymentTransactionService paymentTransactionService;


    private final List<String> applyAmount= Arrays.asList(new String[]{"5","10","30","50","100","200"});

    @GetMapping("/index")
    public String recharge(@CurrentUser Member currentUser, ModelMap model) {
        return "member/recharge/index";
    }

    @ResponseBody
    @PostMapping("/saveRecharge")
    public Object saveRecharge(@CurrentUser Member currentUser,String mobile,String amount) {
        Map<String,String> result = Maps.newHashMap();
        String status="success";
        String msg="";
        if(StringUtils.hasText(mobile)){
            try{
                RechargeResponse rechargeResponse = rechargeService.rongXuPointRecharge(currentUser,mobile,amount,processRongXuAmount(amount));
                if(rechargeResponse.isSuccess()){
                    result.put("orderId",rechargeResponse.getOrderId());
                    result.put("amtQr",amount);
                    rechargeService.autoUpdateRechargeStatus(rechargeResponse.getOrderId(),currentUser.getId());
                }else{
                    status=rechargeResponse.getStatus();
                    msg = rechargeResponse.getMsg();
                }
            }catch (Exception e){
                e.printStackTrace();
                status="error";
                msg="充值失败！请重新尝试！";
            }

        }else{
            status="error";
            msg="手机号不能为空！";
        }
        result.put("status",status);
        result.put("msg",msg);
        return result;
    }
    private String processRongXuAmount(String amount){
        switch (amount){
            case "1":return "3";
            case "3":return "4.5";
            case "6":return "9";
            case "7":return "11.25";
            case "12":return "18.75";
            case "20":return "30";
            case "40":return "60";
            case "75":return "112.50";
            default:return "0";
        }
    }
    private String processUnicomAmount(String amount){
        switch (amount){
            case "3":return "5";
            case "5":return "10";
            case "10":return "20";
            case "30":return "50";
            default:return "0";
        }
    }
    @ResponseBody
    @PostMapping("/saveUnicomRecharge")
    public Object saveUnicomRecharge(@CurrentUser Member currentUser,String mobile,String amount,String code) {
        Map<String,String> result = Maps.newHashMap();
        String status="success";
        String msg="";
        if(StringUtils.hasText(mobile)){
            try{
                RechargeResponse rechargeResponse = rechargeService.unicomRecharge(currentUser,mobile,amount,processUnicomAmount(amount),code);
                if(rechargeResponse.isSuccess()){
                    result.put("orderId",rechargeResponse.getOrderId());
                    result.put("amount",amount);
                }else{
                    status=rechargeResponse.getStatus();
                    msg = rechargeResponse.getMsg();
                }
            }catch (Exception e){
                e.printStackTrace();
                status="error";
                msg="充值失败！请重新尝试！";
            }

        }else{
            status="error";
            msg="手机号不能为空！";
        }
        result.put("status",status);
        result.put("msg",msg);
        return result;
    }

    @ResponseBody
    @GetMapping("/queryRechargeStatus")
    public Object queryRechargeStatus(@CurrentUser Member currentUser,String orderId) {
        Map<String,String> result = Maps.newHashMap();
        String status;
        String msg="";
        PaymentTransaction paymentTransaction = paymentTransactionService.findByExtendOne(orderId);
        if (paymentTransaction != null) {
            if(paymentTransaction.getIsSuccess()){
                result.put("payStatus","paysuccess");
            }else{
                result.put("payStatus","unpay");
            }
            status ="success";
        }else{
            status="error";
            msg="此订单不存在！";
        }
        result.put("status",status);
        result.put("msg",msg);
        return result;
    }


}
