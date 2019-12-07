package net.shopxx.controller.shop;

import com.alibaba.fastjson.JSON;
import net.shopxx.dao.CitiesDao;
import net.shopxx.entity.Cities;
import net.shopxx.service.CitiesService;
import net.shopxx.service.LogPrintService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @Author zhangmengfei
 * @Date 2019-9-19 - 9:14
 */
@Controller
@RequestMapping("/district")
public class DistrictController {

    @Autowired
    private CitiesService citiesService;
    @Autowired
    private CitiesDao citiesDao;
    @Autowired
    private LogPrintService logPrintService;

    @ResponseBody
    @RequestMapping("/findCity")
    public List<Cities> findCity(String proviceId){
        List<Cities> cities=null;
        try {
            cities=citiesService.findCityByProviceId(proviceId);
        }catch (Exception e){
            logPrintService.printServerLog(e.getMessage());
        }
        logPrintService.printServerLog(JSON.toJSONString(cities));
        return cities;
    }

}
