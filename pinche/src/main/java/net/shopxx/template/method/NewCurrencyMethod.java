/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.template.method;

import freemarker.template.SimpleScalar;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModelException;
import net.shopxx.Setting;
import net.shopxx.util.FreeMarkerUtils;
import net.shopxx.util.SystemUtils;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;

/**
 * 模板方法 - 货币格式化
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component
public class NewCurrencyMethod implements TemplateMethodModelEx {

	/**
	 * 执行
	 * 
	 * @param arguments
	 *            参数
	 * @return 结果
	 */
	@SuppressWarnings("rawtypes")
	public Object exec(List arguments) throws TemplateModelException {
		BigDecimal amount = FreeMarkerUtils.getArgument(0, BigDecimal.class, arguments);
		String part = FreeMarkerUtils.getArgument(1, String.class, arguments);
		if (amount != null) {
			String amountStr=amount.toString();
			if("one".equals(part)){
				if(amountStr.indexOf(".")>0){
					return amountStr.substring(0,amountStr.indexOf("."));
				}
			}else{
				if(amountStr.indexOf(".")>0){
//					String newStr=amountStr.substring(amountStr.indexOf("."),amountStr.length());
					return amountStr.substring(amountStr.indexOf("."),amountStr.indexOf(".")+3);
				}else{
					return ".00";
				}
			}
		}
		return null;
	}

}