/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.component.WeiXinManage;
import net.shopxx.dao.MemberDao;
import net.shopxx.dao.MemberDepositLogDao;
import net.shopxx.dao.MemberRankDao;
import net.shopxx.dao.PointLogDao;
import net.shopxx.entity.*;
import net.shopxx.service.MailService;
import net.shopxx.service.MemberService;
import net.shopxx.service.SmsService;
import net.shopxx.util.DateCollect;
import net.shopxx.weixin.template.message.BalanceChangeNotifyMessage;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.persistence.LockModeType;
import javax.sql.DataSource;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Service - 会员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class MemberServiceImpl extends BaseServiceImpl<Member, Long> implements MemberService {

	@Inject
	private DataSource dataSource;
	protected JdbcTemplate jdbcTemplate;

	@PostConstruct
	private void afterConstruct() {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}

	/**
	 * E-mail身份配比
	 */
	private static final Pattern EMAIL_PRINCIPAL_PATTERN = Pattern.compile(".*@.*");

	/**
	 * 手机身份配比
	 */
	private static final Pattern MOBILE_PRINCIPAL_PATTERN = Pattern.compile("\\d+");

	@Inject
	private MemberDao memberDao;
	@Inject
	private MemberRankDao memberRankDao;
	@Inject
	private MemberDepositLogDao memberDepositLogDao;
	@Inject
	private PointLogDao pointLogDao;
	@Inject
	private MailService mailService;
	@Inject
	private SmsService smsService;
	@Inject
	private WeiXinManage weiXinManage;

	@Transactional(readOnly = true)
	public Member getUser(Object principal) {
		Assert.notNull(principal);
		Assert.isInstanceOf(String.class, principal);

		String value = (String) principal;
		if (EMAIL_PRINCIPAL_PATTERN.matcher(value).matches()) {
			return findByEmail(value);
		} else if (MOBILE_PRINCIPAL_PATTERN.matcher(value).matches()) {
			return findByMobile(value);
		} else {
			return findByUsername(value);
		}
	}

	@Transactional(readOnly = true)
	public Set<String> getPermissions(User user) {
		Assert.notNull(user);
		Assert.isInstanceOf(Member.class, user);

		return Member.PERMISSIONS;
	}

	@Transactional(readOnly = true)
	public boolean supports(Class<?> userClass) {
		return userClass != null && Member.class.isAssignableFrom(userClass);
	}

	@Transactional(readOnly = true)
	public boolean usernameExists(String username) {
		return memberDao.exists("username", StringUtils.lowerCase(username));
	}

	@Transactional(readOnly = true)
	public Member findByUsername(String username) {
		return memberDao.find("username", StringUtils.lowerCase(username));
	}

	@Transactional(readOnly = true)
	public boolean emailExists(String email) {
		return memberDao.exists("email", StringUtils.lowerCase(email));
	}

	@Transactional(readOnly = true)
	public boolean emailUnique(Long id, String email) {
		return memberDao.unique(id, "email", StringUtils.lowerCase(email));
	}

	@Transactional(readOnly = true)
	public Member findByEmail(String email) {
		return memberDao.find("email", StringUtils.lowerCase(email));
	}

	@Transactional(readOnly = true)
	public boolean mobileExists(String mobile) {
		return memberDao.exists("mobile", StringUtils.lowerCase(mobile));
	}

	@Transactional(readOnly = true)
	public boolean mobileUnique(Long id, String mobile) {
		return memberDao.unique(id, "mobile", StringUtils.lowerCase(mobile));
	}

	@Transactional(readOnly = true)
	public Member findByMobile(String mobile) {
		return memberDao.find("mobile", StringUtils.lowerCase(mobile));
	}

	@Transactional(readOnly = true)
	public Page<Member> findPage(Member.RankingType rankingType, Pageable pageable) {
		return memberDao.findPage(rankingType, pageable);
	}

	public void addBalance(Member member, BigDecimal amount, MemberDepositLog.Type type, String memo) {
		Assert.notNull(member);
		Assert.notNull(amount);
		Assert.notNull(type);

		if (amount.compareTo(BigDecimal.ZERO) == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(memberDao.getLockMode(member))) {
			memberDao.flush();
			memberDao.refresh(member, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(member.getBalance());
		Assert.state(member.getBalance().add(amount).compareTo(BigDecimal.ZERO) >= 0);

		member.setBalance(member.getBalance().add(amount));
		memberDao.flush();

		MemberDepositLog memberDepositLog = new MemberDepositLog();
		memberDepositLog.setType(type);
		memberDepositLog.setCredit(amount.compareTo(BigDecimal.ZERO) > 0 ? amount : BigDecimal.ZERO);
		memberDepositLog.setDebit(amount.compareTo(BigDecimal.ZERO) < 0 ? amount.abs() : BigDecimal.ZERO);
		memberDepositLog.setBalance(member.getBalance());
		memberDepositLog.setMemo(memo);
		memberDepositLog.setMember(member);
		memberDepositLogDao.persist(memberDepositLog);
		processUserBalanceChangeNotifyMessage(member,amount,type);
	}

	private void processUserBalanceChangeNotifyMessage(Member currentUser,BigDecimal amount,MemberDepositLog.Type type){
		if (currentUser.getSocialUsers().size() > 0 ) {
			Iterator<SocialUser> it = currentUser.getSocialUsers().iterator();
			while (it.hasNext()){
				SocialUser socialUser = it.next();
				if(socialUser.getLoginPluginId().equals("weixinLoginPlugin")){
					String userOpenID = socialUser.getUniqueId();
					BalanceChangeNotifyMessage balanceChangeNotifyMessage = new BalanceChangeNotifyMessage();
					balanceChangeNotifyMessage.setAmount(amount.compareTo(BigDecimal.ZERO) >0 ?"+"+String.valueOf(amount.abs().intValue()):"-"+String.valueOf(amount.abs().intValue()));
					balanceChangeNotifyMessage.setChangeType(processMemberDepositLogType(type));
					balanceChangeNotifyMessage.setBalance(String.valueOf(currentUser.getBalance().intValue()));
					balanceChangeNotifyMessage.setCreateTime(DateCollect.getDateStr(new Date(),DateCollect.SDF_VERSION1));
					balanceChangeNotifyMessage.setOpenId(userOpenID);
					weiXinManage.sendTemplateMessage(balanceChangeNotifyMessage);
				}
			}
		}
	}

	private String processMemberDepositLogType(MemberDepositLog.Type type){
		switch (type){
			case cashRefunds:return "提现失败退款";
			case recharge:return "预存款充值";
			case cash:return "兑伴儿提现";
			case orderRefunds:return "订单退款";
			case promotionReward:return "推广佣金奖励";
			case taskReward:return "任务佣金奖励";
			case orderPayment:return "订单支付";
			case adjustment:return "预存款调整";
			case jdBtlxReward:return "京东白条拉新奖励";
			default:return"";
		}
	}

	public void addPoint(Member member, long amount, PointLog.Type type, String memo) {
		Assert.notNull(member);
		Assert.notNull(type);

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(memberDao.getLockMode(member))) {
			memberDao.flush();
			memberDao.refresh(member, LockModeType.PESSIMISTIC_WRITE);
		}
		Assert.notNull(member.getPoint());
		Assert.state(member.getPoint() + amount >= 0);

		member.setPoint(member.getPoint() + amount);
		memberDao.flush();

		PointLog pointLog = new PointLog();
		pointLog.setType(type);
		pointLog.setCredit(amount > 0 ? amount : 0L);
		pointLog.setDebit(amount < 0 ? Math.abs(amount) : 0L);
		pointLog.setBalance(member.getPoint());
		pointLog.setMemo(memo);
		pointLog.setMember(member);
		pointLog.setOrderNo(member.getOrderNo());
		pointLogDao.persist(pointLog);
	}

	public void addAmount(Member member, BigDecimal amount) {
		Assert.notNull(member);
		Assert.notNull(amount);

		if (amount.compareTo(BigDecimal.ZERO) == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(memberDao.getLockMode(member))) {
			memberDao.flush();
			memberDao.refresh(member, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(member.getAmount());
		Assert.state(member.getAmount().add(amount).compareTo(BigDecimal.ZERO) >= 0);

		member.setAmount(member.getAmount().add(amount));
		MemberRank memberRank = member.getMemberRank();
		if (memberRank != null && BooleanUtils.isFalse(memberRank.getIsSpecial())) {
			MemberRank newMemberRank = memberRankDao.findByAmount(member.getAmount());
			if (newMemberRank != null && newMemberRank.getAmount() != null && newMemberRank.getAmount().compareTo(memberRank.getAmount()) > 0) {
				member.setMemberRank(newMemberRank);
			}
		}
		memberDao.flush();
	}

	@Override
	@Transactional
	public Member save(Member member) {
		Assert.notNull(member);

		Member pMember = super.save(member);
		mailService.sendRegisterMemberMail(pMember);
		smsService.sendRegisterMemberSms(pMember);
		return pMember;
	}

	@Override
	public void presentationPoint(Member currentUser, Member riceiveMember, long pointNum) {
				addPoint(riceiveMember,pointNum,PointLog.Type.personalTurn,processMobile(currentUser.getUsername())+"赠送");
				addPoint(currentUser,pointNum*(-1),PointLog.Type.personalTurn,"赠给"+processMobile(riceiveMember.getUsername()));
	}

	@Override
	public void updateCreateTime(Member member) {
		jdbcTemplate.update("update users set createdDate='"+DateCollect.getDateStr(member.getCreatedDate(),DateCollect.SDF_VERSION1)+"' where id="+member.getId());
	}

    /**
     * 根据邀请码查member
     * @param recommendCode
     * @return
     */
	@Override
	@Transactional(readOnly = true)
	public Member findByRecommendCode(String recommendCode) {
		return memberDao.find("shareCode", StringUtils.upperCase(recommendCode));
	}

	private String processMobile(String mobile){
		String startStr = mobile.substring(0,3);
		String endStr = mobile.substring(7,11);
		return startStr+"****"+endStr;
	}

	@Override
	@Transactional
	public void exchangeMemberLevel(Member member, MemberRank newMemberRank) {
		member.setMemberRank(newMemberRank);
		member.setPoint(member.getPoint()-newMemberRank.getPoint());
		update(member);
		PointLog pointLog = new PointLog();
		pointLog.setType(PointLog.Type.exchange);
		pointLog.setCredit(0L);
		pointLog.setDebit(newMemberRank.getPoint());
		pointLog.setBalance(member.getPoint());
		pointLog.setMemo("积分兑换"+newMemberRank.getName()+"会员等级");
		pointLog.setMember(member);
		pointLogDao.persist(pointLog);
	}

	@Override
	public void takePrizeDeduct(Member currentUser) {
		currentUser.setPoint(currentUser.getPoint()-70);
		this.update(currentUser);
	}
}