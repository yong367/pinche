package net.shopxx.dao.impl;

import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.BusinessFansMappingDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessFansMapping;
import net.shopxx.entity.Member;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.sql.DataSource;
import java.util.List;
import java.util.Map;

@Repository
public class BusinessFansMappingDaoImpl extends BaseDaoImpl<BusinessFansMapping,Long> implements BusinessFansMappingDao{
    @Inject
    private DataSource dataSource;
    protected JdbcTemplate jdbcTemplate;
    @PostConstruct
    private void afterConstruct() {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }
    

    /**
     * 查询粉丝消息
     * @param param
     * @param business
     * @param pageable
     * @return
     */
    @Override
    public Page<Map<String, Object>> findFans(Map<String, Object> param, Business business, Pageable pageable) {
        int startIndex = (pageable.getPageNumber()-1)*pageable.getPageSize();
        String selectSql = "SELECT f.NAME AS groupName,m.username,mr.name,bm.totalAmount,bm.memberAmount,bm.id,bm.member_id as memberId";
        String totalsql = "select count(bm.id)";
        String orderProperty = pageable.getOrderProperty();
        Order.Direction orderDirection = pageable.getOrderDirection();
        if (pageable.getOrderProperty() == null){
            orderProperty = "bm.id";
        }
        if (pageable.getOrderDirection() == null){
            orderDirection = Order.Direction.desc;
        }
        String limitSql = " order by "+orderProperty+" "+orderDirection+" limit "+startIndex+","+pageable.getPageSize();
        String sql = " FROM FansGroup f,BusinessFansMapping bm,Member m ,MemberRank mr where bm.fansGroup_id = f.id  AND bm.business_id = "+business.getId()+" and mr.id = m.memberRank_id and bm.member_id = m.id";
        sql = processSearchParam(sql,param);
        List<Map<String, Object>> result = jdbcTemplate.queryForList(selectSql+sql+limitSql);
        Integer total = jdbcTemplate.queryForObject(totalsql+sql, Integer.class);
        Page<Map<String,Object>> pageResult = new Page(result,total,pageable);
        return pageResult;
    }


    private String processSearchParam(String sql,Map<String,Object> param){

        if(null != param.get("fansRank")){
            sql += " and mr.id ="+param.get("fansRank") ;
        }
        if(null != param.get("fansGroup")){
            sql += " and f.id ="+param.get("fansGroup") ;
        }
 
        return sql;
    }

    /**
     * 查找BusinessFansMapping
     * @param business
     * @param currentUser
     * @return
     */
    @Override
    public BusinessFansMapping findBusinessAndMember(Business business, Member currentUser) {
        try{
            String jpql = "select businessFansMapping from BusinessFansMapping businessFansMapping where businessFansMapping.business =:businessId and businessFansMapping.member = :memberId ";
            return entityManager.createQuery(jpql, BusinessFansMapping.class).setParameter("businessId",business).setParameter("memberId",currentUser).getSingleResult();
        }catch (Exception e){
            return null;
        }
    }
}
