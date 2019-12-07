package net.shopxx.component;

import net.shopxx.entity.Business;
import net.shopxx.entity.FansGroup;
import net.shopxx.service.FansGroupService;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Component
public class FansGroupManage {

    @Resource
    private FansGroupService fansGroupService;

    public void initCurrentBusinessFansGroup(Business business){
        try{
            FansGroup fansGroup  = fansGroupService.findDefaultFansGroup(business);
            if(fansGroup ==null){
                fansGroupService.createGroup(business);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        
    }
}
