package net.shopxx.service.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.ProductCouponDao;
import net.shopxx.entity.ProductCoupon;
import net.shopxx.entity.Sku;
import net.shopxx.service.ProductCouponService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import javax.inject.Inject;
import javax.persistence.LockModeType;
import java.util.List;

@Service
public class ProductCouponServiceImpl extends BaseServiceImpl<ProductCoupon, Long> implements ProductCouponService {

    @Inject
    private ProductCouponDao productCouponDao;

    @Override
    public ProductCoupon findByCode(String code) {
        return productCouponDao.findByCode(code);
    }

    @Override
    public List<ProductCoupon> findListByOrderSn(String sn) {
        return productCouponDao.findListByOrderSn(sn);
    }

    @Override
    @Transactional
    public int updateStatus(ProductCoupon productCoupon, String sn) {
        /*synchronized (productCoupon.getCodeValue().intern()) {
            Assert.notNull(productCoupon);
            Assert.isNull(productCoupon.getOrderSn());

            if (!LockModeType.PESSIMISTIC_WRITE.equals(productCouponDao.getLockMode(productCoupon))) {
                productCouponDao.flush();
                productCouponDao.refresh(productCoupon, LockModeType.PESSIMISTIC_WRITE);
            }
            Assert.isTrue(productCoupon.getUsable() == true, "current productCoupon is used");
            productCoupon.setUsable(false);
            productCoupon.setOrderSn(sn);
            productCouponDao.flush();
        }*/
        int result=productCouponDao.updateStatus(productCoupon,sn);
        return result;
    }

    @Override
    public List<ProductCoupon> loadProductCouponListBySkuId(String skuid) {
        return productCouponDao.loadProductCouponListBySkuId(skuid);
    }

    @Override
    public Page<ProductCoupon> findProductCouponBySkuId(Pageable pageable, Sku sku) {
        return productCouponDao.findProductCouponBySkuId(pageable,sku);
    }
}
