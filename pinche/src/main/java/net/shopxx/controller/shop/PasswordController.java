/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;

import net.shopxx.CacheConstant;
import net.shopxx.service.*;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import net.shopxx.Message;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Business;
import net.shopxx.entity.Member;
import net.shopxx.entity.SafeKey;
import net.shopxx.entity.User;
import net.shopxx.entity.User.PasswordType;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 密码
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopPasswordController")
@RequestMapping("/password")
public class PasswordController extends BaseController {

	@Inject
	private BusinessService businessService;
	@Inject
	private MemberService memberService;
	@Inject
	private MailService mailService;


	/**
	 * 忘记密码
	 */
	@GetMapping("/forgot")
	public String forgot(PasswordType type, Model model) {
		model.addAttribute("type", type);
		return "shop/password/forgot";
	}

	/**
	 * 会员忘记密码
	 */
	@PostMapping(path = "/forgot", params = "type=member")
	public ResponseEntity<?> forgotMember(String username, String validateNo) {
		if (StringUtils.isEmpty(username) || StringUtils.isEmpty(validateNo)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Member member = memberService.findByUsername(username);
		if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.FIND_USER_PASSWORD,username,validateNo)){
			return Results.unprocessableEntity("merber.register.validateNoError");
		}
		Map<String,String> result = new HashMap<>();
		//需要跳转到修改密码的页面。备注需要修改
		Setting setting = SystemUtils.getSetting();
		SafeKey safeKey = new SafeKey();
		safeKey.setValue(DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
		safeKey.setExpire(setting.getSafeKeyExpiryTime() != 0 ? DateUtils.addMinutes(new Date(), setting.getSafeKeyExpiryTime()) : null);
		member.setSafeKey(safeKey);
		memberService.update(member);
		result.put("username",username);
		result.put("safeKey",safeKey.getValue());
		result.put("type","member");
//		mailService.sendForgotPasswordMail(member); 不需要发送邮件
		return Results.ok(result);
	}

	/*
* 发送找回密码验证码
* */
	@GetMapping("/forgot/sendValidateNo/{mobile}")
	public @ResponseBody
	Object sendValidateNo(@PathVariable("mobile") String mobile) {
		Map<String,String> ret = new HashMap<>();
		if(memberService.usernameExists(mobile)){
			sendValidateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.FIND_USER_PASSWORD,mobile,ret);
		}else{
			ret.put("status", "faild");
		}
		return ret;
	}


	/**
	 * 商家忘记密码
	 */
	@PostMapping(path = "/forgot", params = "type=business")
	public ResponseEntity<?> forgotBusiness(String username, String validateNo) {
		if (StringUtils.isEmpty(username) || StringUtils.isEmpty(validateNo)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Business business = businessService.findByUsername(username);
		if (business == null) {
			return Results.unprocessableEntity("shop.password.businessNotExist");
		}
		if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.FIND_USER_PASSWORD,username,validateNo)){
			return Results.unprocessableEntity("merber.register.validateNoError");
		}

		//需要跳转到修改密码的页面。备注需要修改
		Setting setting = SystemUtils.getSetting();
		SafeKey safeKey = new SafeKey();
		safeKey.setValue(DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
		safeKey.setExpire(setting.getSafeKeyExpiryTime() != 0 ? DateUtils.addMinutes(new Date(), setting.getSafeKeyExpiryTime()) : null);
		business.setSafeKey(safeKey);
		businessService.update(business);
		mailService.sendForgotPasswordMail(business);
		return Results.ok("shop.password.mailSuccess");
	}

	/**
	 * 会员重置密码
	 */
	@GetMapping(path = "/reset", params = "type=member")
	public String resetMember(String username, String key, Model model) {
		if (StringUtils.isEmpty(username) || StringUtils.isEmpty(key)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Member member = memberService.findByUsername(username);
		if (member == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		SafeKey safeKey = member.getSafeKey();
		if (safeKey == null || safeKey.getValue() == null || !StringUtils.equals(safeKey.getValue(), key)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (safeKey.hasExpired()) {
			model.addAttribute("errorMessage", Message.warn("shop.password.hasExpired"));
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("user", member);
		model.addAttribute("type", User.PasswordType.member);
		model.addAttribute("key", key);
		return "shop/password/reset";
	}

	/**
	 * 商家重置密码
	 */
	@GetMapping(path = "/reset", params = "type=business")
	public String resetBusiness(String username, String key, Model model) {
		if (StringUtils.isEmpty(username) || StringUtils.isEmpty(key)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Business business = businessService.findByUsername(username);
		if (business == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		SafeKey safeKey = business.getSafeKey();
		if (safeKey == null || safeKey.getValue() == null || !StringUtils.equals(safeKey.getValue(), key)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (safeKey.hasExpired()) {
			model.addAttribute("errorMessage", Message.warn("shop.password.hasExpired"));
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("user", business);
		model.addAttribute("type", User.PasswordType.business);
		model.addAttribute("key", key);
		return "shop/password/reset";
	}

	/**
	 * 会员重置密码
	 */
	@PostMapping(path = "/reset", params = "type=member")
	public ResponseEntity<?> resetMember(String username, String newPassword, String key) {
		if (StringUtils.isEmpty(username) || StringUtils.isEmpty(newPassword) || StringUtils.isEmpty(key)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Member member = memberService.findByUsername(username);
		if (member == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!isValid(Member.class, "password", newPassword, BaseEntity.Save.class)) {
			return Results.unprocessableEntity("shop.password.invalidPassword");
		}
		SafeKey safeKey = member.getSafeKey();
		if (safeKey == null || safeKey.getValue() == null || !StringUtils.equals(safeKey.getValue(), key)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (safeKey.hasExpired()) {
			return Results.unprocessableEntity("shop.password.hasExpired");
		}
		member.setPassword(newPassword);
		member.setSafeKey(null);
		memberService.update(member);
		return Results.ok("shop.password.resetSuccess");
	}

	/**
	 * 商家重置密码
	 */
	@PostMapping(path = "/reset", params = "type=business")
	public ResponseEntity<?> resetBusiness(String username, String newPassword, String key) {
		if (StringUtils.isEmpty(username) || StringUtils.isEmpty(newPassword) || StringUtils.isEmpty(key)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Business business = businessService.findByUsername(username);
		if (business == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!isValid(Business.class, "password", newPassword, BaseEntity.Save.class)) {
			return Results.unprocessableEntity("shop.password.invalidPassword");
		}
		SafeKey safeKey = business.getSafeKey();
		if (safeKey == null || safeKey.getValue() == null || !StringUtils.equals(safeKey.getValue(), key)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (safeKey.hasExpired()) {
			return Results.unprocessableEntity("shop.password.hasExpired");
		}
		business.setPassword(newPassword);
		business.setSafeKey(null);
		businessService.update(business);
		return Results.ok("shop.password.resetSuccess");
	}

}