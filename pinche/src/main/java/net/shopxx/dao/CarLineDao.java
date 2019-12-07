package net.shopxx.dao;

import net.shopxx.entity.CarLine;

public interface CarLineDao extends BaseDao<CarLine,Long>{
    boolean checkExist(CarLine carLine);
}
