package net.shopxx.component;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.entity.Business;
import net.shopxx.entity.FansGroup;
import net.shopxx.entity.ProductCoupon;
import net.shopxx.service.CacheService;
import net.shopxx.service.FansGroupService;
import net.shopxx.service.ProductCouponService;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.*;

@Component
public class ProductCouponCahceManage {


    @Resource
    private ProductCouponService productCouponService;

    private final Map<String, Queue<ProductCoupon>> productCouponMap = new HashMap<>();

    public List<ProductCoupon> getProductCouponList(String skuId,int count){
        synchronized (skuId.intern()) {
            Queue<ProductCoupon> lists = productCouponMap.get(skuId);
            List<ProductCoupon> result = new ArrayList<>();
            if (lists == null && lists.size() < count) {
                initProductCoupon(skuId, lists);
            }
            for (int i = 0; i < count; i++) {
                result.add(lists.poll());
            }
            return result;
        }
    }
    public ProductCoupon getProductCoupon(String skuId){
        synchronized (skuId.intern()) {
            Queue<ProductCoupon> lists = productCouponMap.get(skuId);
            if (lists == null || lists.size() ==0) {
                lists=initProductCoupon(skuId, lists);
            }
            return lists.poll();
        }
    }


    /**
     * 当发现list中对应的数据对象为空或者size等于0是 需要加锁初始化
     */
    public Queue<ProductCoupon> initProductCoupon(String skuId,Queue<ProductCoupon> result){
        if(result==null){
            result = new LinkedList<>();
        }
        List<ProductCoupon> list = productCouponService.loadProductCouponListBySkuId(skuId);
        for (ProductCoupon productCoupon :list) {
            result.add(productCoupon);
        }
        return result;
    }

    /**
     *每天晚上11点清除 内容中缓冲数据，待定
     */
    public void clearCache(){
        Set<String> keys=productCouponMap.keySet();
        for (String key:keys){
            productCouponMap.remove(key);
        }
    }
}
