package net.shopxx.suning.model;

import com.suning.api.entity.govbus.OrderAddRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 苏宁订单请求实体类
 * N是不是必填，Y 是必填
 */
public class SuNingCreateOrder {


    /**
     * 商品信息
     */
    private List<OrderAddRequest.Sku> sku = new ArrayList<>();

    /**
     * 详细地址不能多于80汉字
     * Y
     */
    private String address;

    /**
     * 订单金额
     * Y
     */
    private String amount;

    /**
     * 市编码
     * Y
     */
    private String cityId;

    /**
     * 子公司账号(母公司下单：不传；子公司下单传：传子公司账号)
     * N
     */
    private String companyCustNo;

    /**
     * 区/县编码
     * Y
     */
    private String countyId;

    /**
     * 邮箱
     * N
     */
    private String email;

    /**
     * 发票内容：1-明细（invoiceState是否开票=1时必填）
     * N
     */
    private String invoiceContent;

    /**
     * 	是否开发票(1=开，0=不开)
     * 	Y
     */
    private String invoiceState;

    /**
     * 发票抬头（invoiceState是否开票=1 时必填）
     * N
     */
    private String invoiceTitle;

    /**
     * 发票类型：1=增值发票（增税专票，不指定公司开票） 2=普通发票（卷票，票随货走，不指定公司开票） 6=统一增票 （增税专票，指定公司开票）4=电子发票（不指定公司开票） 9=统一电子发票（指定公司开票），（invoiceState是否开票=1时必填）
     * N
     */
    private String invoiceType;

    /**
     * 手机号
     * Y
     */
    private String mobile;

    /**
     * 订单类型(0.实时型订单 1. 预占型订单)
     * Y
     */
    private String orderType;

    /**
     * 支付方式(03-货到付款现金；04-货到付款POS；09-预付款；08-账期)
     * Y
     */
    private String payment;

    /**
     * 省编码
     * Y
     */
    private String provinceId;

    /**
     * 收货人(收货人姓名不能超过12个汉字)
     * Y
     */
    private String receiverName;

    /**
     * 备注
     * N
     */
    private String remark;

    /**
     * 运费
     * Y
     */
    private String servFee;

    /**
     * 纳税人识别号
     * N
     */
    private String taxNo;

    /**
     * 座机号
     * N
     */
    private String telephone;

    /**
     * 镇编码
     * N
     */
    private String townId;

    /**
     * 交易单号(客户唯一流水号)
     * Y
     */
    private String tradeNo;

    /**
     * 邮编(6位数字)
     * N
     */
    private String zip;

    public List<OrderAddRequest.Sku> getSku() {
        return sku;
    }


    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public String getCompanyCustNo() {
        return companyCustNo;
    }

    public void setCompanyCustNo(String companyCustNo) {
        this.companyCustNo = companyCustNo;
    }

    public String getCountyId() {
        return countyId;
    }

    public void setCountyId(String countyId) {
        this.countyId = countyId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getInvoiceContent() {
        return invoiceContent;
    }

    public void setInvoiceContent(String invoiceContent) {
        this.invoiceContent = invoiceContent;
    }

    public String getInvoiceState() {
        return invoiceState;
    }

    public void setInvoiceState(String invoiceState) {
        this.invoiceState = invoiceState;
    }

    public String getInvoiceTitle() {
        return invoiceTitle;
    }

    public void setInvoiceTitle(String invoiceTitle) {
        this.invoiceTitle = invoiceTitle;
    }

    public String getInvoiceType() {
        return invoiceType;
    }

    public void setInvoiceType(String invoiceType) {
        this.invoiceType = invoiceType;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public String getProvinceId() {
        return provinceId;
    }

    public void setProvinceId(String provinceId) {
        this.provinceId = provinceId;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getServFee() {
        return servFee;
    }

    public void setServFee(String servFee) {
        this.servFee = servFee;
    }

    public String getTaxNo() {
        return taxNo;
    }

    public void setTaxNo(String taxNo) {
        this.taxNo = taxNo;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getTownId() {
        return townId;
    }

    public void setTownId(String townId) {
        this.townId = townId;
    }

    public String getTradeNo() {
        return tradeNo;
    }

    public void setTradeNo(String tradeNo) {
        this.tradeNo = tradeNo;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }

    public void addOrderProductToArray(String num,String skuId,String unitPrice){
        OrderAddRequest.Sku sk=new OrderAddRequest.Sku();
        sk.setNum(num);
        sk.setSkuId(skuId);
        sk.setUnitPrice(unitPrice);
        sku.add(sk);
    }
}
