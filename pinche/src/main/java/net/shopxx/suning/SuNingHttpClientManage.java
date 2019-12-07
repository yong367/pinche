package net.shopxx.suning;

import com.suning.api.DefaultSuningClient;
import com.suning.api.SuningRequest;
import com.suning.api.SuningResponse;
import com.suning.api.exception.SuningApiException;
import net.shopxx.LogbackConstant;
import net.shopxx.service.LogPrintService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

@Component
public class SuNingHttpClientManage {

    private DefaultSuningClient client =null;

    @Inject
    LogPrintService logPrintService;


    @PostConstruct
    private void initClient(){
        client = new DefaultSuningClient(SuNingConfig.serverUrl,SuNingConfig.appKey,SuNingConfig.appSecret,SuNingConfig.dataFormat);
    }

    public SuningResponse request(SuningRequest request) throws SuningApiException {
        SuningResponse response = null;
            request.setCheckParam(SuNingConfig.checkParam);
            response = client.excute(request);
           logPrintService.printSuNingServerLog("recive suning responseBody:"+response.getBody());
        return response;
    }

}
