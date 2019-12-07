package net.shopxx.suning.model;

import com.suning.api.entity.govbus.InvoiceConfirmRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 订单发票补发接口参数封装实体类
 */
public class SuNingOrderReissurInvoice {
    private InvoiceConfirmRequest.ApplyForInvoiceReqDTO applyForInvoiceReqDTO = new InvoiceConfirmRequest.ApplyForInvoiceReqDTO();
    private List<InvoiceConfirmRequest.OrderInfoDTO> orderInfoDTO = new ArrayList<>();

    /**
     * 发票收件人详细地址
     * @param address
     */
    public void setAddress(String address) {
        applyForInvoiceReqDTO.setAddress(address);
    }

    /**
     * 公司名称 (传入增票信息时必传)
     * @param companyName
     */
    public void setCompanyName(String companyName) {
        applyForInvoiceReqDTO.setCompanyName(companyName);
    }

    /**
     * 发票收件人手机号
     * @param consigneeMobileNum
     */
    public void setConsigneeMobileNum(String consigneeMobileNum) {
        applyForInvoiceReqDTO.setConsigneeMobileNum(consigneeMobileNum);
    }

    /**
     * 发票收件人姓名
     * @param consigneeName
     */
    public void setConsigneeName(String consigneeName) {
        applyForInvoiceReqDTO.setConsigneeName(consigneeName);
    }

    /**
     * 发票内容 1:明细，3：电脑配件，19:耗材，22：办公用品，25：电器，28：数码
     * @param invoiceContent
     */
    public void setInvoiceContent(String invoiceContent) {
        applyForInvoiceReqDTO.setInvoiceContent(invoiceContent);
    }

    /**
     * 发票类型 2：普票 ，6：增票
     * @param invoiceType
     */
    public void setInvoiceType(String invoiceType) {
        applyForInvoiceReqDTO.setInvoiceType(invoiceType);
    }

    /**
     * 银行账户（传入增票信息时必传）
     * @param regAccount
     */
    public void setRegAccount(String regAccount) {
        applyForInvoiceReqDTO.setRegAccount(regAccount);
    }

    /**
     * 注册地址（传入增票信息时必传）
     * @param regAdd
     */
    public void setRegAdd(String regAdd) {
        applyForInvoiceReqDTO.setRegAdd(regAdd);
    }

    /**
     * 开户银行（传入增票信息时必传）
     * @param regBank
     */
    public void setRegBank(String regBank) {
        applyForInvoiceReqDTO.setRegBank(regBank);
    }

    /**
     * 注册电话（传入增票信息时必传）
     * @param regTel
     */
    public void setRegTel(String regTel) {
        applyForInvoiceReqDTO.setRegTel(regTel);
    }

    /**
     * 纳税人识别号（传入增票信息时必传）
     * @param taxNo
     */
    public void setTaxNo(String taxNo) {
        applyForInvoiceReqDTO.setTaxNo(taxNo);
    }

    /**
     * 发票抬头（开普票时必传）
     * @param title
     */
    public void setTitle(String title) {
        applyForInvoiceReqDTO.setTitle(title);
    }

    public void addOrderIdToArray(String gcOrderNo){
        InvoiceConfirmRequest.OrderInfoDTO orderInfo= new InvoiceConfirmRequest.OrderInfoDTO();
        orderInfo.setGcOrderNo(gcOrderNo);
        orderInfoDTO.add(orderInfo);
    }

    public List<InvoiceConfirmRequest.OrderInfoDTO> getOrderInfoDTO() {
        return orderInfoDTO;
    }

    public InvoiceConfirmRequest.ApplyForInvoiceReqDTO getApplyForInvoiceReqDTO() {
        return applyForInvoiceReqDTO;
    }
}
