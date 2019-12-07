package net.shopxx.audit;

import java.lang.annotation.*;

/**
 * 更细缓存奖品aop
 *
 * @Author zhangmengfei
 * @Date 2019-10-17 - 15:10
 */
@Inherited
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
public @interface Prizeupdate {

}
