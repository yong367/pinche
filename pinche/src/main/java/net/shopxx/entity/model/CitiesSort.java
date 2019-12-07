package net.shopxx.entity.model;

import net.shopxx.entity.Cities;

import java.util.List;

/**
 * @Author zhangmengfei
 * @Date 2019-9-17 - 18:00
 */
public class CitiesSort {

    private String word;
    private List<Cities> cities;

    public void setWord(String word) {
        this.word = word;
    }

    public void setCities(List<Cities> cities) {
        this.cities = cities;
    }

    public String getWord() {
        return word;
    }

    public List<Cities> getCities() {
        return cities;
    }
}
