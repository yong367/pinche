package net.shopxx.component;

import net.shopxx.entity.Member;
import net.shopxx.entity.MobileRechargeLog;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.bo.zhogncheng.*;
import net.shopxx.service.LogPrintService;
import net.shopxx.service.MobileRechargeService;
import net.shopxx.util.*;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;

import javax.inject.Inject;

/**
 * 话费充值组件
 */
@Component
public class MobileRechargeCompoment {

    @Inject
    private LogPrintService logPrintService;

    @Inject
    private MobileRechargeService mobileRechargeService;


    public MobileRechargeLog mobileRecharge(MobileRechargeLog mobileRechargeLog, Member member, String mobile, String amount){
        MobileRechargeRequest mobileRechargeRequest = new MobileRechargeRequest();
        mobileRechargeRequest.setMobile(mobile);
        mobileRechargeRequest.setBack_url(SystemUtils.getSetting().getSiteUrl()+"/notify/mobileRechargeNotify");
        mobileRechargeRequest.setPrice(amount);
        mobileRechargeRequest.setSporderid(mobileRechargeLog.getSn());
        mobileRechargeRequest.setSpordertime(DateCollect.getDateStr(mobileRechargeLog.getCreatedDate(),DateCollect.SDF_VERSION1));
        logPrintService.printServerLog("reqeust mobile recharge body:"+ JsonUtils.toJson(mobileRechargeRequest.getRequestMap()));
        String result = WebUtils.post(ZhongHuaConfig.orderUrl,mobileRechargeRequest.getRequestMap());
        logPrintService.printServerLog("reicive mobile recharge body:="+result);
        if(StringUtils.isNotEmpty(result)){
            MobileRechargeResponse response=new MobileRechargeResponse();
            response.load(result);
            if(response.isRequestSuccess()){
                if(response.isOrderSuccess()){
                    //处理成功等待通知回来!
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.pendingProcess);
                    mobileRechargeLog.setZcOrderNo(response.getOrderid());
                }else{
                    //失败处理
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.failed);
                }
                mobileRechargeLog.setRequestCode(response.getStatus());
                mobileRechargeLog.setRequestMsg(response.getRechargeDesc());
            }else{
                if(response.isQueryFlag()){
                    //调用查询
                    mobileRechargeLog=queryMobileRechargeStatus(mobileRechargeLog);
                }else{
                    //失败处理
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.failed);
                    mobileRechargeLog.setRequestCode(response.getStatus());
                    mobileRechargeLog.setRequestMsg(response.getRechargeDesc());
                }
            }

        }else{
            //需要重新查询订单状态
            mobileRechargeLog=queryMobileRechargeStatus(mobileRechargeLog);
        }
        return mobileRechargeLog;
    }

    public MobileRechargeLog queryMobileRechargeStatus(MobileRechargeLog mobileRechargeLog){
        MobileRechargeQueryRequest mobileRechargeRequest = new MobileRechargeQueryRequest();
        mobileRechargeRequest.setSporderid(mobileRechargeLog.getSn());
        logPrintService.printServerLog("reqeust mobile recharge query body:"+JsonUtils.toJson(mobileRechargeRequest.getRequestMap()));
        String result = WebUtils.post(ZhongHuaConfig.queryOrderUrl,mobileRechargeRequest.getRequestMap());
        logPrintService.printServerLog("reicive mobile recharge query body:="+result);
            MobileRechargeQueryResponse response=new MobileRechargeQueryResponse();
            response.load(result);
            if(response.isRequestSuccess()){
                if("success".equals(response.getStatus())){
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.completed);
                    mobileRechargeLog.setZcOrderNo(response.getOrderid());
                }else if("fail".equals(response.getStatus())){
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.failed);
                }else if("underway".equals(response.getStatus())){
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.pendingProcess);
                    mobileRechargeLog.setZcOrderNo(response.getOrderid());
                }
            }else{
                if("0013".equals(response.getResult())){
                    //30分钟之后查询
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.pendingProcess);
                }else{
                    //按失败处理
                    mobileRechargeLog.setRechargeStatus(MobileRechargeLog.Status.failed);
                }
            }
        mobileRechargeLog.setRequestCode(response.getStatus());
        mobileRechargeLog.setRequestMsg(response.getRechargeDesc());
        return mobileRechargeLog;
    }

}
