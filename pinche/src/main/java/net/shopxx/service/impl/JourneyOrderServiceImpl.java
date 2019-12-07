package net.shopxx.service.impl;

import net.shopxx.entity.JourneyOrder;
import net.shopxx.service.JourneyOrderService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class JourneyOrderServiceImpl extends BaseServiceImpl<JourneyOrder,Long> implements JourneyOrderService {

    @Inject
    private JourneyOrderService journeyOrderService;
}
