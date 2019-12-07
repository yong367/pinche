package net.shopxx.dao.impl;

import net.shopxx.dao.AnnouncementDao;
import net.shopxx.entity.Announcement;
import org.springframework.stereotype.Repository;

@Repository
public class AnnouncementDaoImpl extends BaseDaoImpl<Announcement,Long> implements AnnouncementDao {
}
