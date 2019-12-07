package net.shopxx.suning.model;

public class SuNingShipBase {
    //详细地址，不需包含省市区镇信息(少于80个字符)
    protected String addressDetail;

    //送货地址(市) 编码
    protected String cityId;

    //送货地址(区) 编码
    protected String districtId;

    //送货地址(镇) 编码
    protected String townId;

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public String getDistrictId() {
        return districtId;
    }

    public void setDistrictId(String districtId) {
        this.districtId = districtId;
    }

    public String getTownId() {
        return townId;
    }

    public void setTownId(String townId) {
        this.townId = townId;
    }
}
