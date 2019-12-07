package net.shopxx.component;

import net.shopxx.plugin.LoginPlugin;
import net.shopxx.service.PluginService;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.stereotype.Component;
import javax.inject.Inject;
import java.io.IOException;
import java.net.URLEncoder;

@Component
public class PcWeiXinComponent {
    private static final String WEI_XIN_SERVER_URL="https://open.weixin.qq.com";
    private static final String REDIRECT_URL="http://www.lifeabb.com:8080/shop";

    @Inject
    private PluginService pluginService;

    public String getLoginQrcodeUrl(){
        try {
          LoginPlugin loginPlugin= pluginService.getLoginPlugin("weixinLoginPlugin");
        HttpClient httpClient =  HttpClients.createDefault();//创建httpClient对象
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(5000)//一、连接超时：connectionTimeout-->指的是连接一个url的连接等待时间
                .setSocketTimeout(5000)// 二、读取数据超时：SocketTimeout-->指的是连接上一个url，获取response的返回等待时间
                .setConnectionRequestTimeout(5000)
                .build();
        HttpGet httpget = new HttpGet(WEI_XIN_SERVER_URL+"/connect/qrconnect?appid="+loginPlugin.getAttribute("appId")+"&redirect_uri="+ URLEncoder.encode(REDIRECT_URL,"UTF-8")+"&response_type=code&scope=snsapi_login&state=STATE#wechat_redirect");//以get方式请求该URL
            HttpResponse response = httpClient.execute(httpget);
        String body="";
        if (response.getStatusLine().getStatusCode() == 200) {
            HttpEntity resEntity = response.getEntity();
            body = EntityUtils.toString(resEntity, "utf-8");
            System.out.println(body);
        } else {
            System.out.println("请求失败");
        }
        Document doc = Jsoup.parse(body, "");
        Element element= doc.select("img.qrcode.lightBorder").get(0);
        String value=element.attr("src");
        return WEI_XIN_SERVER_URL+ value;
        } catch (IOException e) {
            return null;
        }
    }
}
