package net.shopxx.service.impl;

import net.shopxx.dao.CitiesDao;
import net.shopxx.entity.Cities;
import net.shopxx.service.CitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author zhangmengfei
 * @Date 2019-9-17 - 16:20
 */
@Service
public class CitiesServiceImpl extends BaseServiceImpl<Cities,Long> implements CitiesService {

    @Autowired
    private CitiesDao citiesDao;

    @Override
    public List<Cities> findCityByProviceId(String proviceId) {
        return citiesDao.findCityByProviceId(proviceId);
    }

}
