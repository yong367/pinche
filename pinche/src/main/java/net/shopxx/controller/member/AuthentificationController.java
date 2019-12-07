package net.shopxx.controller.member;

import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAuthentication;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.MemberAuthenticationService;
import net.shopxx.service.MemberService;
import net.shopxx.util.ResponseData;
import net.shopxx.util.SystemUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * shimingrenzheng
 *
 * @Author zhangmengfei
 * @Date 2019-9-11 - 15:55
 */
@Controller
@RequestMapping("/member/authentification")
public class AuthentificationController extends BaseController{

    @Autowired
    private MemberAuthenticationService memberAuthenticationService;
    @Autowired
    private MemberService memberService;

    @GetMapping("/authentification")
    public String authentification(String preActionName,Map<String,Object> map){
        map.put("preActionName",preActionName);
        return "member/authentification/authentification";
    }

    @ResponseBody
    @RequestMapping("/upload")
    public ResponseData upload(HttpServletRequest request,MultipartFile file){
//        String realPath = "www.lifeabb.com/upload/idcard/";
        String realPath = request.getSession().getServletContext().getRealPath("/upload/idcard/");
        System.out.println(realPath);
        File directry=new File(realPath);
        if(!directry.exists()){
            directry.mkdirs();
        }
        String standardtime = SystemUtil.getStandardtime();
        String fileName=file.getOriginalFilename();
        String fileNameSave=standardtime+fileName.substring(fileName.lastIndexOf("."));
        String realName=realPath+"/"+fileNameSave;
        System.out.println("上传图片路径===>"+realName);
        File targetFile=new File(realName);
        try {
            file.transferTo(targetFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
        Map<String,Object> map=new HashMap<>();
        String realPath2 = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/upload/idcard/"+fileNameSave;
        System.out.println("查看图片路径===>"+realPath2);
        map.put("src",realPath2);
        return ResponseData.success(0,"上传成功",map);
    }

    /**
     * 实名认证
     *
     * @Author zhangmengfei
     * @Date 2019-9-11 - 17:31
     */
    @ResponseBody
    @PostMapping("/authentification")
    public Map<String,String> authentification(@CurrentUser Member currentUser, MemberAuthentication memberAuthentication,String preActionName){
        Map<String,String> map = memberAuthenticationService.authentificat(currentUser,memberAuthentication);
        String url="";
        if(preActionName.equals("tixian")){
            url="/member/appliCash/cash/cashApply";
        }else if(preActionName.equals("setting")) {
            url="/member/index";
        }
        map.put("url",url);
        return map;
    }
}
