package net.shopxx.service;

import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAuthentication;
import java.util.Map;

public interface MemberAuthenticationService extends BaseService<MemberAuthentication,Long>{

    /**
     * 实名认证
     *
     *@author zhangmengfei
     *@Date 2019-9-9 13:04
     */
    Map<String, String> authentificat(Member currentUser, MemberAuthentication memberAuthentication);

}
