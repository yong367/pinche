package net.shopxx.controller.member;

import net.shopxx.FileType;
import net.shopxx.Results;
import net.shopxx.entity.Member;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.FileService;
import net.shopxx.service.MemberService;
import net.shopxx.service.ShareCodeService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import javax.servlet.ServletContext;

/**
 *Controller 头像
 */
@Controller("imageController")
@RequestMapping("/member/image")
public class ImageController extends BaseController {

    @Inject
    private FileService fileService;
    @Inject
    private MemberService memberService;
    @Inject
    private ShareCodeService shareCodeService;
    @Inject
    private ServletContext servletContext;
    /**
     * 跳转到头像上传页面
     * @param currentUser
     * @param model
     * @return
     */
    @GetMapping("/edit")
    public String edit(@CurrentUser Member currentUser, ModelMap model) {
        return "/member/head_image/edit";
    }
    /**
     * 上传
     */
    @PostMapping("/upload")
    public ResponseEntity<?> upload(@CurrentUser Member currentUser, FileType fileType, MultipartFile file) {
        if (fileType == null || file == null || file.isEmpty()) {
            return Results.UNPROCESSABLE_ENTITY;
        }
        //头像的地址图片
       String url = fileService.upload(fileType, file,false);
        
        if (StringUtils.isEmpty(url)) {
            return Results.unprocessableEntity("business.upload.error");
        }
        
        currentUser.setImageUrl(url);
        memberService.update(currentUser);
        
        shareCodeService.generateUpdateImgUrl(currentUser);

        return ResponseEntity.ok("上传头像成功");
    }
    
    

  
    
}
