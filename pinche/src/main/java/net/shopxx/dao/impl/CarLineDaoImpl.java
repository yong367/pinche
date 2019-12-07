package net.shopxx.dao.impl;

import net.shopxx.dao.CarLineDao;
import net.shopxx.entity.CarLine;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;

@Repository
public class CarLineDaoImpl extends BaseDaoImpl<CarLine,Long> implements CarLineDao {
    @Override
    public boolean checkExist(CarLine carLine) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<CarLine> criteriaQuery = criteriaBuilder.createQuery(CarLine.class);
        Root<CarLine> root = criteriaQuery.from(CarLine.class);
        criteriaQuery.select(root);
        Predicate restrictions = criteriaBuilder.conjunction();
        restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("fromSite"),carLine.getFromSite().trim()));
        restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("toSite"),carLine.getToSite().trim()));
        criteriaQuery.where(restrictions);
        List<CarLine> list = findList(criteriaQuery);
       return list!=null && list.size()>0;
    }
}
