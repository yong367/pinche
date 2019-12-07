package net.shopxx.util;

import net.shopxx.entity.Member;
import net.shopxx.entity.User;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.MemberService;
import net.shopxx.service.UserService;
import net.shopxx.service.impl.MemberRankServiceImpl;
import net.shopxx.service.impl.MemberServiceImpl;
import net.shopxx.service.impl.UserServiceImpl;
import net.shopxx.util.PassWordUtil;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import java.math.BigDecimal;
import java.util.Date;

public class WorkThread implements Runnable {
    private UserService userService;
    private MemberService memberService;
    private MemberRankService memberRankService;

    private String mobile;
    private Date data;

    public WorkThread(String mobile,Date data,UserService userService,MemberService memberService,MemberRankService memberRankService){
        this.mobile = mobile;
        this.data =data;
        this.userService=userService;
        this.memberService = memberService;
        this.memberRankService = memberRankService;
    }

    @Override
    public void run() {
        Member member = memberService.findByMobile(mobile);
        if(member==null){
            member = new Member();
            member.removeAttributeValue();
            member.setUsername(mobile);
            member.setPassword("135246");
            member.setMobile(mobile);
            member.setPoint(0L);  //注册送积分由用户注册事件产生
            member.setBalance(BigDecimal.ZERO);   //余额
            member.setAmount(BigDecimal.ZERO);    //总金额
            member.setIsEnabled(true);
            member.setIsLocked(false);
            member.setLockDate(null);
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
           /* member.setShareCode(memberService.generateShareCodeExists());*/
            member.setProductFavorites(null);
            member.setProductNotifies(null);
            member.setInMessages(null);
            member.setOutMessages(null);
            member.setSocialUsers(null);
            member.setPointLogs(null);
            member.setCreatedDate(data);
            userService.register(member);
//            memberService.updateCreateTime(member);
            System.out.println("保存数据完成---------------"+ mobile);
        }else{
            member.setCreatedDate(data);
            memberService.updateCreateTime(member);
            System.out.println("数据更新完成--------------------------------");
        }
    }

}
