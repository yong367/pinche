package net.shopxx.entity.model;

import java.util.LinkedList;
import java.util.List;

/**
 * @Author zhangmengfei
 * @Date 2019-9-27 - 16:14
 */
public class District {

    private String provinceName;
    private List<String> cityList=new LinkedList<>();

    public void setProvinceName(String provinceName) {
        this.provinceName = provinceName;
    }

    public void setCityList(List<String> cityList) {
        this.cityList = cityList;
    }

    public String getProvinceName() {
        return provinceName;
    }

    public List<String> getCityList() {
        return cityList;
    }
}
