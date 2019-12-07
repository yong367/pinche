package net.shopxx.controller.member;

import net.shopxx.component.WeiXinManage;
import net.shopxx.entity.AppliCash;
import net.shopxx.entity.Member;
import net.shopxx.entity.SocialUser;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AppliCashService;
import net.shopxx.service.MemberService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.Iterator;

/**
 * 提现controller
 */
@Controller
@RequestMapping("/member/appliCash")
public class AppliCashController extends BaseController {
    @Inject
    private AppliCashService appliCashService;

    @Inject
    private WeiXinManage weiXinManage;
    @Autowired
    private MemberService memberService;
    /**
     * 选择提现方式
     */
    @GetMapping("/cash/cashApply")
    public String cash(@CurrentUser Member currentUser, ModelMap model) {
        boolean isAuth=currentUser.getAuthenticationStatus();
        if(!isAuth){
            return "redirect:/member/authentification/authentification";
        }
        model.addAttribute("openIdBindFlag", StringUtils.isNotEmpty(getCurrentUserOpenId(currentUser)));
        BigDecimal allAmount=new BigDecimal(5000);
        BigDecimal wxCashapplyCashAmount = appliCashService.findByApplyCashPluginTypeAndStatus(AppliCash.cashMethod.wxCash, currentUser);
        BigDecimal zfbCashapplyCashAmount = appliCashService.findByApplyCashPluginTypeAndStatus(AppliCash.cashMethod.alipayCash, currentUser);
        model.addAttribute("wxCashapplyCashAmount",allAmount.subtract(wxCashapplyCashAmount).intValue());
        model.addAttribute("zfbCashapplyCashAmount",allAmount.subtract(zfbCashapplyCashAmount).intValue());
        return "/member/cash/selectCashMethod";
    }

    private String getCurrentUserOpenId(Member currentUser){
        if (currentUser.getSocialUsers().size() > 0 ) {
            Iterator<SocialUser> it = currentUser.getSocialUsers().iterator();
            while (it.hasNext()){
                SocialUser socialUser = it.next();
                if(socialUser.getLoginPluginId().equals("weixinLoginPlugin")){
                    return socialUser.getUniqueId();
                }
            }
        }
        return "";
    }
    /**
     * 提现
     * @param currentUser
     * @param appliCash
     * @param model
     * @param redirectAttributes
     * @return
     * @throws Exception
     */
    @PostMapping("/saveCashApply")
    public String saveCashApply (@CurrentUser Member currentUser, AppliCash appliCash, ModelMap model, RedirectAttributes redirectAttributes) throws Exception {
        boolean isAuth=currentUser.getAuthenticationStatus();
        if(!isAuth){
            return "redirect:/member/authentification/authentification";
        }
        String msg="提现申请成功！";
        if (!isValid(appliCash)) {
            return UNPROCESSABLE_ENTITY_VIEW;
        }
        if (currentUser.getBalance().compareTo(appliCash.getAmount()) < 0) {
            return UNPROCESSABLE_ENTITY_VIEW;
        }

        BigDecimal applyCashAmount = appliCashService.findByApplyCashPluginTypeAndStatus(appliCash.getCashMethod(), currentUser);
        if (applyCashAmount.compareTo(BigDecimal.ZERO)>0) {
            if (applyCashAmount.add(appliCash.getAmount()).compareTo(new BigDecimal(5000)) > 0) {
                msg = "超过当天"+cashMethodName(appliCash)+"可提现金额！剩余可提现金额:"+new BigDecimal(5000).subtract(applyCashAmount).intValue();
            } else {
                //这里是可以提现的
                if(appliCash.getCashMethod().equals(AppliCash.cashMethod.wxCash)){
                    appliCash.setOpenid(getCurrentUserOpenId(currentUser));
                }
                appliCashService.applyCash(appliCash,currentUser);
            }
        } else {
            if (appliCash.getAmount().compareTo(new BigDecimal(5000)) > 0) {
                msg = "超过当天"+cashMethodName(appliCash)+"可提现金额！";
            } else {
                //这里也是可以提现
                if(appliCash.getCashMethod().equals(AppliCash.cashMethod.wxCash)){
                    appliCash.setOpenid(getCurrentUserOpenId(currentUser));
                }
                appliCashService.applyCash(appliCash,currentUser);
            }
        }
        //表中插入记录
        addFlashMsg(redirectAttributes, msg);
        return "redirect:/member/index";
    }
    private String cashMethodName(AppliCash appliCash){
        if(appliCash.getCashMethod().equals(AppliCash.cashMethod.wxCash)){
            return "微信";
        }
        return  "支付宝";
    }


    
}
