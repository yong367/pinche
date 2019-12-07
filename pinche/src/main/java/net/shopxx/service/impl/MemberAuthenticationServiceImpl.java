package net.shopxx.service.impl;

import net.shopxx.component.JdAuthenticationComponent;
import net.shopxx.dao.MemberAuthenticationDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAuthentication;
import net.shopxx.service.MemberAuthenticationService;
import net.shopxx.service.MemberService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.HashMap;
import java.util.Map;

/**
 *
 *
 * @author zhangmengfei
 * @date 2019-9-6 - 10:54
 */
@Service
public class MemberAuthenticationServiceImpl extends BaseServiceImpl<MemberAuthentication,Long> implements MemberAuthenticationService {

    @Autowired
    private MemberAuthenticationDao memberAuthenticationDao;
    @Autowired
    private JdAuthenticationComponent jdAuthenticationComponent;
    @Autowired
    private MemberService memberService;


    @Transactional
    @Override
    public Map<String, String> authentificat(Member currentUser,MemberAuthentication memberAuthentication) {
        Map<String, String> jdauth = new HashMap<>();
        boolean isSave=true;
        String mobile = currentUser.getMobile();
        Long id = currentUser.getId();
        memberAuthentication.setMemberId(id);
        MemberAuthentication record = memberAuthenticationDao.find("memberId", id);
        if(record!=null){
            Integer faileNumber = record.getFaileNumber();
            if(faileNumber!=null && faileNumber>=3){
                jdauth.put("code","444");
                jdauth.put("msg","认证错误次数超过三次，请联系客服");
                return jdauth;
            }
            isSave=false;
            memberAuthentication.setId(record.getId());
            memberAuthentication.setFaileNumber(record.getFaileNumber());
        }
        Map<String,Object> paramMap=new HashMap<>();
        paramMap.put("idcard",memberAuthentication.getIdCard());
        paramMap.put("realname",memberAuthentication.getRealName());
        paramMap.put("phone",mobile);
//        jdauth = jdAuthenticationComponent.jdauth(paramMap);
        jdauth.put("code","200");
        jdauth.put("apiCode","10000");
        jdauth.put("msg","不一致");
        String code = jdauth.get("code");
        String apiCode = jdauth.get("apiCode");
        String msg = jdauth.get("msg");
        if(StringUtils.isNotEmpty(code)){
            memberAuthentication.setReturnCode(code);
        }else{
            memberAuthentication.setReturnCode(apiCode);
        }
        memberAuthentication.setReturnMsg(msg);
        if (apiCode.equals("10000")){       //接口调用成功
            if(code.equals("200")){           //认证成功
                currentUser.setAuthenticationStatus(true);
                memberService.update(currentUser);
                memberAuthentication.setAuthenticationStatus(true);
            }else{
                memberAuthentication.setAuthenticationStatus(false);
                if(isSave){
                    memberAuthentication.setFaileNumber(1);
                }else {
                    memberAuthentication.setFaileNumber(memberAuthentication.getFaileNumber()+1);
                }
            }
        }
        if(isSave){
            this.save(memberAuthentication);
        }else{
            this.update(memberAuthentication);
        }
        return jdauth;
    }
}