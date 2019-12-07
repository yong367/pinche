package net.shopxx.service;

import net.shopxx.entity.Cities;

import java.util.List;

/**
 * @Author zhangmengfei
 * @Date 2019-9-17 - 16:19
 */
public interface CitiesService extends BaseService<Cities,Long>{

    List<Cities> findCityByProviceId(String proviceId);
}
