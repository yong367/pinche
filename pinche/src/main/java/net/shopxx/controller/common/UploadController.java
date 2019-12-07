package net.shopxx.controller.common;

import net.shopxx.service.FileService;
import net.shopxx.util.ResponseData;
import net.shopxx.util.SystemUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author zhangmengfei
 * @Date 2019-10-10 - 10:19
 */
@Controller
@RequestMapping("/common")
public class UploadController {


    @Inject
    private FileService fileService;

    @ResponseBody
    @RequestMapping("/upload")
    public ResponseData upload(HttpServletRequest request, MultipartFile file){
//        String realPath = "www.lifeabb.com/upload/prize/";
        String realPath = request.getSession().getServletContext().getRealPath("/upload/prize/");
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
        String realPath2 = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/upload/prize/"+fileNameSave;
        System.out.println("查看图片路径===>"+realPath2);
        map.put("src",realPath2);
        return ResponseData.success(0,"上传成功",map);
    }
}
