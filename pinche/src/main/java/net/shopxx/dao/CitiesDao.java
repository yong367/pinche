package net.shopxx.dao;

import net.shopxx.entity.Cities;

import java.util.List;

/**
 * @Author zhangmengfei
 * @Date 2019-9-17 - 16:15
 */
public interface CitiesDao extends BaseDao<Cities,Long>{

    List<Cities> findCityByProviceId(String proviceId);
}
