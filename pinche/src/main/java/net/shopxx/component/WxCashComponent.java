package net.shopxx.component;

import com.google.common.collect.Maps;
import net.shopxx.dao.AppliCashDao;
import net.shopxx.entity.AppliCash;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.bo.weixin.WxCashRequest;
import net.shopxx.entity.bo.weixin.WxCashResponse;
import net.shopxx.service.AppliCashService;
import net.shopxx.service.LogPrintService;
import net.shopxx.service.MemberService;
import net.shopxx.util.SystemUtil;
import net.shopxx.util.WebUtils;
import net.shopxx.weixin.config.WxPayServerConfig;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.Map;

@Component
public class WxCashComponent  {
    @Inject
    private AppliCashDao appliCashDao;
    @Inject
    private MemberService memberService;
    @Inject
    private LogPrintService logPrintService;
    @Inject
    private WxPayServerConfig wxPayServerConfig;
    @Inject
    private AppliCashService appliCashService;
    //微信提现接口地址
    private final String wxCashUrl = "";
    //微信查询接口地址
    private final String wxSearchResultUrl = "";
    /**
     * 申请提现
     * @param appliCash
     *            提现
     * @param member
     */
    public void applyCash(AppliCash appliCash, Member member) {
        Assert.notNull(appliCash);
        Assert.notNull(member);
        Assert.isTrue(appliCash.getAmount().compareTo(BigDecimal.ZERO) > 0);
        appliCash.setOrderId(SystemUtil.genOrderId());
        appliCash.setCashMethod(AppliCash.cashMethod.wxCash);
        appliCash.setMember(member);
        //调微信之前先扣款
        memberService.addBalance(appliCash.getMember(), appliCash.getAmount().negate(), MemberDepositLog.Type.cash,"申请提现");
        processWxCash(appliCash, AppliCash.Status.PROCESSING,null,null);
    }

    /**
     * 进行提现
     * @param appliCash
     * @return
     */
    public Map applyCashTransfer(AppliCash appliCash) {
        Map<String,String> returnResult = Maps.newHashMap();
        String returnMsg = "提现成功";

        try {
            Member member = appliCash.getMember();
            WxCashRequest wxCashRequest = new WxCashRequest(wxPayServerConfig);
            wxCashRequest.setPartnerTradeNo(appliCash.getOrderId());
            wxCashRequest.setOpenId(appliCash.getOpenid());
            wxCashRequest.setMoney(appliCash.getTransferAmount());
            String result = wxCashRequest.fillRequestData();
            String returnInfo = WebUtils.postXmlToWx(wxCashUrl,result,true,wxPayServerConfig);
            logPrintService.printServerLog("微信提现返回结果" + returnInfo);
            System.out.println("微信提现返回结果" + returnInfo);
            WxCashResponse wxCashResponse = new WxCashResponse();
            wxCashResponse.load(returnInfo);
            if(wxCashResponse.isSuccess()) {
                //请求成功
                if(wxCashResponse.isPaySuccess()) {
                    //提现成功
                    processWxCash(appliCash, AppliCash.Status.SUCCESS,"提现成功","000000");
                    appliCashService.wxNotifyMessage(appliCash,member);
                } else {
                    //提现不成功，用原商户订单号重试，或通过查询接口确认此次付款的结果
                    if("SYSTEMERROR".equals(wxCashResponse.getErrCode())) {
                        processWxCash(appliCash, AppliCash.Status.PROCESSING,wxCashResponse.getErrCodeDes(),wxCashResponse.getErrCode());
                        //status SUCCESS:转账成功  FAILED:转账失败  PROCESSING:处理中 (重试机制)
                        appliCashService.queryCashStatus(appliCash.getOrderId(),member.getId());
                        returnMsg = "处理中";

                    } else {
                        returnMsg = wxCashResponse.getErrCodeDes();
                        processWxCash(appliCash, AppliCash.Status.FAILED,wxCashResponse.getErrCodeDes(),wxCashResponse.getErrCode());
                        memberService.addBalance(appliCash.getMember(), appliCash.getAmount(), MemberDepositLog.Type.cashRefunds,"提现退款");
                        appliCashService.wxNotifyMessage(appliCash,member);
                    }

                }

            } else {
                memberService.addBalance(appliCash.getMember(), appliCash.getAmount(), MemberDepositLog.Type.cashRefunds,"提现退款");
                returnMsg = wxCashResponse.getReturnMsg();
                processWxCash(appliCash, AppliCash.Status.FAILED,wxCashResponse.getReturnMsg(),wxCashResponse.getReturnCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        returnResult.put("returnMsg",returnMsg);
        return returnResult;
    }

    private void processWxCash(AppliCash appliCash, AppliCash.Status status, String returnMsg, String returnCode){
        appliCash.setStatus(status);
        appliCash.setReturnCode(returnCode);
        appliCash.setReturnMsg(returnMsg);
        appliCashDao.persist(appliCash);
    }
    
}
