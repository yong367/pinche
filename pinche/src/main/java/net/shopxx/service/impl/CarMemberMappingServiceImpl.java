package net.shopxx.service.impl;

import net.shopxx.dao.CarMemberMappingDao;
import net.shopxx.entity.CarMemberMapping;
import net.shopxx.service.CarMemberMappingService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class CarMemberMappingServiceImpl extends BaseServiceImpl<CarMemberMapping,Long> implements CarMemberMappingService {
    @Inject
    private CarMemberMappingDao carMemberMappingDao;
}
