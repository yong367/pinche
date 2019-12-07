package net.shopxx.controller.ws;

import com.github.rholder.retry.Retryer;
import com.github.rholder.retry.RetryerBuilder;
import com.github.rholder.retry.StopStrategies;
import com.github.rholder.retry.WaitStrategies;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.PointLog;
import net.shopxx.service.*;
import net.shopxx.util.CodeUtils;
import net.shopxx.util.PassWordUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.Date;
import java.util.concurrent.Callable;
import java.util.concurrent.TimeUnit;

@Controller("ruYiUserController")
@RequestMapping("/ws")
public class RuYiUserController {

    @Inject
    private UserService userService;
    @Inject
    private MemberService memberService;
    @Inject
    private MemberRankService memberRankService;

    @Inject
    private PointLogService pointLogService;
    @Inject
    private MemberDepositLogService memberDepositLogService;


    @ResponseBody
    @PostMapping("/userPoint")
    public String userRigister(String orderNo, String mobile, long point){
        String ret="";
        final String orderid="RY"+orderNo;
        if(!pointLogService.exists(orderid)){
        Retryer<String> retryer = RetryerBuilder.<String>newBuilder()
                .retryIfException()
                .withWaitStrategy(WaitStrategies.fixedWait(500, TimeUnit.MILLISECONDS))
                .withStopStrategy(StopStrategies.stopAfterAttempt(5))
                .build();
        final String userName = mobile;
        final long userPoint =point;
        try {
            ret= retryer.call(new Callable<String>() {
                @Override
                public String call() throws Exception {
                    Member member = memberService.findByUsername(userName);
                    if (member == null) {
                        member = new Member();
                        member.removeAttributeValue();
                        member.setUsername(userName);
                        member.setPassword(PassWordUtil.generatePwd());
                        member.setMobile(userName);
                        member.setPoint(0L);  //注册送积分由用户注册事件产生
                        member.setBalance(BigDecimal.ZERO);   //余额
                        member.setAmount(BigDecimal.ZERO);    //总金额
                        member.setIsEnabled(true);
                        member.setIsLocked(false);
                        member.setLockDate(null);
                        member.setLastLoginDate(new Date());
                        member.setSafeKey(null);
                        member.setMemberRank(memberRankService.findDefault());
                        member.setCart(null);
                        member.setOrders(null);
                        member.setPaymentTransactions(null);
                        member.setMemberDepositLogs(null);
                        member.setCouponCodes(null);
                        member.setReceivers(null);
                        member.setReviews(null);
                        member.setConsultations(null);
                        member.setProductFavorites(null);
                        member.setProductNotifies(null);
                        member.setInMessages(null);
                        member.setOutMessages(null);
                        member.setSocialUsers(null);
                        member.setPointLogs(null);
                        userService.register(member);
                    }
                    if(userPoint > 0){
                        member.setOrderNo(orderid);
                        memberService.addPoint(member, userPoint, PointLog.Type.other, "它类积分转入");
                    }
                    return "000000&SUCCESS";
                }
            });

        }catch (Exception e){
            System.out.println(mobile +"用户赠送积分发生错误！"+e.getMessage());
            ret="-10000&Insert into database failed";
        }
        }else{
            ret = "User point Repeat submit orderNo="+orderNo;
        }
        return ret;
    }
    @ResponseBody
    @PostMapping("/userBalance")
    public String userBalance(String orderNo, String mobile, BigDecimal amount){
        String ret="";
        if(!memberDepositLogService.exists(orderNo)){
            Retryer<String> retryer = RetryerBuilder.<String>newBuilder()
                    .retryIfException()
                    .withWaitStrategy(WaitStrategies.fixedWait(500, TimeUnit.MILLISECONDS))
                    .withStopStrategy(StopStrategies.stopAfterAttempt(5))
                    .build();
            final String userName = mobile;
            final BigDecimal bamount =amount;
            final String orderid=orderNo;
            try {
                ret= retryer.call(new Callable<String>() {
                    @Override
                    public String call() throws Exception {
                        Member member = memberService.findByUsername(userName);
                        if (member == null) {
                            member = new Member();
                            member.removeAttributeValue();
                            member.setUsername(userName);
                            member.setPassword(PassWordUtil.generatePwd());
                            member.setMobile(userName);
                            member.setPoint(0L);  //注册送积分由用户注册事件产生
                            member.setBalance(BigDecimal.ZERO);   //余额
                            member.setAmount(BigDecimal.ZERO);    //总金额
                            member.setIsEnabled(true);
                            member.setIsLocked(false);
                            member.setLockDate(null);
                            //member.setLastLoginIp(address);
                            member.setLastLoginDate(new Date());
                            member.setSafeKey(null);
                            member.setMemberRank(memberRankService.findDefault());
                            member.setCart(null);
                            member.setOrders(null);
                            member.setPaymentTransactions(null);
                            member.setMemberDepositLogs(null);
                            member.setCouponCodes(null);
                            member.setReceivers(null);
                            member.setReviews(null);
                            member.setConsultations(null);
                            member.setProductFavorites(null);
                            member.setProductNotifies(null);
                            member.setInMessages(null);
                            member.setOutMessages(null);
                            member.setSocialUsers(null);
                            member.setPointLogs(null);
                            userService.register(member);
                        }
                          memberService.addBalance(member,bamount,MemberDepositLog.Type.recharge,orderid);
                         return "000000&SUCCESS";
                    }
                });

            }catch (Exception e){
                System.out.println(mobile +"用户预存款发生错误！"+e.getMessage());
                ret="-10000&Insert into database failed";
            }
        }else{
            ret = "User balance Repeat submit orderNo="+orderNo;
        }
        return ret;
    }


}
