package net.shopxx.controller.business;

import net.shopxx.CacheConstant;
import net.shopxx.Results;
import net.shopxx.entity.Business;
import net.shopxx.security.UserAuthenticationToken;
import net.shopxx.service.BusinessService;
import net.shopxx.service.UserService;
import net.shopxx.util.PassWordUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller("loginExtendController")
@RequestMapping("/business/loginExtend")
public class LoginExtendController extends BaseController{

    @Inject
    private UserService userService;
    @Inject
    private BusinessService businessService;

    @PostMapping("/smsLogin")
    public ResponseEntity<?> smsLogin(@RequestParam(value = "mobile") String mobile,
                                      ModelMap model,
                                      @RequestParam(value = "validateNo")String validateNo,
                                      HttpServletRequest request) {
        if(!validateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.BUSINESS_lOGIN_KEY_PREFIX,mobile,validateNo)){
            return Results.unprocessableEntity("验证码错误");
        }
        Business business =initBusiness(mobile,request);
        try{

            userService.login(new UserAuthenticationToken(Business.class, mobile, business.getEncodedPassword(), false, request.getRemoteAddr()));
        } catch (Exception e){
            e.printStackTrace();
        }
        return Results.ok("登录成功");
    }

    private Business initBusiness(String mobile,HttpServletRequest request){
        Business business = businessService.findByUsername(mobile);
        if (business == null){
            business = new Business();
            business.setUsername(mobile);
            business.setPassword(PassWordUtil.generatePwd());
            business.setMobile(mobile);
            business.setBalance(BigDecimal.ZERO);
            business.setFrozenFund(BigDecimal.ZERO);
            business.setStore(null);
            business.setCashes(null);
            business.setBusinessDepositLogs(null);
            business.setIsEnabled(true);
            business.setIsLocked(false);
            business.setLockDate(null);
            business.setLastLoginIp(request.getRemoteAddr());
            business.setLastLoginDate(new Date());
            userService.register(business);
        }
        return business;
    }

    /*
     * 发送登录验证码
     * */
    @GetMapping("/sendLoginValidateNo/{mobile}")
    public @ResponseBody
    Object sendValidateNo(@PathVariable("mobile") String mobile) {
        Map<String,String> ret = new HashMap<>();
        sendValidateNo(CacheConstant.CACHE_NAME_VALIDATENO,CacheConstant.BUSINESS_lOGIN_KEY_PREFIX,mobile,ret);
        return ret;
    }
}
