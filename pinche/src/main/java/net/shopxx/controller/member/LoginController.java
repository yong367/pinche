/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import net.shopxx.CacheConstant;
import net.shopxx.Results;
import net.shopxx.component.PcWeiXinComponent;
import net.shopxx.entity.Member;
import net.shopxx.entity.SocialUser;
import net.shopxx.security.CurrentUser;
import net.shopxx.security.UserAuthenticationToken;
import net.shopxx.service.*;
import net.shopxx.util.EmojiFilterUtil;
import net.shopxx.util.PassWordUtil;
import net.shopxx.util.WebUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.apache.shiro.web.util.SavedRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Controller - 会员登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberLoginController")
@RequestMapping("/member/login")
public class LoginController extends BaseController {

	/**
	 * "重定向令牌"Cookie名称
	 */
	private static final String REDIRECT_TOKEN_COOKIE_NAME = "redirectToken";

	@Value("${member_index}")
	private String memberIndex;
	@Value("${member_login_view}")
	private String memberLoginView;

	@Inject
	private PluginService pluginService;
	@Inject
	private SocialUserService socialUserService;

	@Inject
	private PcWeiXinComponent pcWeiXinComponent;

	@Inject
	private MemberService memberService;

	@Inject
	private MemberRankService memberRankService;

	@Inject
	private UserService userService;

	@Inject
	private ProductService productService;
	@Inject
	private ReviewService reviewService;

	/**
	 * 登录页面
	 */
	@GetMapping
	public String index(String redirectUrl, String redirectToken, Long socialUserId, String uniqueId, @CurrentUser Member currentUser, HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		if (StringUtils.isNotEmpty(redirectUrl) && StringUtils.isNotEmpty(redirectToken) && StringUtils.equals(redirectToken, WebUtils.getCookie(request, REDIRECT_TOKEN_COOKIE_NAME))) {
			model.addAttribute("redirectUrl", redirectUrl);
			request.getSession().setAttribute("redirectUrl", redirectUrl);
			WebUtils.removeCookie(request, response, REDIRECT_TOKEN_COOKIE_NAME);
		}
		//登录之后存入session
		SavedRequest savedRequest = org.apache.shiro.web.util.WebUtils.getSavedRequest(request);
		if (savedRequest != null && StringUtils.equalsIgnoreCase(savedRequest.getMethod(), AccessControlFilter.GET_METHOD)) {
			redirectUrl = savedRequest.getRequestUrl();
			request.getSession().setAttribute("redirectUrl", redirectUrl);
		}
		
		if (socialUserId != null && StringUtils.isNotEmpty(uniqueId)) {
			SocialUser socialUser = socialUserService.find(socialUserId);
			if (socialUser == null || socialUser.getUser() != null || !StringUtils.equals(socialUser.getUniqueId(), uniqueId)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			model.addAttribute("socialUserId", socialUserId);
			model.addAttribute("uniqueId", uniqueId);
		}
		model.addAttribute("loginPlugins", pluginService.getActiveLoginPlugins(request));
		if(wxSupports(request) && currentUser==null){
			if(	request.getSession().getAttribute("redirectUrl")==null){
				request.getSession().setAttribute("redirectUrl", memberIndex);
			}
			return "redirect:/member/login/wxpreSignIn?shareCode=empty";
		}
		return currentUser != null ? "redirect:" + memberIndex : memberLoginView;
	}

	private boolean wxSupports(HttpServletRequest request) {
		String userAgent = request.getHeader("USER-AGENT");
		return StringUtils.contains(userAgent.toLowerCase(), "micromessenger");
	}
	/*//微信登录
	@GetMapping("wxLogin")
	public String weixingLogin(ModelMap model) {
			String url=pcWeiXinComponent.getLoginQrcodeUrl();
			return "redirect:"+url;
	}*/

	//跳转到短信登录页面登录
	@GetMapping("goToSmsLogin")
	public String goToSmsLogin(ModelMap model,HttpServletRequest request) {
		return "member/login/smsLogin";
	}
	//跳转到短信登录页面登录
	@GetMapping("shareSmsLogin")
	public String shareSmsLogin(ModelMap model,@RequestParam(value = "shareCode",defaultValue="") String shareCode,HttpServletRequest request) {
		if(wxSupports(request)){
			request.getSession().setAttribute("redirectUrl","/member/index");
			return "redirect:/member/login/wxpreSignIn?shareCode="+shareCode;
		}
		model.addAttribute("shareCode",shareCode);
		return "member/login/shareSmsLogin";
	}

	//跳转到微信绑定登录页面登录
	@GetMapping("bindMobile")
	public String weixingBindLogin(Long socialUserId, String uniqueId, String nickname, String headimgurl,ModelMap model) {
        if (socialUserId != null && StringUtils.isNotEmpty(uniqueId)) {
            SocialUser socialUser = socialUserService.find(socialUserId);
            if (socialUser == null || socialUser.getUser() != null || !StringUtils.equals(socialUser.getUniqueId(), uniqueId)) {
                return UNPROCESSABLE_ENTITY_VIEW;
            }
            model.addAttribute("socialUserId", socialUserId);
            model.addAttribute("uniqueId", uniqueId);
            model.addAttribute("nickName", nickname);
            model.addAttribute("headImgUrl", headimgurl);

        }
        return "member/login/bindMobile";
    }

    //跳转到微信绑定登录页面登录
    @GetMapping("wxBindMobile")
    public String wxBindMobile(ModelMap model, @RequestParam(value = "openId",defaultValue = "")String openId, @RequestParam(value = "shareCode",defaultValue = "") String shareCode,
							   @RequestParam(value = "nickName",defaultValue = "") String nickName,
							   @RequestParam(value = "headImgUrl",defaultValue = "") String headImgUrl,HttpServletRequest request) {
		if(StringUtils.isNotEmpty(shareCode)){
			model.addAttribute("shareCode", shareCode);
		}
		if(StringUtils.isNotEmpty(nickName)){
			model.addAttribute("nickName", nickName);
		}
		if(StringUtils.isNotEmpty(headImgUrl)){
			model.addAttribute("headImgUrl", headImgUrl);
		}
            model.addAttribute("openId", openId);

        return "member/login/wxBindMobile";
    }



    //通过微信快捷登录绑定手机用户
    @PostMapping("/saveWxLoginBindMobile")
    public ResponseEntity<?> saveWxLoginBindMobile(@RequestParam(value = "mobile") String mobile,
                                         ModelMap model,
                                         @RequestParam(value = "validateNo")String validateNo,
                                         @RequestParam(value = "shareCode",defaultValue = "") String shareCode,
                                         HttpServletRequest request,
                                         @RequestParam(value = "openId",defaultValue = "")String openId,
                                         @RequestParam(value = "nickName",defaultValue = "") String nickName,
                                         @RequestParam(value = "headImgUrl",defaultValue = "") String headImgUrl) {
        if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.lOGIN_KEY_PREFIX,mobile,validateNo)){
            return Results.unprocessableEntity("merber.register.validateNoError");
        }
        Member member = memberService.findByUsername(mobile);
        if(member==null){
            member = new Member();
            member.removeAttributeValue();
            member.setUsername(mobile);
            member.setPassword(PassWordUtil.generatePwd());
            member.setMobile(mobile);
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
            member.setProductFavorites(null);
            member.setProductNotifies(null);
            member.setInMessages(null);
            member.setOutMessages(null);
            member.setSocialUsers(null);
            member.setPointLogs(null);
            if (member.getImageUrl() == null) {
                member.setImageUrl(headImgUrl);
                if(StringUtils.isNotEmpty(nickName)){
                    member.setNickName(EmojiFilterUtil.filterEmoji(nickName));
                }

            }
            if(StringUtils.isNotEmpty(shareCode) && memberService.find("shareCode",shareCode.toUpperCase())!=null){
                member.setRecommendCode(shareCode.toUpperCase());
            }
            userService.register(member);
        }
        SocialUser socialUser = new SocialUser();
        socialUser.setLoginPluginId("weixinLoginPlugin");
        socialUser.setUniqueId(openId);
        socialUser.setUser(member);
        socialUserService.save(socialUser);

        userService.login(new UserAuthenticationToken(Member.class, mobile, member.getEncodedPassword(), false, request.getRemoteAddr()));
        //短信登录从session取出来登录后再移除掉
        String redirectUrl = request.getSession().getAttribute("redirectUrl") !=null?request.getSession().getAttribute("redirectUrl").toString():"";
        if(StringUtils.isNotEmpty(redirectUrl)){
            Map<String, String> data = new HashMap<>();
            data.put("redirectUrl", redirectUrl);
            request.getSession().removeAttribute("redirectUrl");
            return Results.ok(data);
        }else{
            return Results.ok("member.login.success");
        }
    }


	//短信登录
	@PostMapping("/smsLogin")
	public ResponseEntity<?> smsLogin(@RequestParam(value = "mobile") String mobile, 
									  ModelMap model, 
									  @RequestParam(value = "validateNo")String validateNo,
									  HttpServletRequest request,
									  @RequestParam(value = "socialUserId",defaultValue = "")Long socialUserId,
									  @RequestParam(value = "uniqueId",defaultValue = "") String uniqueId) {
		if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.lOGIN_KEY_PREFIX,mobile,validateNo)){
			return Results.unprocessableEntity("merber.register.validateNoError");
		}
		Member member =initMember("",mobile,request);
		userService.login(new UserAuthenticationToken(Member.class, mobile, member.getEncodedPassword(), false, request.getRemoteAddr()));
		return Results.ok("member.login.success");
	}

	//邀请注册短信登录
	@PostMapping("/saveShareSmsLogin")
	public ResponseEntity<?> saveShareSmsLogin(@RequestParam(value = "mobile") String mobile,
									  ModelMap model,
									  @RequestParam(value = "validateNo")String validateNo,HttpServletRequest request,
									  @RequestParam(value = "shareCode",defaultValue = "") String shareCode) {
		if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.lOGIN_KEY_PREFIX,mobile,validateNo)){
			return Results.unprocessableEntity("merber.register.validateNoError");
		}
		Member member = initMember(shareCode,mobile,request);
		userService.login(new UserAuthenticationToken(Member.class, mobile, member.getEncodedPassword(), false, request.getRemoteAddr()));
		return Results.ok("member.login.success");
	}


	private Member initMember(String shareCode,String mobile,HttpServletRequest request){
		Member member = memberService.findByUsername(mobile);
		if(member==null){
			member = new Member();
			member.removeAttributeValue();
			member.setUsername(mobile);
			member.setPassword(PassWordUtil.generatePwd());
			member.setMobile(mobile);
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
			member.setProductFavorites(null);
			member.setProductNotifies(null);
			member.setInMessages(null);
			member.setOutMessages(null);
			member.setSocialUsers(null);
			member.setPointLogs(null);
			if(StringUtils.isNotEmpty(shareCode) && memberService.find("shareCode",shareCode.toUpperCase())!=null){
				member.setRecommendCode(shareCode.toUpperCase());
			}
			userService.register(member);
		}else{
			if(StringUtils.isEmpty(member.getRecommendCode())){
				if(StringUtils.isNotEmpty(shareCode) && memberService.find("shareCode",shareCode.toUpperCase())!=null){
					member.setRecommendCode(shareCode.toUpperCase());
					memberService.update(member);
				}
			}
		}
		return member;
	}

    //通过微信登录
    @PostMapping("/bingWxLogin")
    public ResponseEntity<?> bingWxLogin(@RequestParam(value = "mobile") String mobile,
                                      ModelMap model,
                                      @RequestParam(value = "validateNo")String validateNo,
                                      @RequestParam(value = "shareCode",defaultValue = "") String shareCode,
                                      HttpServletRequest request,
                                      @RequestParam(value = "socialUserId",defaultValue = "")Long socialUserId,
                                      @RequestParam(value = "uniqueId",defaultValue = "") String uniqueId,
                                      @RequestParam(value = "nickName",defaultValue = "") String nickName,
                                      @RequestParam(value = "headImgUrl",defaultValue = "") String headImgUrl) {
        if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.lOGIN_KEY_PREFIX,mobile,validateNo)){
            return Results.unprocessableEntity("merber.register.validateNoError");
        }
        Member member = memberService.findByUsername(mobile);
        if(member==null){
            member = new Member();
            member.removeAttributeValue();
            member.setUsername(mobile);
            member.setPassword(PassWordUtil.generatePwd());
            member.setMobile(mobile);
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
            member.setProductFavorites(null);
            member.setProductNotifies(null);
            member.setInMessages(null);
            member.setOutMessages(null);
            member.setSocialUsers(null);
            member.setPointLogs(null);
            if (member.getImageUrl() == null) {
                member.setImageUrl(headImgUrl);
                if(StringUtils.isNotEmpty(nickName)){
					member.setNickName(EmojiFilterUtil.filterEmoji(nickName));
				}

            }
            if(StringUtils.isNotEmpty(shareCode) && memberService.find("shareCode",shareCode.toUpperCase())!=null){
                member.setRecommendCode(shareCode.toUpperCase());
            }
            userService.register(member);

        }

         memberService.update(member);
        userService.login(new UserAuthenticationToken(Member.class, mobile, member.getEncodedPassword(), false, request.getRemoteAddr()));
        //短信登录从session取出来登录后再移除掉
        String redirectUrl = request.getSession().getAttribute("redirectUrl") !=null?request.getSession().getAttribute("redirectUrl").toString():"";
        if(StringUtils.isNotEmpty(redirectUrl)){
            Map<String, String> data = new HashMap<>();
            data.put("redirectUrl", redirectUrl);
            request.getSession().removeAttribute("redirectUrl");
            return Results.ok(data);
        }else{
            return Results.ok("member.login.success");
        }
    }

    /**
     * 验证绑定手机
     * @param mobile
     * @return
     */
    @PostMapping("/checkWxBindMobile")
    public @ResponseBody
    Object checkWxBindMobile(@RequestParam("mobile") String mobile,@RequestParam("uniqueId") String uniqueid) {
        Map<String,String> ret = new HashMap<>();
        Member member = memberService.findByUsername(mobile);
        String status = "success";
        if (member != null) {
            Set<SocialUser> set = member.getSocialUsers();
            if (set != null && set.size() > 0) {
                for (SocialUser socialUser : set) {
                    if (!uniqueid.equals(socialUser.getUniqueId())) {
                        status = "error";
                    }
                }
            }
        }
        ret.put("status",status);
        return ret;
    }
	/*
	* 发送登录验证码
	* */
	@GetMapping("/sendLoginValidateNo/{mobile}")
	public @ResponseBody
	Object sendValidateNo(@PathVariable("mobile") String mobile) {
		Map<String,String> ret = new HashMap<>();
		sendValidateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.lOGIN_KEY_PREFIX,mobile,ret);
		return ret;
	}
	/**
	 * 跳转协议
	 *
	 * @Author zhangmengfei
	 * @Date 2019-9-20 - 17:35
	 */
	@GetMapping("/agreement")
	public String agreement(String agreementType) {
		return "member/login/"+agreementType;
	}

    @RequestMapping("/changeMobile")
    public ResponseEntity<?> changeMobile(String oldMobile,String newMobile,String validateNo){
	    Map<String,Object> map=new HashMap<>();
        if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.lOGIN_KEY_PREFIX,newMobile,validateNo)){
            return Results.unprocessableEntity("merber.register.validateNoError");
        }
        Member member = memberService.findByUsername(oldMobile);
        member.setMobile(newMobile);
        memberService.update(member);
        return ResponseEntity.ok(map);
    }

}