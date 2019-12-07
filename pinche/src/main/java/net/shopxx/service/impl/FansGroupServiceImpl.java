package net.shopxx.service.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.FansGroupDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.FansGroup;
import net.shopxx.service.FansGroupService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class FansGroupServiceImpl extends BaseServiceImpl<FansGroup,Long> implements FansGroupService{
    @Inject
    private FansGroupDao fansGroupDao;

    /**
     * 创建分组
     * @param business
     */
    @Override
    public void createGroup(Business business) {
        FansGroup fansGroup = new FansGroup();
        fansGroup.setBusiness(business);
        fansGroup.setDefautFlag(true);
        fansGroup.setOrderNo(1);
        fansGroup.setName("默认分组");
        save(fansGroup);
        
    }

    /**
     * 查找分组
     * @param business
     * @param pageable
     * @return
     */
    @Override
    public Page<FansGroup> findPage(Business business, Pageable pageable) {
        return fansGroupDao.findPage(business,pageable);
    }

    /**
     * 通过组名查fansGroup
     * @return
     */
    @Override
    public FansGroup findByGroupName() {
        return fansGroupDao.find("name","默认分组");
    }

    @Override
    public FansGroup findDefaultFansGroup(Business business) {
        return fansGroupDao.findDefaultFansGroup(business);
    }
}
