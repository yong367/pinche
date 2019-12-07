package net.shopxx.service;

import net.shopxx.entity.CarLine;

public interface CarLineService extends BaseService<CarLine,Long>{
        boolean checkExist(CarLine carLine);
}
