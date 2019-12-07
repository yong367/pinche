package net.shopxx.controller.business;

import net.shopxx.FileType;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.*;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.LogPrintService;
import net.shopxx.service.ProductCouponService;
import net.shopxx.service.SkuService;
import net.shopxx.util.ExcelUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.util.*;

/**
 * 商品券码管理
 */
@Controller("productCouponController")
@RequestMapping("/business/productCoupon")
public class ProductCouponController extends BaseController {

    @Inject
    private ProductCouponService productCouponService;

    @Inject
    private SkuService skuService;

    @Inject
    private LogPrintService logPrintService;


    /**
     * 编辑
     */
    @GetMapping("/list")
    public String list(Long skuId, @CurrentStore Store currentStore, ModelMap model, Pageable pageable) {
        Sku sku = skuService.find(skuId);
        if (sku==null) {
            return UNPROCESSABLE_ENTITY_VIEW;
        }
        if (!currentStore.equals(sku.getStore())) {
            return UNPROCESSABLE_ENTITY_VIEW;
        }
        Page<ProductCoupon> page= productCouponService.findProductCouponBySkuId(pageable,sku);
        model.addAttribute("page",page);
        model.addAttribute("skuId", skuId);
        return "business/product/productCouponlist";
    }
    /**
     * 删除
     */
    @PostMapping("/uploadCoupon")
    @ResponseBody
    public Object uploadCoupon(Long skuId, @CurrentStore Store currentStore, @RequestParam("file") MultipartFile file) {
        Map<String,String> ret = new HashMap<>();
        Sku sku = skuService.find(skuId);
        if (sku==null) {
            ret.put("status","error");
            ret.put("msg","request param error!");
            return ret;
        }
        if (!currentStore.equals(sku.getStore())) {
            ret.put("status","error");
            ret.put("msg","request param error!");
            return ret;
        }
        String[] fields = {"code","softName"};
        List<Map<String,String>> result=new ArrayList<>();
        try{
            result= ExcelUtil.excelToList(file.getInputStream(),"code", fields );
        }catch(Exception e){
            logPrintService.printServerLog(e.getMessage(), e);
            ret.put("status","error");
            ret.put("msg","Parse upload file error");
            return ret;
        }
        StringBuilder errorCode = new StringBuilder();
        StringBuilder skipCode = new StringBuilder();
            logPrintService.printServerLog("storeID:"+currentStore.getId()+",storeName:"+currentStore.getName()+" upload coupon start----------------------------");
            logPrintService.printServerLog("storeID:"+currentStore.getId()+",storeName:"+currentStore.getName()+" upload coupon size:"+result.size());
            for(Map<String,String> row:result){
                String code = row.get("code");
                String softName = row.get("softName");
            //首先判断当前是否存在 如果存在则跳过并保存改存在的code,如果不存在则保存
                try{
                    ProductCoupon productCoupon=productCouponService.findByCode(code);
                    if (productCoupon == null) {
                        productCoupon =new ProductCoupon();
                        productCoupon.setCodeValue(code);
                        productCoupon.setSoftName(softName);
                        productCoupon.setSku(sku);
                        productCoupon.setStore(currentStore);
                        productCoupon.setCreatedDate(new Date());
                        productCoupon.setUsable(true);
                        productCouponService.save(productCoupon);
                    }else{
                        skipCode.append(code).append(",");
                    }
                }catch (Exception e){
                    logPrintService.printServerLog(e.getMessage(), e);
                    errorCode.append(code).append(",");
                }
            }
        logPrintService.printServerLog("storeID:"+currentStore.getId()+",storeName:"+currentStore.getName()+" upload coupon end----------------------------");
        ret.put("status","success");
        ret.put("errorCode",errorCode.toString());
        ret.put("skipCode",skipCode.toString());
        return ret;
    }
}
