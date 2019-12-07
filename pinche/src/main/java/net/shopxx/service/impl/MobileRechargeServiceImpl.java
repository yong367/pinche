package net.shopxx.service.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.component.MobileRechargeCompoment;
import net.shopxx.dao.MobileRechargeDao;
import net.shopxx.dao.SnDao;
import net.shopxx.entity.*;
import net.shopxx.service.MemberService;
import net.shopxx.service.MobileRechargeService;
import net.shopxx.service.PaymentMethodService;
import net.shopxx.service.PaymentTransactionService;
import net.shopxx.util.DateCollect;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.Date;

@Service
public class MobileRechargeServiceImpl extends BaseServiceImpl<MobileRechargeLog, Long> implements MobileRechargeService {
    @Inject
    private MobileRechargeDao mobileRechargeDao;
    @Inject
    private SnDao snDao;
    @Inject
    private PaymentTransactionService paymentTransactionService;
    @Inject
    private MemberService memberService;
    @Inject
    private MobileRechargeCompoment mobileRechargeCompoment;

    @Override
    @Transactional
    public MobileRechargeLog mobileRecharge(String mobile, int amount, Member member) {
        PaymentTransaction paymentTransaction = new PaymentTransaction();
        paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
        paymentTransaction.setType(PaymentTransaction.Type.ORDER_PAYMENT);
        paymentTransaction.setAmount(new BigDecimal(amount));
        paymentTransaction.setFee(BigDecimal.ZERO);
        paymentTransaction.setIsSuccess(false);
        paymentTransaction.setParent(null);
        paymentTransaction.setChildren(null);
        paymentTransaction.setUser(member);
        paymentTransactionService.save(paymentTransaction);
        MobileRechargeLog mobileRechargeLog=new MobileRechargeLog();
        mobileRechargeLog.setMember(member);
        mobileRechargeLog.setSn(paymentTransaction.getSn());
        mobileRechargeLog.setMobile(mobile);
        mobileRechargeLog.setAmount(amount);
        mobileRechargeLog.setCreatedDate(new Date());
        mobileRechargeLog.setRechargeDate(DateCollect.getYMDMMNumber(new Date()));
        mobileRechargeLog= mobileRechargeCompoment.mobileRecharge(mobileRechargeLog,member,mobile,String.valueOf(amount));
        mobileRechargeDao.persist(mobileRechargeLog);
         if(mobileRechargeLog.getRechargeStatus().equals(MobileRechargeLog.Status.pendingProcess)){
             memberService.addBalance(member,paymentTransaction.getAmount().negate(),MemberDepositLog.Type.orderPayment,"话费充值");
        }
       /* if(mobileRechargeLog.getRechargeStatus().equals(MobileRechargeLog.Status.completed)){
            paymentTransaction.setIsSuccess(true);
            paymentTransactionService.update(paymentTransaction);
        }*/
        return mobileRechargeLog;
    }

    @Override
    @Transactional
    public void mobileQueryRecharge(MobileRechargeLog mobileRechargeLog) {
        MobileRechargeLog.Status oldStatus = mobileRechargeLog.getRechargeStatus();
        mobileRechargeLog= mobileRechargeCompoment.queryMobileRechargeStatus(mobileRechargeLog);
        update(mobileRechargeLog);
        synchronized (mobileRechargeLog.getSn().intern()) {
            if (oldStatus.equals(MobileRechargeLog.Status.pendingProcess) && mobileRechargeLog.getRechargeStatus().equals(MobileRechargeLog.Status.failed)) {
                memberService.addBalance(mobileRechargeLog.getMember(), new BigDecimal(mobileRechargeLog.getAmount()), MemberDepositLog.Type.orderPayment, "话费充值退款");
            }
        }
    }

//    @Override
//    public Page<MobileRechargeLog> findPage(Member currentUser, Pageable pageable,String mobile,String rechargeMonth) {
//        return mobileRechargeDao.findPage(currentUser,pageable,mobile,rechargeMonth);
//    }
    @Override
    public Page<MobileRechargeLog> findPage(Member currentUser, Pageable pageable) {
        return mobileRechargeDao.findPage(currentUser,pageable);
    }

    /**
     * 累计充值金额
     * @param currentUser
     * @return
     */
    @Override
    public Integer countRecharge(Member currentUser,String rechargeMonth) {
        return mobileRechargeDao.countRecharge(currentUser,rechargeMonth);
    }

    @Override
    public MobileRechargeLog prizemobileRecharge(String mobile, Integer amount, Member member) {
        PaymentTransaction paymentTransaction = new PaymentTransaction();
        paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
        paymentTransaction.setType(PaymentTransaction.Type.ORDER_PAYMENT);
        paymentTransaction.setAmount(new BigDecimal(amount));
        paymentTransaction.setFee(BigDecimal.ZERO);
        paymentTransaction.setIsSuccess(false);
        paymentTransaction.setParent(null);
        paymentTransaction.setChildren(null);
        paymentTransaction.setUser(member);
        paymentTransactionService.save(paymentTransaction);
        MobileRechargeLog mobileRechargeLog=new MobileRechargeLog();
        mobileRechargeLog.setMember(member);
        mobileRechargeLog.setSn(paymentTransaction.getSn());
        mobileRechargeLog.setMobile(mobile);
        mobileRechargeLog.setAmount(amount);
        mobileRechargeLog.setCreatedDate(new Date());
        mobileRechargeLog.setRechargeDate(DateCollect.getYMDMMNumber(new Date()));
        mobileRechargeLog= mobileRechargeCompoment.mobileRecharge(mobileRechargeLog,member,mobile,String.valueOf(amount));
        mobileRechargeDao.persist(mobileRechargeLog);
        return mobileRechargeLog;
    }
}
