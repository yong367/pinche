package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessFansMapping;
import net.shopxx.entity.Member;

import java.util.Map;

public interface BusinessFansMappingDao extends BaseDao<BusinessFansMapping,Long>{

    /**
     * 查找推送消息粉丝
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
}
