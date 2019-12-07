package net.shopxx.weixin.config;

import org.springframework.stereotype.Component;

/**
 * 
 * @author Binary Wang
 *
 */
@Component
public class WxMpConfig {

  private String token ="";

  private String appid="";

  private String appsecret="";

  private String aesKey="";

  public String getToken() {
    return this.token;
  }

  public String getAppid() {
    return this.appid;
  }

  public String getAppsecret() {
    return this.appsecret;
  }

  public String getAesKey() {
    return this.aesKey;
  }

}
