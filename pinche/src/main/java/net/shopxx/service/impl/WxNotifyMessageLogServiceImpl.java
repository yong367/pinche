package net.shopxx.service.impl;

import net.shopxx.dao.WxNotifyMessageLogDao;
import net.shopxx.entity.WxNotifyMessageLog;
import net.shopxx.service.WxNotifyMessageLogService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class WxNotifyMessageLogServiceImpl extends BaseServiceImpl<WxNotifyMessageLog,Long> implements WxNotifyMessageLogService {

    @Inject
    private WxNotifyMessageLogDao wxNotifyMessageLogDao;
}
