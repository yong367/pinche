package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessFansMapping;
import net.shopxx.entity.Member;

import java.math.BigDecimal;
import java.util.Map;

public interface BusinessFansMappingService extends BaseService<BusinessFansMapping,Long>{
    

    /**
     * 查询推送消息的粉丝
     * @param param
     * @param business
     * @param pageable
     * @return
     */
    Page<Map<String,Object>> findFans(Map<String, Object> param, Business business, Pageable pageable);

    /**
     * 查找BusinessFansMapping
     * @param business
     * @param currentUser
     * @return
     */
    BusinessFansMapping findBusinessAndMember(Business business, Member currentUser);

    void updateBusinessFansInfo(BusinessFansMapping businessFansMapping, BigDecimal fenXiaoRenYongJin, BigDecimal businessYongJin);
}
