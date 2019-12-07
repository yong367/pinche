package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.FansGroup;

public interface FansGroupDao extends BaseDao<FansGroup,Long>{
    /**
     * 查找粉丝组(分页)
     * @param business
     * @param pageable
     * @return
     */
    Page<FansGroup> findPage(Business business, Pageable pageable);

    /**
     * 通过id，默认分组查找实体类
     * @param business
     * @return
     */
    FansGroup findDefaultFansGroup(Business business);
}
