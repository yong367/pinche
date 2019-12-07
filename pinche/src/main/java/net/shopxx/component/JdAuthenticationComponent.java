package net.shopxx.component;

import com.alibaba.fastjson.JSON;
import net.shopxx.service.LogPrintService;
import net.shopxx.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 *
 *
 * @author zhangmengfei
 * @date 2019-9-9 - 14:59
 */
@Component
public class JdAuthenticationComponent {

    @Autowired
    private LogPrintService logPrintService;

    private String appkey="";
    private String url="";

    /**
     * Jd certification
     *
     *@author zhangmengfei
     *@Date 2019-9-9 13:02
     */
    public Map<String,String> jdauth(Map<String,Object> paramMap) {
        Map<String,String> jdauth=new HashMap<>();
        String code="";
        paramMap.put("appkey",appkey);
        logPrintService.printServerLog("Jd authentication request parameters 【" + JSON.toJSONString(paramMap)+" 】");
        String s = WebUtils.post(url, paramMap);
        logPrintService.printServerLog("Jd certification returns results 【" + s+" 】");
        Map<String,Object> job= JSON.parseObject(s,Map.class);
        String apiCode = job.get("code")+"";
        String msg=job.get("msg")+"";
        if (apiCode.equals("10000")){
            Map<String,Object> result=(Map<String,Object>)job.get("result");
            code = result.get("code")+"";
            msg=result.get("msg")+"";
        }
        jdauth.put("apiCode",apiCode);
        jdauth.put("code",code);
        jdauth.put("msg",msg);
        return jdauth;
    }

}
