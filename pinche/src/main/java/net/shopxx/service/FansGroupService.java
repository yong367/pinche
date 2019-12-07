package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.FansGroup;

public interface FansGroupService extends BaseService<FansGroup,Long>{
    /**
     * 常见分组
     * @param business
     */
    void createGroup(Business business);

    /**
     * 查找组
     * @param business
     * @param pageable
     * @return
     */
    Page<FansGroup> findPage(Business business, Pageable pageable);

    /**
     * 通过组名查FansGroup
     * @return
     */
    FansGroup findByGroupName();

    FansGroup findDefaultFansGroup(Business business);
}
