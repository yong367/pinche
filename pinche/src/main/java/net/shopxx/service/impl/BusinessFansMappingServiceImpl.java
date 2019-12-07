package net.shopxx.service.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.BusinessFansMappingDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessFansMapping;
import net.shopxx.entity.Member;
import net.shopxx.service.BusinessFansMappingService;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.inject.Inject;
import javax.persistence.LockModeType;
import java.math.BigDecimal;
import java.util.Map;

@Service
public class BusinessFansMappingServiceImpl extends BaseServiceImpl<BusinessFansMapping,Long> implements BusinessFansMappingService{
    @Inject
    private BusinessFansMappingDao businessFansMappingDao;

    /**
     * 推送列表所有粉丝
     * @param param
     * @param business
     * @param pageable
     * @return
     */
    @Override
    public Page<Map<String, Object>> findFans(Map<String, Object> param, Business business, Pageable pageable) {
        return businessFansMappingDao.findFans(param,business,pageable);
    }

    /**
     * 查找BusinessFansMapping
     * @param business
     * @param currentUser
     * @return
     */
    @Override
    public BusinessFansMapping findBusinessAndMember(Business business, Member currentUser) {
        return businessFansMappingDao.findBusinessAndMember(business,currentUser);
    }

    @Override
    public void updateBusinessFansInfo(BusinessFansMapping businessFansMapping, BigDecimal fenXiaoRenYongJin, BigDecimal businessYongJin) {
        Assert.notNull(businessFansMapping);

        if (!LockModeType.PESSIMISTIC_WRITE.equals(businessFansMappingDao.getLockMode(businessFansMapping))) {
            businessFansMappingDao.flush();
            businessFansMappingDao.refresh(businessFansMapping, LockModeType.PESSIMISTIC_WRITE);
        }

        businessFansMapping.setMemberAmount(businessFansMapping.getMemberAmount().add(fenXiaoRenYongJin));
        businessFansMapping.setTotalAmount(businessFansMapping.getTotalAmount().add(businessYongJin.compareTo(BigDecimal.ZERO)==0?BigDecimal.ZERO:businessYongJin));
        businessFansMappingDao.flush();
    }
}
