package net.shopxx.controller.member;

import net.shopxx.component.PcWeiXinComponent;
import net.shopxx.entity.Member;
import net.shopxx.entity.PluginConfig;
import net.shopxx.entity.SocialUser;
import net.shopxx.entity.User;
import net.shopxx.security.UserAuthenticationToken;
import net.shopxx.service.*;
import net.shopxx.util.*;
import net.shopxx.weixin.config.WxMpConfig;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.oltu.oauth2.client.OAuthClient;
import org.apache.oltu.oauth2.client.URLConnectionClient;
import org.apache.oltu.oauth2.client.request.OAuthClientRequest;
import org.apache.oltu.oauth2.client.response.OAuthJSONAccessTokenResponse;
import org.apache.oltu.oauth2.common.OAuth;
import org.apache.oltu.oauth2.common.exception.OAuthProblemException;
import org.apache.oltu.oauth2.common.exception.OAuthSystemException;
import org.apache.oltu.oauth2.common.message.types.GrantType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

@Controller("weiXinLoginController")
@RequestMapping("/member/login")
public class WeiXinLoginController extends BaseController {
    /**
     * code请求URL
     */
    private static final String WX_CODE_REQUEST_URL = "https://open.weixin.qq.com/connect/oauth2/authorize";

    /**
     * openId请求URL
     */
    private static final String WX_OPEN_ID_REQUEST_URL = "https://api.weixin.qq.com/sns/oauth2/access_token";

    /**
     * 用户信息请求URL
     * @return
     */
    private static final String WX_USER_INFO_REQUEST_URL = "https://api.weixin.qq.com/sns/userinfo";
    @Inject
    private PluginConfigService pluginConfigService;
    @Inject
    private SocialUserService socialUserService;

    @Inject
    private PcWeiXinComponent pcWeiXinComponent;

    @Inject
    private MemberService memberService;

    @Inject
    private UserService userService;

    @Inject
    private WxMpConfig wxMpConfig;

    @Inject
    private MemberRankService memberRankService;

    @RequestMapping("/wxpreSignIn")
    public ModelAndView wxpreSignIn(@RequestParam(value = "shareCode",defaultValue="empty") String shareCode,ModelAndView modelAndView) throws Exception {
        String url= SystemUtils.getSetting().getSiteUrl()+ "/member/login/wxPostLogin/"+shareCode;
        modelAndView.setViewName("redirect:"+WX_CODE_REQUEST_URL+"?appid="+wxMpConfig.getAppid()+"&redirect_uri="+ URLEncoder.encode(url,"UTF-8")+"&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect");
        return modelAndView;
    }

    @GetMapping("/wxPostLogin/{shareCode}")
    public ModelAndView wxPostLogin(@PathVariable(value = "shareCode") String shareCode,HttpServletRequest request, HttpServletResponse response,ModelAndView modelAndView){
        String code = request.getParameter("code");
        if (StringUtils.isEmpty(code)) {
            modelAndView.setViewName(UNPROCESSABLE_ENTITY_VIEW);
            return modelAndView;
        }
        try {
            OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());
            OAuthClientRequest.TokenRequestBuilder tokenRequestBuilder = OAuthClientRequest.tokenLocation(WX_OPEN_ID_REQUEST_URL);
            tokenRequestBuilder.setParameter("appid", wxMpConfig.getAppid());
            tokenRequestBuilder.setParameter("secret",  wxMpConfig.getAppsecret());
            tokenRequestBuilder.setCode(code);
            tokenRequestBuilder.setGrantType(GrantType.AUTHORIZATION_CODE);
            OAuthClientRequest accessTokenRequest = tokenRequestBuilder.buildQueryMessage();
            OAuthJSONAccessTokenResponse authJSONAccessTokenResponse = oAuthClient.accessToken(accessTokenRequest, OAuth.HttpMethod.GET);
            String openId = authJSONAccessTokenResponse.getParam("openid");
            String accessToken = authJSONAccessTokenResponse.getParam("access_token");
            //请求用户信息
            HttpClient httpClient =  HttpClients.createDefault();//创建httpClient对象
            HttpPost httpPost = new HttpPost(WX_USER_INFO_REQUEST_URL + "?access_token=" + accessToken + "&openid=" + openId);
            HttpResponse httpResponse = httpClient.execute(httpPost);
            String userInfo = "";
            if (httpResponse.getStatusLine().getStatusCode() == 200) {
                HttpEntity resEntity = httpResponse.getEntity();
                userInfo = EntityUtils.toString(resEntity, "utf-8");
            } else {
                System.out.println("请求失败");
            }
            Map<String,Object> param = JsonUtils.toObject(userInfo, Map.class);
            //获取头像
            String headImgUrl = MapGetter.getString(param,"headimgurl");
            //获取昵称
            String nickName = MapGetter.getString(param,"nickname");

            if(StringUtils.isNotEmpty(openId)){
                SocialUser socialUser = socialUserService.find("weixinLoginPlugin",openId);
                if(socialUser!=null){
                    User user = socialUser.getUser();
                    Member member=memberService.find(user.getId());
                    userService.login(new UserAuthenticationToken(Member.class, member.getUsername(), member.getEncodedPassword(), false, request.getRemoteAddr()));
                    modelAndView.setViewName("redirect:"+ request.getSession().getAttribute("redirectUrl"));
                }else{
                    modelAndView.setViewName("redirect:/member/login/wxBindMobile");
                    if(StringUtils.isNotEmpty(headImgUrl)){
                        modelAndView.addObject("headImgUrl",headImgUrl);
                        request.setAttribute("headImgUrl",headImgUrl);
                    }
                    if(!shareCode.equals("empty")){
                        modelAndView.addObject("shareCode",shareCode);
                        request.setAttribute("shareCode",shareCode);
                    }
                    if(StringUtils.isNotEmpty(nickName)){
                        modelAndView.addObject("nickName",nickName);
                        request.setAttribute("nickName",nickName);
                    }
                    modelAndView.addObject("openId",openId);
                     request.setAttribute("openId",openId);
                }
            }
        } catch (Exception e) {
            modelAndView.setViewName(UNPROCESSABLE_ENTITY_VIEW);
        }
        return modelAndView;
    }
}
