package net.shopxx.component;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayFundTransOrderQueryRequest;
import com.alipay.api.request.AlipayFundTransToaccountTransferRequest;
import com.alipay.api.response.AlipayFundTransOrderQueryResponse;
import com.alipay.api.response.AlipayFundTransToaccountTransferResponse;
import net.sf.json.JSONObject;
import net.shopxx.entity.AppliCash;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.service.AppliCashService;
import net.shopxx.service.MemberService;
import net.shopxx.util.JsonUtils;
import net.shopxx.util.SystemUtil;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@Component
public class AlipayCashComponent {

    //支付宝网关
    private static String serverIrl = "";
    //appid
    private static String appid = "";
    //支付宝私钥
    private static String privateKey = "";
    //支付宝公钥
    private static String publicKey = "";
    @Inject
    private MemberService memberService;
    @Inject
    private AppliCashService appliCashService;

    /**
     * 申请提现
     * @param appliCash
     * @param member
     */
    public void applyCash(AppliCash appliCash, Member member) {

        Assert.notNull(appliCash);
        Assert.notNull(member);
        Assert.isTrue(appliCash.getAmount().compareTo(BigDecimal.ZERO) > 0);
        appliCash.setOrderId(SystemUtil.genOrderId());
        appliCash.setCashMethod(AppliCash.cashMethod.alipayCash);
        appliCash.setMember(member);
        //调支付宝之前先扣款
        memberService.addBalance(appliCash.getMember(), appliCash.getAmount().negate(), MemberDepositLog.Type.cash,"申请提现");
        processAlipayCash(appliCash, AppliCash.Status.PROCESSING,null,null,null,null);
    }

    /**
     * 进行提现
     * @param appliCash
     * @return
     */
    public Map applyCashTransfer(AppliCash appliCash) {
        Map<String,String> resultMap = new HashMap<>();
        try {
            AlipayClient alipayClient = new DefaultAlipayClient(serverIrl,appid,privateKey,"json","UTF-8",publicKey,"RSA2");
            AlipayFundTransToaccountTransferRequest request = new AlipayFundTransToaccountTransferRequest();
            request.setBizContent("{ \"out_biz_no\":\"" + appliCash.getOrderId() +"\", \"payee_type\":\"ALIPAY_LOGONID\",  \"payee_account\": \"" + appliCash.getAccount() + "\", \"amount\":\"" + appliCash.getTransferAmount() +"\", \"remark\":\"支付宝提现\" }");
            AlipayFundTransToaccountTransferResponse response = null;
            response = alipayClient.execute(request);

            String data = response.getBody();
            JSONObject jsonObject = JsonUtils.toObject(data, JSONObject.class).getJSONObject("alipay_fund_trans_toaccount_transfer_response");
            //returnMsg = jsonObject.getString("sub_msg");
            if(response.isSuccess()){
                System.out.println("调用成功");
                String msg = jsonObject.getString("msg");
                resultMap.put("msg",msg);
                processAlipayCash(appliCash, AppliCash.Status.SUCCESS,msg,jsonObject.getString("code"),null,null);
            } else {
                System.out.println("调用失败");
                memberService.addBalance(appliCash.getMember(),appliCash.getAmount(), MemberDepositLog.Type.cashRefunds,"提现退款");
                String subMsg = jsonObject.getString("sub_msg");
                String msg = jsonObject.getString("msg");
                processAlipayCash(appliCash,AppliCash.Status.FAILED,msg,jsonObject.getString("code"),subMsg,jsonObject.getString("sub_code"));
                resultMap.put("subMsg",subMsg);
                resultMap.put("msg",msg);
                //调用查询接口
                orderSearch(appliCash);
            }

        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        //resultMap.put("returnMsg",returnMsg);
        return resultMap;
    }
    
    
    private void processAlipayCash(AppliCash appliCash, AppliCash.Status status, String returnMsg, String returnCode,String subMsg,String subCode){
        appliCash.setStatus(status);
        appliCash.setReturnCode(returnCode);
        appliCash.setReturnMsg(returnMsg);
        appliCash.setSubMsg(subMsg);
        appliCash.setSubCode(subCode);
        appliCashService.update(appliCash);
    }

    /**
     * 失败后查询订单
     * @param appliCash
     */
    public void orderSearch(AppliCash appliCash) {

        try {
            AlipayClient alipayClient = new DefaultAlipayClient(serverIrl,appid,privateKey,"json","UTF-8",publicKey,"RSA2");
            AlipayFundTransOrderQueryRequest request = new AlipayFundTransOrderQueryRequest();
            request.setBizContent("{ \"out_biz_no\":\"" + appliCash.getOrderId() + "}");
            AlipayFundTransOrderQueryResponse response = null;
            response = alipayClient.execute(request);

            String data = response.getBody();
            JSONObject jsonObject = JsonUtils.toObject(data, JSONObject.class).getJSONObject("alipay_fund_trans_order_query_response");
            if(response.isSuccess()){
                System.out.println("查询成功");
                System.out.println(jsonObject);
                //processAlipayCash(alipayCash, AlipayCash.Status.SUCCESS,jsonObject.getString("sub_msg"),jsonObject.getString("code"));
            } else {
                System.out.println("查询失败");
                System.out.println(jsonObject);
                //memberService.addBalance(alipayCash.getMember(),alipayCash.getAmount(), MemberDepositLog.Type.cashRefunds,"提现退款");
                //processAlipayCash(alipayCash,AlipayCash.Status.FAILED,jsonObject.getString("sub_msg"),jsonObject.getString("code"));
            }
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
    }


}
