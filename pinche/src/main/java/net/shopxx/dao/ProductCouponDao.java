package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.ProductCoupon;
import net.shopxx.entity.Sku;

import java.util.List;

public interface ProductCouponDao extends BaseDao<ProductCoupon,Long>{
    ProductCoupon findByCode(String code);


    List<ProductCoupon> findListByOrderSn(String sn);

    List<ProductCoupon> loadProductCouponListBySkuId(String skuid);

    int updateStatus(ProductCoupon productCoupon, String sn);

    Page<ProductCoupon> findProductCouponBySkuId(Pageable pageable, Sku sku);
}
