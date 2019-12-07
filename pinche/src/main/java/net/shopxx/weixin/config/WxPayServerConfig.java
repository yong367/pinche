package net.shopxx.weixin.config;

import org.springframework.stereotype.Component;

/**
 * 
 * 微信商户的配置
 *
 */
@Component
public class WxPayServerConfig {

  private String token ="";
  //微信appid
  private String appid="";
  //38c17e12c46dd8da313e4d0501b12b82
  private String appsecret="";

  private String aesKey="";
  //微信商户id
  private String MerchantId = "";
  //微信商户秘钥
  private String MerchantKey = "";
  //证书路径
  private String SslcertPath = "";
  
  public String getToken() {
    return this.token;
  }

  public String getAppid() { return this.appid; }

  public String getAppsecret() {
    return this.appsecret;
  }

  public String getAesKey() {
    return this.aesKey;
  }

  public String getMerchantId() { return this.MerchantId; }

  public String getMerchantKey() { return this.MerchantKey; }

  public String getSslcertPath() { return this.SslcertPath; }

 // public String getOpenId() { return this.openId; }
}
