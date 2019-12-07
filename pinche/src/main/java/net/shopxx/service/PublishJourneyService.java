package net.shopxx.service;

import net.shopxx.entity.CarLine;
import net.shopxx.entity.PublishJourney;

public interface PublishJourneyService extends BaseService<PublishJourney,Long> {
    boolean checkExist(CarLine carLine);

}
