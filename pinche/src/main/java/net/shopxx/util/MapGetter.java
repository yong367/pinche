package net.shopxx.util;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 提供从Map中获取指定类型数据的功能
 */
public class MapGetter {

	@SuppressWarnings("unchecked")
	public static int getInt(Map map, String key){
		if(null == map){
			map = new HashMap<>();
		}
		try{
			return (Integer)map.get(key);
		}catch(Exception e){}
		
		return 0;
	}
	
	@SuppressWarnings("unchecked")
	public static int getInt(Map map, String key, int defaultValue){
		if(null == map){
			map = new HashMap<>();
		}
		try{
			return (Integer)map.get(key);
		}catch(Exception e){}
		
		return defaultValue;
	}
	
	@SuppressWarnings("unchecked")
	public static String getString(Map map, String key){
		if(null == map){
			map = new HashMap<>();
		}
		try{
			String reValue = "";
			Object objValue=map.get(key);
			if(null == objValue){
				return reValue;
			}
			
			if(objValue instanceof String){
				reValue = (String) objValue;
			}else
			if(objValue instanceof Integer){
				reValue = String.valueOf(((Integer) objValue).intValue());
			}else{
				reValue = objValue.toString();
			}
				
			return reValue;
		}catch(Exception e){
			 e.printStackTrace();
		}
		
		return "";
	}
	
	@SuppressWarnings("unchecked")
	public static Date getDate(Map map, String key){
		if(null == map){
			map = new HashMap<>();
		}
		try{
			return (Date)map.get(key);
		}catch(Exception e){}
		
		return null;
	}
	
	/**
	 * 转double
	 * DSH
	 * @param map
	 * @param key
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static double getDouble(Map map, String key){
		if(null == map){
			map = new HashMap<>();
		}
		try{
			return (Double)map.get(key);
		}catch(Exception e){}
		
		return 0.0;
	}
	/**
	 * 转BigDecimal
	 * DSH
	 * @param map
	 * @param key
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static BigDecimal getBigDecimal(Map map, String key){
		if(null == map){
			map = new HashMap<>();
		}
		try{
			return (BigDecimal)map.get(key);
		}catch(Exception e){}
		
		return new BigDecimal(0);
	}
}
