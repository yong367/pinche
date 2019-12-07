package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.ProductCoupon;
import net.shopxx.entity.Sku;

import java.util.List;

public interface ProductCouponService extends BaseService<ProductCoupon, Long> {
    ProductCoupon findByCode(String code);

    List<ProductCoupon> findListByOrderSn(String sn);

    int updateStatus(ProductCoupon productCoupon,String sn);

    List<ProductCoupon> loadProductCouponListBySkuId(String skuid);

    Page<ProductCoupon> findProductCouponBySkuId(Pageable pageable, Sku sku);
}
