package net.shopxx.service.impl;

import net.shopxx.Setting;
import net.shopxx.entity.Member;
import net.shopxx.entity.model.WaterMarkModel;
import net.shopxx.entity.model.WaterModel;
import net.shopxx.service.LogPrintService;
import net.shopxx.service.MemberService;
import net.shopxx.service.ShareCodeService;
import net.shopxx.util.CodeUtils;
import net.shopxx.util.QrCodeUtils;
import net.shopxx.util.SystemUtils;
import net.shopxx.util.WaterMarkUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import javax.servlet.ServletContext;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class ShareCodeServiceImpl implements ShareCodeService {

    @Inject
    private MemberService memberService;

    @Inject
    private ServletContext servletContext;
    @Inject
    private LogPrintService logPrintService;
    

    @Override
    public String generateShareCode() {
        String shareCode= CodeUtils.generateShareCode();
        while (true){
            if(memberService.find("shareCode", shareCode) == null){
                return shareCode;
            }else{
                shareCode=CodeUtils.generateShareCode();
            }
        }
    }

    @Override
    public String generateShareCodeImgUrl(Member member) {
        List<WaterModel> result = new ArrayList<>();
        String imgUrl="";
        String shareCode = member.getShareCode();//获得邀请码
        try {
            WaterModel qrCode = new WaterModel();//二维码水印对象
            Setting setting = SystemUtils.getSetting();
            qrCode.setImgResource(QrCodeUtils.createImage(setting.getSiteUrl() + "/member/login/shareSmsLogin?shareCode=" + shareCode));
            qrCode.setType(WaterModel.Type.IMAGE);
            qrCode.setxIndex(610);
            qrCode.setyIndex(1015);
            qrCode.setWaterHeight(400);
            qrCode.setWaterWidth(400);
            result.add(qrCode);
            //生成头像图片 
            if(StringUtils.isNotEmpty(member.getImageUrl())) {
                WaterModel headImage = new WaterModel();//二维码水印对象
                headImage.setImgResource(WaterMarkUtils.getBufferedImageByUrl(member.getImageUrl()));//获得头像地址
                headImage.setType(WaterModel.Type.IMAGE);
                headImage.setxIndex(55);
                headImage.setyIndex(1070);
                headImage.setWaterHeight(220);
                headImage.setWaterWidth(220);
                result.add(headImage);
            }
            /*if(StringUtils.isNotEmpty(member.getNickName())) {
                WaterModel nickName = new WaterModel();//昵称model
                nickName.setContent(member.getNickName());
                nickName.setType(WaterModel.Type.TEXT);
                result.add(nickName);
            }*/
            String path ="/upload/share/"+UUID.randomUUID().toString()+".png";
            String fileOutPath = servletContext.getRealPath(path);
            WaterMarkModel waterMarkModel = new WaterMarkModel();
            waterMarkModel.setResult(result);
            waterMarkModel.setFileOutPath(fileOutPath);
            waterMarkModel.setResourcePath(setting.getSiteUrl()+"/newResources/share/images/template.png");
            WaterMarkUtils.processWaterMark(waterMarkModel);
            imgUrl=setting.getSiteUrl()+path;
        } catch (Exception e) {
            logPrintService.printServerLog(shareCode+"生成分享码出现异常，"+e.getMessage());
            e.printStackTrace();
        }
        return imgUrl;
    }

    @Override
    @Transactional
    @Async("taskExecutor")
    public void generateUpdateImgUrl(Member member) {
        member.setShareCodeImgUrl(generateShareCodeImgUrl(member));
        memberService.update(member);
    }

    
}
