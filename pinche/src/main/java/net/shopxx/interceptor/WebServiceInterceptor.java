package net.shopxx.interceptor;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * WEb 服务接口安全验证
 */
public class WebServiceInterceptor extends HandlerInterceptorAdapter {

    private final static String VALID_IPS = "59.110.31.70,127.0.0.1";

    /**
     * 验证请求是否安全
     * @param request
     * @param response
     * @param handler
     * @return
     * @throws Exception
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String address = request.getRemoteAddr();
        System.out.println("当前请求用户注册服务接口的远程地址是："+address);
        return true;
    }
}
