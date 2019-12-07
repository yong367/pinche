package net.shopxx.service.impl;

import net.shopxx.dao.PublishJourneyDao;
import net.shopxx.entity.CarLine;
import net.shopxx.entity.PublishJourney;
import net.shopxx.service.PublishJourneyService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class PublishJourneyServiceImpl extends BaseServiceImpl<PublishJourney,Long> implements PublishJourneyService {

    @Inject
    private PublishJourneyDao publishJourneyDao;


    @Override
    public boolean checkExist(CarLine carLine) {
        return false;
    }

    @Override
    public PublishJourney save(PublishJourney entity) {


        return super.save(entity);
    }
}
