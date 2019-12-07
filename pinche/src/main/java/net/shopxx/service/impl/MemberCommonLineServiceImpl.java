package net.shopxx.service.impl;

import net.shopxx.dao.MemberCommonLineDao;
import net.shopxx.entity.MemberCommonLine;
import net.shopxx.service.MemberCommonLineService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class MemberCommonLineServiceImpl extends BaseServiceImpl<MemberCommonLine,Long> implements MemberCommonLineService {

    @Inject
    private MemberCommonLineDao memberCommonLineDao;
}
