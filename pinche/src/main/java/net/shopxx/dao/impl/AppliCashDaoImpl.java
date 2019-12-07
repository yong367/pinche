package net.shopxx.dao.impl;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.AppliCashDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.AppliCash;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.stereotype.Repository;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class AppliCashDaoImpl extends BaseDaoImpl<AppliCash,Long> implements AppliCashDao {
    @Inject
    private DataSource dataSource;
    protected JdbcTemplate jdbcTemplate;
    @PostConstruct
    private void afterConstruct() {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }
    @Override
    public Page<AppliCash> findPage(Member member, Pageable pageable) {
        if (member == null) {
            return Page.emptyPage(pageable);
        }
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<AppliCash> criteriaQuery = criteriaBuilder.createQuery(AppliCash.class);
        Root<AppliCash> root = criteriaQuery.from(AppliCash.class);
        criteriaQuery.select(root);
        criteriaQuery.where(criteriaBuilder.equal(root.get("member"), member));
        return super.findPage(criteriaQuery, pageable);
    }

    @Override
    public BigDecimal findByApplyCashPluginTypeAndStatus(AppliCash.cashMethod cashMethod, Member currentUser) {
        String sql="select sum(amount) from AppliCash where cashMethod="+cashMethod.ordinal()+" and status =1 and member_id="+currentUser.getId();
        BigDecimal applyCashAmount =jdbcTemplate.query(sql,new ResultSetExtractor<BigDecimal>(){
            @Override
            public BigDecimal extractData(ResultSet resultSet) throws SQLException, DataAccessException {
                if(resultSet.next()){
                    return resultSet.getBigDecimal(1)==null?BigDecimal.ZERO:resultSet.getBigDecimal(1);
                }
                return BigDecimal.ZERO;
            }
        });
        return applyCashAmount;
    }
}
