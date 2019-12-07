package net.shopxx.plugin.unicomPayment;

import com.sinovatech.unicom.util.sign.CryptUtil;
import com.sinovatech.unicom.util.sign.PayRequestBean;
import com.sinovatech.unicom.util.sign.PayResponseBean;
import com.sinovatech.unicom.util.sign.StoreCommon;
import net.shopxx.Setting;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.QueryOrderRefundStatusResponse;
import net.shopxx.plugin.QueryPayStatusResponse;
import net.shopxx.service.LogPrintService;
import net.shopxx.util.DateCollect;
import net.shopxx.util.SystemUtils;
import net.shopxx.util.UniPaySignUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * 联通沃钱包支付
 */
@Component("unicomPayMentPlugin")
public class UnicomPayMentPlugin extends PaymentPlugin {
    private static final String SIGNTYPE_RSA_SHA256 ="RSA_SHA256";

    @Inject
    private LogPrintService logPrintService;
    @Override
    public String getName() {
        return "联通沃钱包支付";
    }

    @Override
    public String getVersion() {
        return "1.0.0.0";
    }

    @Override
    public String getAuthor() {
        return "aiBangBan";
    }

    @Override
    public String getSiteUrl() {
        return "";
    }

    @Override
    public String getInstallUrl() {
        return "unicomPayMent/install";
    }

    @Override
    public String getUninstallUrl() {
        return "unicomPayMent/uninstall";
    }

    @Override
    public String getSettingUrl() {
        return "unicomPayMent/setting";
    }

    @Override
    public QueryPayStatusResponse queryPaySuccess(PaymentTransaction paymentTransaction) throws Exception {
        return null;
    }

    @Override
    public QueryOrderRefundStatusResponse queryOrderRefundSuccess(PaymentTransaction paymentTransaction) throws Exception {
        return null;
    }

    @Override
    public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
        Setting setting = SystemUtils.getSetting();
        PayRequestBean unicomRequest = new PayRequestBean();
        unicomRequest.setMerNo(getAttribute("partner"));
        unicomRequest.setVersion("3.0.0.0");
        unicomRequest.setSignType(SIGNTYPE_RSA_SHA256);
        unicomRequest.setGoodsName("爱帮伴");
        unicomRequest.setStoreOrderId(paymentTransaction.getSn());
        unicomRequest.setOrderBalance(String.valueOf(paymentTransaction.getAmount().multiply(new BigDecimal(100)).intValue()));
        unicomRequest.setPayBalance(String.valueOf(paymentTransaction.getAmount().multiply(new BigDecimal(100)).intValue()));
        unicomRequest.setWostoreTime(DateCollect.getDateStr(DateCollect.SDF_yyyyMMddHHmmss));
        unicomRequest.setRespMode("2");
        unicomRequest.setCallbackUrl(getPostPayUrl(paymentPlugin, paymentTransaction));
        unicomRequest.setServerCallUrl(setting.getSiteUrl()+"/notify/unicomCallBack_"+paymentTransaction.getSn());//需要增加对应的操作入口

        unicomRequest.setStoreIndex(setting.getSiteUrl()+"/member/order/list");
        unicomRequest.setStoreName("河北越蓝信息技术有限公司(移动收银台)");
        unicomRequest.setTradeMode("0001");
        Map<String, String> signParams = StoreCommon.toBeanMap(unicomRequest);
        String signStr = UniPaySignUtils.merSign(signParams,SIGNTYPE_RSA_SHA256);
        unicomRequest.setSignMsg(signStr);
        String encryptContent = CryptUtil.encryptBeanNokey(unicomRequest);
        logPrintService.printServerLog("sengTo unicom request param:{"+encryptContent+")");
        Map<String, String> parameterMap = new HashMap<>();
        parameterMap.put("param", unicomRequest.getMerNo()+encryptContent);
        modelAndView.addObject("parameterMap", parameterMap);
        modelAndView.addObject("requestUrl", " https://epay.10010.com/wappay3.0/httpservice/wapPayPageAction.do?reqcharset=UTF-8");
        modelAndView.addObject("requestMethod", "POST");
        modelAndView.setViewName(PaymentPlugin.DEFAULT_PAY_VIEW_NAME);
    }

    @Override
    public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String param = request.getParameter("param");
        logPrintService.printServerLog("recive unicom param body:{"+param+"}");
        PayResponseBean payResponseBean=CryptUtil.decryptBeanNoKey(param,PayResponseBean.class);
    String cert ="MIIDyDCCArKgAwIBAgIDTYtiMAsGCSqGSIb3DQEBCzBuMQswCQYDVQQGEwJDTjEO" +
            "MAwGA1UECAwFSklMSU4xEjAQBgNVBAcMCUNIQU5HQ0hVTjELMAkGA1UECgwCQ1Ux" +
            "DTALBgNVBAsMBENVQ0ExHzAdBgNVBAMMFkNISU5BIFVOSUNPTSBDTEFTUzMgQ0Ew" +
            "HhcNMTcwMzIwMDkzODI3WhcNMjcwMzIwMDkzODI3WjB1MQswCQYDVQQGEwJDTjEQ" +
            "MA4GA1UECAwHQmVpamluZzEQMA4GA1UEBwwHQmVpamluZzESMBAGA1UECgwJVW5p" +
            "Y29tcGF5MQswCQYDVQQLDAJJVDEhMB8GA1UEAwwY6IGU6YCa5pSv5LuY5pyJ6ZmQ" +
            "5YWs5Y+4MIIBIDALBgkqhkiG9w0BAQEDggEPADCCAQoCggEBAJxrCNAiExmPPJeM" +
            "/qc2yxRp4vnN3bMjOd++A9aUNhSlMYFSPJu3z+fEGXujN6K5/J1WPWrfjNcRYfnL" +
            "llEJkI0UcUm2mWo18mCmpSX0Qo56ugG0q3O3hFW9h+fehhs7Y4tfayW283OpOHV8" +
            "JRFRnS+X5eIoBD6izRXlsiPpsDiONZSBuQuE01e2rQBxi0InW2QJssiouPJXpVmy" +
            "LKPZ4VXuil73/vO8QZ+5wcqXnJZin1KXxVfLB8xeZEkskixUHZ6jVKUnPJvyAp61" +
            "FLJ+VKLJyUcsitarVExDBVZ46XBr++NpvHBNiZp/Gla9Esu9Cn5KJ9N/sJ6qBCdG" +
            "SrZzDvECAwEAAaNuMGwwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMB8G" +
            "A1UdIwQYMBaAFFRcGTiwWCJ60SqqE7S1hQgVYCt8MAsGA1UdDwQEAwIA8TAdBgNV" +
            "HQ4EFgQUB14HKxoU23yV5j/cuLlEaM4YS1swCwYJKoZIhvcNAQELA4IBAQBRNMoT" +
            "LzBJyUeunDkG5ZQMao1c2D4YYVfAhnL+H8s9K/Vi7E987c2Ga+8axkrNhxbATsLh" +
            "9RGExM2ObI8Y31dnE+KCmpIHxb8CrfWrh27FLCUE8ASF/zwZffZjjBseqwBC448p" +
            "T/ZE6s99yDibNBlEPhHpGSXRMwLy9rAPL68QAYV5tZBtCcI7vMKtowLYeMLMwxk1" +
            "b4DgEo5mCOelGjDBBvhWFq2sTfpxBxh4r84884MuQeSp0rFsZB21nV9tnAZPFucj" +
            "aZJPBAqEo1oKZxt/b4jrTGkxrtEHNf06g7Rt8JNHHbTQMXHmjvNBAHYjpcLqDVAx" +
            "jWuWv6upB9fiSPsx";
        Map<String, String> params = StoreCommon.toBeanMapResp(payResponseBean);
        Boolean result=UniPaySignUtils.merVerify(params, SIGNTYPE_RSA_SHA256, payResponseBean.getSignMsg(), cert);
        if(result){
            return payResponseBean.getPayResult().equals("1");
        }else{
            logPrintService.printServerLog("unicom param check sign error");
        }
        return false;
    }
}
