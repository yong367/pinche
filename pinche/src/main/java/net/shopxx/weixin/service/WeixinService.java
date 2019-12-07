package net.shopxx.weixin.service;

import me.chanjar.weixin.common.exception.WxErrorException;
import me.chanjar.weixin.mp.api.WxMpInMemoryConfigStorage;
import me.chanjar.weixin.mp.api.WxMpMessageRouter;
import me.chanjar.weixin.mp.api.impl.WxMpServiceImpl;
import me.chanjar.weixin.mp.bean.kefu.result.WxMpKfOnlineList;
import me.chanjar.weixin.mp.bean.message.WxMpXmlMessage;
import me.chanjar.weixin.mp.bean.message.WxMpXmlOutMessage;
import net.sf.json.JSONObject;
import net.shopxx.service.LogPrintService;
import net.shopxx.util.WebUtils;
import net.shopxx.weixin.config.WxMpConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;

import static com.aliyun.oss.common.utils.HttpUtil.urlEncode;

/**
 * 
 * @author Binary Wang
 *
 */
@Service
public class WeixinService extends WxMpServiceImpl {

    @Inject
    private LogPrintService logPrintService;



  @Autowired
  private WxMpConfig wxConfig;



  private WxMpMessageRouter router;

  @PostConstruct
  public void init() {
    final WxMpInMemoryConfigStorage config = new WxMpInMemoryConfigStorage();
    config.setAppId(this.wxConfig.getAppid());// 设置微信公众号的appid
    config.setSecret(this.wxConfig.getAppsecret());// 设置微信公众号的app corpSecret
    config.setToken(this.wxConfig.getToken());// 设置微信公众号的token
    config.setAesKey(this.wxConfig.getAesKey());// 设置消息加解密密钥
    super.setWxMpConfigStorage(config);

  }

  public WxMpXmlOutMessage route(WxMpXmlMessage message) {
    try {
      return this.router.route(message);
    } catch (Exception e) {
      this.logPrintService.printServerLog(e.getMessage());
    }

    return null;
  }

  public boolean hasKefuOnline() {
    try {
      WxMpKfOnlineList kfOnlineList = this.getKefuService().kfOnlineList();
      return kfOnlineList != null && kfOnlineList.getKfOnlineList().size() > 0;
    } catch (Exception e) {
      logPrintService.printServerLog("获取客服在线状态异常: " + e.getMessage());
    }

    return false;
  }

      /**
       * 验证签名
       *
       * @param signature
       * @param timestamp
       * @param nonce
       * @return
       */
      public boolean checkSignature(String signature, String timestamp, String nonce) {
        String[] arr = new String[] { this.wxConfig.getToken(), timestamp, nonce };
        // 将token、timestamp、nonce三个参数进行字典序排序
        // Arrays.sort(arr);
        sort(arr);
        StringBuilder content = new StringBuilder();
        for (int i = 0; i < arr.length; i++) {
          content.append(arr[i]);
        }
        MessageDigest md = null;
        String tmpStr = null;

        try {
          md = MessageDigest.getInstance("SHA-1");
          // 将三个参数字符串拼接成一个字符串进行sha1加密
          byte[] digest = md.digest(content.toString().getBytes());
          tmpStr = byteToStr(digest);
        } catch (NoSuchAlgorithmException e) {
         logPrintService.printServerLog("签名验证失败: " + e.getMessage());
        }
        content = null;
        // 将sha1加密后的字符串可与signature对比，标识该请求来源于微信
        return tmpStr != null ? tmpStr.equals(signature.toUpperCase()) : false;
      }

    /**
     *
     * @param seconds 过期时间
     * @param sceneId 二维码参数
     * @return
     * @throws UnsupportedEncodingException
     */
    public  String getQr(Long sceneId,int seconds)  {
          //获取ticket
            JSONObject json = new JSONObject();
            Map<String,Long> intMap = new HashMap<String,Long>();
            intMap.put("scene_id",sceneId);
            Map<String,Map<String,Long>> mapMap = new HashMap<String,Map<String,Long>>();
            mapMap.put("scene", intMap);

            json.put("action_info",  JSONObject.fromObject(mapMap));//自定义参数
            json.put("expire_seconds",seconds);//临时二维码过期参数
            json.put("action_name","QR_SCENE");//二维码类别
            JSONObject jsonObjectT=null;

            try {
                jsonObjectT = JSONObject.fromObject(WebUtils.postJson("https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token="+getAccessToken(),json.toString()));
            } catch (WxErrorException e) {
               logPrintService.printServerLog("获取accessToken失败: " + e.getMessage());
            }
          Map<String, Object> ticketMap = (Map<String, Object>)jsonObjectT;

          //String url=WebUtils.get("https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket="+URLEncoder.encode(ticketMap.get("ticket").toString(), "utf-8"), null);由于返回图片无法解析成url，所以直接调用以下方法
          //根据ticket获取Url
          Map<String,String> params = new TreeMap<String,String>();
          String newSHOW_QRCODE_PATH="";
          try {
            params.put("ticket", URLEncoder.encode(ticketMap.get("ticket").toString(), "utf-8"));
            newSHOW_QRCODE_PATH= setParmas(params, "https://mp.weixin.qq.com/cgi-bin/showqrcode","");
            } catch (Exception e) {
              logPrintService.printServerLog("获取二维码失败: " + e.getMessage());
          }
             return newSHOW_QRCODE_PATH;
        }
        /**
         * 设置参数
         *
         * @param map
         *            参数map
         * @param path
         *            需要赋值的path
         * @param charset
         *            编码格式 默认编码为utf-8(取消默认)
         * @return 已经赋值好的url 只需要访问即可
         */
        public static String setParmas(Map<String, String> map, String path, String charset) throws Exception {
          String result = "";
          boolean hasParams = false;
          if (path != null && !"".equals(path)) {
            if (map != null && map.size() > 0) {
              StringBuilder builder = new StringBuilder();
              Set<Map.Entry<String, String>> params = map.entrySet();
              for (Map.Entry<String, String> entry : params) {
                String key = entry.getKey().trim();
                String value = entry.getValue().trim();
                if (hasParams) {
                  builder.append("&");
                } else {
                  hasParams = true;
                }
                if(charset != null && !"".equals(charset)){
                  //builder.append(key).append("=").append(URLDecoder.(value, charset));
                  builder.append(key).append("=").append(urlEncode(value, charset));
                }else{
                  builder.append(key).append("=").append(value);
                }
              }
              result = builder.toString();
            }
          }
          return doUrlPath(path, result).toString();
        }

        /**
         * 设置连接参数
         *
         * @param path
         *            路径
         * @return
         */
        private static URL doUrlPath(String path, String query) throws Exception {
          URL url = new URL(path);
          if (org.apache.commons.lang.StringUtils.isEmpty(path)) {
            return url;
          }
          if (org.apache.commons.lang.StringUtils.isEmpty(url.getQuery())) {
            if (path.endsWith("?")) {
              path += query;
            } else {
              path = path + "?" + query;
            }
          } else {
            if (path.endsWith("&")) {
              path += query;
            } else {
              path = path + "&" + query;
            }
          }
          return new URL(path);
        }



  /**
       * 将字节数组转换为十六进制字符串
       *
       * @param byteArray
       * @return
       */
      private static String byteToStr(byte[] byteArray) {
        String strDigest = "";
        for (int i = 0; i < byteArray.length; i++) {
          strDigest += byteToHexStr(byteArray[i]);
        }
        return strDigest;
      }

      /**
       * 将字节转换为十六进制字符串
       *
       * @param mByte
       * @return
       */
      private static String byteToHexStr(byte mByte) {
        char[] Digit = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
        char[] tempArr = new char[2];
        tempArr[0] = Digit[(mByte >>> 4) & 0X0F];
        tempArr[1] = Digit[mByte & 0X0F];
        String s = new String(tempArr);
        return s;
      }
      public static void sort(String a[]) {
        for (int i = 0; i < a.length - 1; i++) {
          for (int j = i + 1; j < a.length; j++) {
            if (a[j].compareTo(a[i]) < 0) {
              String temp = a[i];
              a[i] = a[j];
              a[j] = temp;
            }
          }
        }
      }


    /**
     * XML格式字符串转换为Map
     *
     * @param strXML XML字符串
     * @return XML数据转换后的Map
     * @throws Exception
     */
    public  Map<String, String> xmlToMap(String strXML) throws Exception {
        try {
            Map<String, String> data = new HashMap<>();
            DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
            InputStream stream = new ByteArrayInputStream(strXML.getBytes("UTF-8"));
            org.w3c.dom.Document doc = documentBuilder.parse(stream);
            doc.getDocumentElement().normalize();
            NodeList nodeList = doc.getDocumentElement().getChildNodes();
            for (int idx = 0; idx < nodeList.getLength(); ++idx) {
                Node node = nodeList.item(idx);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    org.w3c.dom.Element element = (org.w3c.dom.Element) node;
                    data.put(element.getNodeName(), element.getTextContent());
                }
            }
            try {
                stream.close();
            } catch (Exception ex) {
                // do nothing
            }
            return data;
        } catch (Exception ex) {
            logPrintService.printServerLog("无法将xml数据转换为map: " + ex.getMessage());
            throw ex;
        }
    }

    /**
     * 将Map转换为XML格式的字符串
     *
     * @param data Map类型数据
     * @return XML格式的字符串
     * @throws Exception
     */
    public  String mapToXml(Map<String, String> data) throws Exception {
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder= documentBuilderFactory.newDocumentBuilder();
        org.w3c.dom.Document document = documentBuilder.newDocument();
        org.w3c.dom.Element root = document.createElement("xml");
        document.appendChild(root);
        for (String key: data.keySet()) {
            String value = data.get(key);
            if (value == null) {
                value = "";
            }
            value = value.trim();
            org.w3c.dom.Element filed = document.createElement(key);
            filed.appendChild(document.createTextNode(value));
            root.appendChild(filed);
        }
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        DOMSource source = new DOMSource(document);
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        transformer.transform(source, result);
        String output = writer.getBuffer().toString(); //.replaceAll("\n|\r", "");
        try {
            writer.close();
        } catch (Exception ex) {
            ex.printStackTrace();
            logPrintService.printServerLog("无法将Map数据转换为Xml: " + ex.getMessage());
        }
        return output;
    }

    public Map<String, String> handlePublicMsg(HttpServletRequest request) throws Exception {
        // 获得微信端返回的xml数据
        InputStream is = null;
        InputStreamReader isr = null;
        BufferedReader br = null;
        try {
            is = request.getInputStream();
            isr = new InputStreamReader(is, "utf-8");
            br = new BufferedReader(isr);
            String str = null;
            StringBuffer returnXml = new StringBuffer();
            while ((str = br.readLine()) != null) {
                //返回的是xml数据
                returnXml.append(str);
            }
            Map<String, String> encryptMap = xmlToMap(returnXml.toString());
            // 得到公众号传来的加密信息并解密,得到的是明文xml数据


            // 区分消息类型
            String msgType = encryptMap.get("MsgType");
            // 普通消息
            if ("text".equals(msgType)) { // 文本消息
                // todo 处理文本消息
            } else if ("image".equals(msgType)) { // 图片消息
                // todo 处理图片消息
            } else if ("voice".equals(msgType)) { //语音消息
                // todo 处理语音消息
            } else if ("video".equals(msgType)) { // 视频消息
                // todo 处理视频消息
            } else if ("shortvideo".equals(msgType)) { // 小视频消息
                // todo 处理小视频消息
            } else if ("location".equals(msgType)) { // 地理位置消息
                // todo 处理地理位置消息
            } else if ("link".equals(msgType)) { // 链接消息
                // todo 处理链接消息
            }
            // 事件推送
            else if ("event".equals(msgType)) { // 事件消息
                // 区分事件推送
                String event = encryptMap.get("Event");
                if ("subscribe".equals(event)) { //订阅事件  或 未关注扫描二维码事件
                    if(null!=encryptMap.get("EventKey")){
                        return encryptMap;
                    }
                } else if ("unsubscribe".equals(event)) { // 取消订阅事件
                    // todo 处理取消订阅事件
                } else if ("SCAN".equals(event)) { // 已关注扫描二维码事件
                    if(null!=encryptMap.get("EventKey")){
                        return encryptMap;
                    }
                } else if ("LOCATION".equals(event)) { // 上报地理位置事件
                    // todo 处理上报地理位置事件
                } else if ("CLICK".equals(event)) { // 点击菜单拉取消息时的事件推送事件
                    // todo 处理点击菜单拉取消息时的事件推送事件
                } else if ("VIEW".equals(event)) { // 点击菜单跳转链接时的事件推送
                    // todo 处理点击菜单跳转链接时的事件推送
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logPrintService.printServerLog("处理微信公众号请求信息，失败"+e.getMessage());
        } finally {
            if (null != is) {
                is.close();
            }
            if (null != isr) {
                isr.close();
            }
            if (null != br) {
                br.close();
            }
        }
        return null;
    }
}
