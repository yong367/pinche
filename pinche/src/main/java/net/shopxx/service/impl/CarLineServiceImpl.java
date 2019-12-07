package net.shopxx.service.impl;

import net.shopxx.dao.CarLineDao;
import net.shopxx.entity.CarLine;
import net.shopxx.service.CarLineService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class CarLineServiceImpl extends BaseServiceImpl<CarLine,Long> implements CarLineService {

    @Inject
    private CarLineDao carLineDao;

    @Override
    public boolean checkExist(CarLine carLine) {

        return carLineDao.checkExist(carLine);
    }


}
