package net.shopxx.service.impl;

import com.github.rholder.retry.Retryer;
import com.github.rholder.retry.RetryerBuilder;
import com.github.rholder.retry.StopStrategies;
import com.github.rholder.retry.WaitStrategies;
import com.google.common.base.Predicates;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.component.AlipayCashComponent;
import net.shopxx.component.WeiXinManage;
import net.shopxx.component.WxCashComponent;
import net.shopxx.dao.AppliCashDao;
import net.shopxx.entity.AppliCash;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.SocialUser;
import net.shopxx.entity.bo.weixin.WxSearchRequest;
import net.shopxx.entity.bo.weixin.WxSearchResponse;
import net.shopxx.service.AppliCashService;
import net.shopxx.service.LogPrintService;
import net.shopxx.service.MemberService;
import net.shopxx.util.DateCollect;
import net.shopxx.util.SystemUtil;
import net.shopxx.util.WebUtils;
import net.shopxx.weixin.config.WxPayServerConfig;
import net.shopxx.weixin.template.message.ApplyCashNotifyMessage;
import net.shopxx.weixin.template.message.ProcessApplyCashNotifyMessage;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;
import java.util.concurrent.Callable;
import java.util.concurrent.TimeUnit;

/**
 * 提现实现类
 */
@Service
@Transactional
public class AppliCashServiceImpl extends BaseServiceImpl<AppliCash,Long> implements AppliCashService {
    @Inject
    private AppliCashDao appliCashDao;
    @Inject
    private MemberService memberService;
    @Inject
    private LogPrintService logPrintService;
    @Inject
    private WxPayServerConfig wxPayServerConfig;

    @Lazy
    @Inject
    private AlipayCashComponent alipayCashComponent;

    @Lazy
    @Inject
    private WxCashComponent wxCashComponent;

    @Inject
    private WeiXinManage weiXinManage;
    
    //微信提现接口地址
    private final String wxCashUrl = "https://api.mch.weixin.qq.com/mmpaymkttransfers/promotion/transfers";
    //微信查询接口地址
    private final String wxSearchResultUrl = "https://api.mch.weixin.qq.com/mmpaymkttransfers/gettransferinfo";


    @Override
    public BigDecimal findByApplyCashPluginTypeAndStatus(AppliCash.cashMethod cashMethod, Member currentUser) {
        return appliCashDao.findByApplyCashPluginTypeAndStatus(cashMethod,currentUser);
    }

    @Override
    public void applyCash(AppliCash appliCash, Member member) {

        Assert.notNull(appliCash);
        Assert.notNull(member);
        Assert.isTrue(appliCash.getAmount().compareTo(BigDecimal.ZERO) > 0);
        appliCash.setOrderId(SystemUtil.genOrderId());
        appliCash.setMember(member);
        appliCash.setStatus(AppliCash.Status.PROCESSING);
        BigDecimal amount=appliCash.getAmount();
        BigDecimal feeAmount=amount.multiply(new BigDecimal(6)).divide(new BigDecimal(1000));
        appliCash.setTransferAmount(amount.subtract(feeAmount));
        save(appliCash);
        processApplyCashNotify(appliCash,member);
        //调微信之前先扣款
        memberService.addBalance(appliCash.getMember(), amount.negate(), MemberDepositLog.Type.cash,"申请提现");
    }

    /**
     * 提现申请通知可以了
     * @param appliCash
     * @param currentUser
     */
    private void processApplyCashNotify(AppliCash appliCash,Member currentUser){
        if (currentUser.getSocialUsers().size() > 0 ) {
            Iterator<SocialUser> it = currentUser.getSocialUsers().iterator();
            while (it.hasNext()){
                SocialUser socialUser = it.next();
                if(socialUser.getLoginPluginId().equals("weixinLoginPlugin")){
                    String userOpenID = socialUser.getUniqueId();
                    ApplyCashNotifyMessage applyCashNotifyMessage = new ApplyCashNotifyMessage();
                    applyCashNotifyMessage.setApplyCashAmount(String.valueOf(appliCash.getAmount().intValue()));
                    applyCashNotifyMessage.setApplyCashType(appliCash.getCashMethod().equals(AppliCash.cashMethod.wxCash)?"微信":"支付宝");
                    applyCashNotifyMessage.setUsername(currentUser.getUsername());
                    applyCashNotifyMessage.setApplyCashCreateTime(DateCollect.getDateStr(appliCash.getCreatedDate(),DateCollect.SDF_VERSION1));
                    applyCashNotifyMessage.setOpenId(userOpenID);
                    weiXinManage.sendTemplateMessage(applyCashNotifyMessage);
                }
            }
        }
    }

    @Override
    public void wxNotifyMessage(AppliCash appliCash, Member currentUser) {
        if (currentUser.getSocialUsers().size() > 0 ) {
            Iterator<SocialUser> it = currentUser.getSocialUsers().iterator();
            while (it.hasNext()){
                SocialUser socialUser = it.next();
                if(socialUser.getLoginPluginId().equals("weixinLoginPlugin")){
                    String userOpenID = socialUser.getUniqueId();
                    ProcessApplyCashNotifyMessage applyCashNotifyMessage = new ProcessApplyCashNotifyMessage();
                    applyCashNotifyMessage.setApplyCashAmount(String.valueOf(appliCash.getAmount().intValue()));
                    applyCashNotifyMessage.setApplyCashStatus(appliCash.getStatus().equals(AppliCash.Status.SUCCESS)?"提现成功":"提现失败");
                    applyCashNotifyMessage.setApplyCashCreateTime(DateCollect.getDateStr(new Date(),DateCollect.SDF_VERSION1));
                    applyCashNotifyMessage.setOpenId(userOpenID);
                    weiXinManage.sendTemplateMessage(applyCashNotifyMessage);
                }
            }
        }
    }

    /**
     * 提现
     * @param appliCash
     */
    @Override
    public void applyCashTransfer(AppliCash appliCash) {
        if (AppliCash.cashMethod.wxCash.equals(appliCash.getCashMethod())) {
            //微信提现
            wxCashComponent.applyCashTransfer(appliCash);
        }
        if (AppliCash.cashMethod.alipayCash.equals(appliCash.getCashMethod())) {
            //支付宝提现
            alipayCashComponent.applyCashTransfer(appliCash);
        }
    }
    
   


    /**
     * 查询提现状态
     */
    @Async("taskExecutor")
    @Transactional
    public void queryCashStatus(String orderId, final Long memberId) {
        //通过orderId 查wxCash
         final AppliCash appliCash = find("orderId",orderId);
        if (appliCash != null) {
            try {
                Retryer<Boolean> retryer = RetryerBuilder.<Boolean>newBuilder()
                        .retryIfException()
                        .retryIfResult(Predicates.equalTo(false))
                        .withWaitStrategy(WaitStrategies.incrementingWait(10, TimeUnit.SECONDS, 30, TimeUnit.SECONDS))
                        .withStopStrategy(StopStrategies.stopAfterAttempt(10))
                        .build();
                retryer.call(new Callable<Boolean>() {
                    public Boolean call() throws Exception {
                        Member member = memberService.find(memberId);
                        //重新发起查询
                        WxSearchRequest wxSearchRequest = new WxSearchRequest(wxPayServerConfig);
                        String searchResult = wxSearchRequest.fillRequestData();
                        String returnSearchInfo = WebUtils.postXmlToWx(wxSearchResultUrl, searchResult, true, wxPayServerConfig);
                        WxSearchResponse wxSearchResponse = new WxSearchResponse();
                        wxSearchResponse.load(returnSearchInfo);
                      
                        boolean flag;
                        if ("PROCESSING".equals(wxSearchResponse.getStatus())) {
                            flag = false;
                        } else {
                            //这里自己根据提现状态 设置 wxcash 的交易状态
                            if ("SUCCESS".equals(wxSearchResponse.getStatus())) {
                                appliCash.setStatus(AppliCash.Status.SUCCESS);
                            }
                            if ("FAILED".equals(wxSearchResponse.getStatus())) {
                                appliCash.setStatus(AppliCash.Status.FAILED);
                                memberService.addBalance(appliCash.getMember(), appliCash.getAmount(), MemberDepositLog.Type.cashRefunds,"提现退款");
                            }
                            wxNotifyMessage(appliCash,appliCash.getMember());
                            flag = true;
                        }
                        return flag;
                    }
                });
            } catch (Exception e) {
                appliCash.setStatus(AppliCash.Status.CashException);
                e.printStackTrace();
                memberService.addBalance(appliCash.getMember(), appliCash.getAmount(), MemberDepositLog.Type.cashRefunds,"提现退款");
                logPrintService.printServerLog("对不起，没有查询到记录");
            }
            update(appliCash);
        }
    }

    /**
     * 查找提现分页记录
     * @param member
     *            会员
     * @param pageable
     *            分页信息
     * @return
     */
    @Override
    public Page<AppliCash> findPage(Member member, Pageable pageable) {
        return appliCashDao.findPage(member,pageable);
    }

  
}
