package net.shopxx.service.impl;

import net.shopxx.LogbackConstant;
import net.shopxx.service.LogPrintService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.PrintWriter;
import java.io.StringWriter;

@Service
public class LogPrintServiceImpl implements LogPrintService{

    private Logger SERVER_LOGGER = LoggerFactory.getLogger(LogbackConstant.SERVER_LOGGER_NAME);
    private Logger SUNING_SERVER_LOGGER =LoggerFactory.getLogger(LogbackConstant.SUNING_SERVER_LOGGER_NAME);
    private Logger SUNING_SERVER_ERROR_LOGGER=LoggerFactory.getLogger(LogbackConstant.SUNING_SERVER_ERROR_LOGGER_NAME);

    @Override
    public void pringSuNingServerErrorLog(String msg) {
        SUNING_SERVER_ERROR_LOGGER.info(msg);
    }

    @Override
    public void printSuNingServerLog(String msg) {
        SUNING_SERVER_LOGGER.info(msg);
    }

    @Override
    public void printServerLog(String msg) {
        SERVER_LOGGER.info(msg);
    }

    @Override
    public void printServerLog(String msg, Exception e) {
        printServerLog(msg + excetionToStringMessage(e));
    }

    private String excetionToStringMessage(Exception e){
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw, true);
        e.printStackTrace(pw);
        pw.flush();
        sw.flush();
        return sw.toString();
    }
}
