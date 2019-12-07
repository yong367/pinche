/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import com.fasterxml.jackson.annotation.JsonView;
import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberRank;
import net.shopxx.entity.PointLog;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.MemberService;
import net.shopxx.service.PointLogService;
import net.shopxx.util.ResponseData;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.time.LocalDate;
import java.util.*;

/**
 * Controller - 我的积分
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberPointLogController")
@RequestMapping("/member/point_log")
public class PointLogController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private PointLogService pointLogService;

	@Inject
	private MemberService memberService;

	@Inject
	private MemberRankService memberRankService;


	/**
	 * 积分兑换会员首页
	 */
	@GetMapping("/exchangeIndex")
	public String exchangeIndex(@CurrentUser Member currentUser, ModelMap model) {
		List<MemberRank> list=memberRankService.findAll();
		Collections.sort(list, new Comparator<MemberRank>() {
			@Override
			public int compare(MemberRank o1, MemberRank o2) {
				if(o1.getPoint()<o2.getPoint()){
					return -1;
				}
				if(o1.getPoint()>o2.getPoint()){
					return 1;
				}
				return 0;
			}
		});
		MemberRank memberRank = currentUser.getMemberRank();
		String imageUrl = currentUser.getImageUrl();
		String name = memberRank.getName();
		model.addAttribute("imageUrl",imageUrl);
		model.addAttribute("memberRankName",name);
		model.addAttribute("currentPoint", currentUser.getPoint());
		model.addAttribute("memberLevelList", list);
		return "member/point_log/exchangeIndex";
	}

	/**
	 * 积分兑换会员
	 */
	@PostMapping("/completePointExchange")
	@ResponseBody
	public Object completePointExchange(@CurrentUser Member currentUser,Long memberRankId) {
		Map<String,String> result=new HashMap<>();
		String status="y";
		String msg="兑换成功！";
		MemberRank newMemberRank=memberRankService.find(memberRankId);
		if(null !=newMemberRank){
			if(newMemberRank.getId().compareTo(currentUser.getMemberRank().getId())<=0){
				status="n";
				msg="兑换会员失败！请兑换大于当前等级！";
			}else{
				if(currentUser.getPoint().compareTo(newMemberRank.getPoint())>0){
					try{
						memberService.exchangeMemberLevel(currentUser,newMemberRank);
					}catch (Exception e){
						status="n";
						msg="系统繁忙请重试！";
					}

				}else{
					status="n";
					msg="兑换会员失败！积分剩余不足！";
				}
			}
		}else{
			status="n";
			msg="提交参数异常！";
		}

		result.put("status",status);
		result.put("msg",msg);
		return result;
	}


	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", pointLogService.findPage(currentUser, pageable));
		model.addAttribute("currentPoint", currentUser.getPoint());
		return "member/point_log/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(pointLogService.findPage(currentUser, pageable).getContent());
	}

	/**
	 * 赠送积分
	 * @param currentUser
	 * @param model
	 * @return
	 */
	@GetMapping("/presentation")
	public String presentation(@CurrentUser Member currentUser, ModelMap model) {
		model.addAttribute("currentPoint", currentUser.getPoint());
		return "member/point_log/presentation";
	}

	@PostMapping("/savePresentation")
	public ResponseEntity<?> savePresentation(@CurrentUser Member currentUser,String receiveMobile,long pointNum) {

		if(currentUser.getUsername().equals(receiveMobile)){
			return Results.error("请输入对方账号！");
		}

		if(pointNum <= 0){
			return Results.error("积分必须是大于0的整数！");
		}
		if(currentUser.getPoint() == null || currentUser.getPoint().longValue() < pointNum){
			return Results.error("对不起！积分不足无法完成此次交易。");
		}
		Member riceiveMember = memberService.findByUsername(receiveMobile);
		if (riceiveMember == null) {
			return Results.error("该用户不存在！");
		}
		memberService.presentationPoint(currentUser,riceiveMember,pointNum);
		return ResponseEntity.ok("转赠积分成功");
	}

	@ResponseBody
	@PostMapping("/signIn")
	public ResponseData signIn(@CurrentUser Member currentUser){
		ResponseData responseData=new ResponseData();
		int signInLastTime = currentUser.getSignInLastTime();
		LocalDate localDate = LocalDate.now();
		String currentTime = localDate.getYear() + "" + localDate.getMonthValue() + "" + localDate.getDayOfMonth();
		int currentTimeInt = Integer.parseInt(currentTime);
		if(!(signInLastTime<currentTimeInt)){
			responseData.setCode(0);
			responseData.setMessage("当日已签到");
			return responseData;
		}
        responseData.setMessage("签到成功");
		memberService.addPoint(currentUser,70L, PointLog.Type.signin,"签到送积分");
		currentUser.setSignInLastTime(currentTimeInt);
		memberService.update(currentUser);
		return responseData;
	}
}