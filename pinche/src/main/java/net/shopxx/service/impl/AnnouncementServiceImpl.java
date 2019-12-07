package net.shopxx.service.impl;

import net.shopxx.dao.AnnouncementDao;
import net.shopxx.entity.Announcement;
import net.shopxx.service.AnnouncementService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class AnnouncementServiceImpl extends BaseServiceImpl<Announcement,Long> implements AnnouncementService {

    @Inject
    private AnnouncementDao announcementDao;
}
