package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.FansGroupDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.FansGroup;
import org.springframework.stereotype.Repository;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

@Repository
public class FansGroupDaoImpl extends BaseDaoImpl<FansGroup,Long> implements FansGroupDao{
    /**
     * 查店铺下所有粉丝分组
     * @param business
     * @param pageable
     * @return
     */
    @Override
    public Page<FansGroup> findPage(Business business, Pageable pageable) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<FansGroup> criteriaQuery = criteriaBuilder.createQuery(FansGroup.class);
        Root<FansGroup> root = criteriaQuery.from(FansGroup.class);
        criteriaQuery.select(root);
        if (business != null) {
            criteriaQuery.where(criteriaBuilder.equal(root.get("business"), business));
        }
        return super.findPage(criteriaQuery, pageable);
    }


    @Override
    public FansGroup findDefaultFansGroup(Business business) {
        String jpql = "select fansGroup from FansGroup fansGroup where fansGroup.business =:businessId and fansGroup.isDefautFlag = :isDefautFlag ";
        try{
         return entityManager.createQuery(jpql, FansGroup.class).setParameter("businessId",business).setParameter("isDefautFlag",true).getSingleResult();
        }catch (Exception e){
            return null;
        }

    }
}
