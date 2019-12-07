package net.shopxx.suning;

public class SuNingConfig {
    //正式环境
    // 测试环境 http://openpre.cnsuning.com/api/http/sopRequest
    public final static String serverUrl="http://openpre.cnsuning.com/api/http/sopRequest";
    public final  static String appKey ="0725e09078c50c8d89892b0c03bfd101";
    public final  static String appSecret ="8a3266f1bb2d2131a348f28ba9f3df54";
    public final static String  dataFormat ="json";
    public final static boolean checkParam =true;//是否开启检查参数，如果是正式环境 需要设置为false
}
