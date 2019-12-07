package net.shopxx.controller.member;

import me.chanjar.weixin.mp.api.WxMpService;
import me.chanjar.weixin.mp.bean.result.WxMpOAuth2AccessToken;
import net.shopxx.Setting;
import net.shopxx.entity.Member;
import net.shopxx.entity.SocialUser;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.*;
import net.shopxx.util.SystemUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller("bindWxController")
public class BindWxController extends BaseController {

    @Inject
    private WxMpService wxService;

    @Inject
    private MemberService memberService;

    @Inject
    private LogPrintService logPrintService;

    @Inject
    private SocialUserService socialUserService;

    /**
     *
     * @return
     */
    @GetMapping("/member/bind/preBindWx")
    public ModelAndView preBindWx(@CurrentUser Member currentUser){
        Setting setting = SystemUtils.getSetting();
        String redirect_uri =wxService.oauth2buildAuthorizationUrl(setting.getSiteUrl()+"/postBindWx/"+ currentUser.getId(),"snsapi_base","STATUS");
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("redirect:"+redirect_uri);
        return modelAndView;
    }

    @RequestMapping("/postBindWx/{memberId}")
    public String postBindWx(@PathVariable Long memberId, HttpServletRequest request,RedirectAttributes redirectAttributes){
        String message="绑定成功！";
        String wxcode = request.getParameter("code");
        String userOpenid="";
        try{
            WxMpOAuth2AccessToken wxMpOAuth2AccessToken= wxService.oauth2getAccessToken(wxcode);
             userOpenid = wxMpOAuth2AccessToken.getOpenId();
            Member member = memberService.find(memberId);
            String logPluginId = "weixinLoginPlugin";
            if(member != null){
                SocialUser socialUser = socialUserService.find(logPluginId, userOpenid);
                if(socialUser != null){
                    if(socialUser.getUser() == null){
                        socialUser.setUser(member);
                        socialUserService.update(socialUser);
                    }else{
                        message = "当前微信以绑定其他账号，请解除绑定后在重试。";
                    }

                }else{
                    socialUser = new SocialUser();
                    socialUser.setLoginPluginId(logPluginId);
                    socialUser.setUniqueId(userOpenid);
                    socialUser.setUser(member);
                    socialUserService.save(socialUser);
                }
            }else{
                message = "当前用户不存在！";
            }

        }catch (Exception e){
            message = "绑定失败请重试！";
        }
        System.out.println("微信快速绑定---------------------------------------");
        logPrintService.printServerLog(userOpenid+"快速绑定微信，信息："+message);
        addFlashMsg(redirectAttributes, message);
        return "redirect:/member/social_user/list";
    }


}
