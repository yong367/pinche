package net.shopxx.service.impl;

import net.shopxx.dao.JourneyPaymentTransactionDao;
import net.shopxx.entity.JourneyPaymentTransaction;
import net.shopxx.service.JourneyPaymentTransactionService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class JourneyPaymentTransactionServiceImpl extends BaseServiceImpl<JourneyPaymentTransaction,Long> implements JourneyPaymentTransactionService {

    @Inject
    private JourneyPaymentTransactionDao journeyPaymentTransactionDao;
}
