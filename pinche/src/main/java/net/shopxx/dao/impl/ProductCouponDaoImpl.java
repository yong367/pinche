package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.ProductCouponDao;
import net.shopxx.entity.ProductCoupon;
import net.shopxx.entity.Sku;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.sql.DataSource;
import java.util.List;

@Repository
public class ProductCouponDaoImpl extends BaseDaoImpl<ProductCoupon, Long> implements ProductCouponDao {

    private JdbcTemplate jdbcTemplate;
    @Inject
    private DataSource dataSource;
    @PostConstruct
    private void afterConstruct() {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public ProductCoupon findByCode(String code) {
        String sql="select o from ProductCoupon o where o.codeValue=:code";
        Query query=entityManager.createQuery(sql);
        query.setParameter("code",code);
        if(query.getResultList().size()==0 ){
            return null;
        }else{
            return (ProductCoupon) query.getSingleResult();
        }
    }

    @Override
    public List<ProductCoupon> findListByOrderSn(String sn) {
        String sql="select o from ProductCoupon o where o.orderSn=:orderSn";
        Query query=entityManager.createQuery(sql);
        query.setParameter("orderSn",sn);
       return query.getResultList();
    }

    @Override
    public List<ProductCoupon> loadProductCouponListBySkuId(String skuid) {
        String sql="select o from ProductCoupon o where o.usable=true and o.sku.id=:skuid order by o.id asc";
        Query query=entityManager.createQuery(sql);
        query.setParameter("skuid",Long.valueOf(skuid));
        query.setMaxResults(3);
        List a= query.getResultList();
        return a;
    }

    @Override
    public int updateStatus(ProductCoupon productCoupon, String sn) {
        return jdbcTemplate.update("update ProductCoupon set usable=0,orderSn="+sn+" where id="+productCoupon.getId()+" and usable=1");
    }

    @Override
    public Page<ProductCoupon> findProductCouponBySkuId(Pageable pageable, Sku sku) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<ProductCoupon> criteriaQuery = criteriaBuilder.createQuery(ProductCoupon.class);
        Root<ProductCoupon> root = criteriaQuery.from(ProductCoupon.class);
        criteriaQuery.select(root);
        Predicate predicate = criteriaBuilder.conjunction();
        predicate = criteriaBuilder.and(predicate,criteriaBuilder.equal(root.get("sku"),sku));
        criteriaQuery.where(predicate);
        return super.findPage(criteriaQuery, pageable);
    }
}
