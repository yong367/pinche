/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import net.shopxx.CacheConstant;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.entity.SocialUser;
import net.shopxx.security.UserAuthenticationToken;
import net.shopxx.service.*;
import net.shopxx.util.SystemUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller - 会员注册
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberRegisterController")
@RequestMapping("/member/register")
public class RegisterController extends BaseController {

	@Inject
	private UserService userService;
	@Inject
	private MemberService memberService;
	@Inject
	private MemberRankService memberRankService;
	@Inject
	private MemberAttributeService memberAttributeService;
	@Inject
	private SocialUserService socialUserService;


	/*
	* 发送注册验证码
	* */
	@GetMapping("/sendValidateNo/{mobile}")
	public @ResponseBody Object sendValidateNo(@PathVariable("mobile") String mobile) {
		Map<String,String> ret = new HashMap<>();
		sendValidateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.REGISTER_KEY_PREFIX,mobile,ret);
		return ret;
	}

	/**
	 * 检查用户名是否存在
	 */
	@GetMapping("/check_username")
	public @ResponseBody boolean checkUsername(String username) {
		return StringUtils.isNotEmpty(username) && !memberService.usernameExists(username);
	}

	/**
	 * 检查E-mail是否存在
	 */
	@GetMapping("/check_email")
	public @ResponseBody boolean checkEmail(String email) {
		return StringUtils.isNotEmpty(email) && !memberService.emailExists(email);
	}

	/**
	 * 检查手机是否存在
	 */
	@GetMapping("/check_mobile")
	public @ResponseBody boolean checkMobile(String mobile) {
		return StringUtils.isNotEmpty(mobile) && memberService.mobileExists(mobile);
	}

	/**
	 * 注册页面
	 */
	@GetMapping
	public String index(Long socialUserId, String uniqueId, ModelMap model) {
		if (socialUserId != null && StringUtils.isNotEmpty(uniqueId)) {
			SocialUser socialUser = socialUserService.find(socialUserId);
			if (socialUser == null || socialUser.getUser() != null || !StringUtils.equals(socialUser.getUniqueId(), uniqueId)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			model.addAttribute("socialUserId", socialUserId);
			model.addAttribute("uniqueId", uniqueId);
		}
		model.addAttribute("genders", Member.Gender.values());
		return "member/register/index";
	}


	/**
	 * 注册提交
	 */
	@PostMapping("/submit")
	public ResponseEntity<?> submit(String username, String password,Long socialUserId, String uniqueId, HttpServletRequest request,String validateNo,HttpSession session) {
		Setting setting = SystemUtils.getSetting();
		if (!ArrayUtils.contains(setting.getAllowedRegisterTypes(), Setting.RegisterType.member)) {
			return Results.unprocessableEntity("member.register.disabled");
		}
		if (!isValid(Member.class, "username", username, BaseEntity.Save.class) || !isValid(Member.class, "password", password, BaseEntity.Save.class)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (memberService.usernameExists(username)) {
			return Results.unprocessableEntity("member.register.usernameExist");
		}
		if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.REGISTER_KEY_PREFIX,username,validateNo)){
			return Results.unprocessableEntity("merber.register.validateNoError");
		}
		String recommendCode=request.getParameter("recommendCode");
		Member member = new Member();
		member.removeAttributeValue();
		member.setUsername(username);
		member.setPassword(password);
		member.setMobile(username);
		member.setNickName(username);//设置昵称为手机号
		member.setPoint(0L);  //注册送积分由用户注册事件产生
		member.setBalance(BigDecimal.ZERO);   //余额
		member.setAmount(BigDecimal.ZERO);    //总金额
		member.setIsEnabled(true);
		member.setIsLocked(false);
		member.setLockDate(null);
		member.setLastLoginIp(request.getRemoteAddr());
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
		if(StringUtils.isNotEmpty(recommendCode) && memberService.find("shareCode",recommendCode.toUpperCase())!=null){
			member.setRecommendCode(recommendCode.toUpperCase());
		}
		member.setProductFavorites(null);
		member.setProductNotifies(null);
		member.setInMessages(null);
		member.setOutMessages(null);
		member.setSocialUsers(null);
		member.setPointLogs(null);
		userService.register(member);
		userService.login(new UserAuthenticationToken(Member.class, username, member.getEncodedPassword(), false, request.getRemoteAddr()));
		return Results.ok("member.register.success");
	}

}