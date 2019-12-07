package net.shopxx.dao.impl;

import net.shopxx.dao.CitiesDao;
import net.shopxx.entity.Cities;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * @Author zhangmengfei
 * @Date 2019-9-17 - 16:18
 */
@Repository
public class CitiesDaoImpl extends BaseDaoImpl<Cities,Long> implements CitiesDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public List<Cities> findCityByProviceId(String proviceId) {
        String sql="select cityid,city from Cities where provinceid=?";
        RowMapper rowMapper=new RowMapper() {
            @Override
            public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                Cities cities=new Cities();
                cities.setCityid(rs.getString("cityid"));
                cities.setCity(rs.getString("city"));
                return cities;
            }
        };
        List<Cities> cities = jdbcTemplate.query(sql, new String[]{proviceId},rowMapper);
        return cities;
    }
}
