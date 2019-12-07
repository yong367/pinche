package net.shopxx.template.method;

import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModelException;
import net.shopxx.util.FreeMarkerUtils;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;

@Component
public class FormatProductSals  implements TemplateMethodModelEx {

    /**
     * 由于前期购买数量比较少 所以通过这种形式来显示用户的购买数量 如果传的是true 显示的就是真实的销售数量
     * @param list
     * @return
     * @throws TemplateModelException
     */
    @Override
    public Object exec(List list) throws TemplateModelException {
        int realcount = FreeMarkerUtils.getArgument(0, Integer.class, list);
        Boolean showTheTrueSals = FreeMarkerUtils.getArgument(1, Boolean.class, list);
        if(showTheTrueSals){
           return realcount;
        }else{

            int a = (realcount+5)*2;
            return String.valueOf(a);
        }

    }
}
