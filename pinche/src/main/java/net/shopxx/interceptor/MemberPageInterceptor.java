package net.shopxx.interceptor;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class MemberPageInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {
        /*if(modelAndView!=null){
        String name=modelAndView.getViewName();
            if(StringUtils.isNotEmpty(name)){
                if(!name.startsWith("redirect:")){
                    if(!name.startsWith("/mobile")){
                        if(!name.startsWith("/")){
                            modelAndView.setViewName("/mobile/"+name);
                        }else{
                            modelAndView.setViewName("/mobile"+name);
                        }
                    }
                }
            }
        }*/
    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
