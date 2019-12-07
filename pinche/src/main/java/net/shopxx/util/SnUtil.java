package net.shopxx.util;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class SnUtil {
	private static Integer sn = 1;
	private static Integer tradeNumber = 1;
	private static Integer orderNumber = 1;
	private static Integer orderId = 1;
	private static Integer paymentNumber = 1;
	private static Integer directPayTradeNo = 1;
	private static Map<String, Integer> idMap = new HashMap<String, Integer>();
	static{
		idMap.put("sn", sn);
		idMap.put("tradeNumber", tradeNumber);
		idMap.put("orderNumber", orderNumber);
		idMap.put("paymentNumber", paymentNumber);
		idMap.put("directPayTradeNo", directPayTradeNo);
	}
	public static String genPaymentSn(){
		/*
		String datetime = DateCollect.getStandardtime().replaceAll("-", "").replace(" ", "").replace(":", "");
		String snString = "";
		synchronized (sn) {
			snString = String.valueOf((sn++)%1000000);
		}
		
		int length = snString.length();
		for(int i=0;i<6-length;i++){
			snString="0"+snString;
		}
		return datetime+snString;
		*/
		return genNumber("sn");
	}
	public static void main(String[] ar){
		for(int i=0;i<100000;i++){
			String str = SnUtil.genPaymentSn();
			if(i==0||i==9999)
			System.out.println(str);
		}
	}
	public static String genVerificationSn(){
		String datetime = DateCollect.getStandardtime().replaceAll("-", "").replace(" ", "").replace(":", "");
		String snString = "";
		synchronized (tradeNumber) {
			snString = String.valueOf((tradeNumber++)%1000000);
		}
		
		int length = snString.length();
		for(int i=0;i<6-length;i++){
			snString="0"+snString;
		}
		return datetime+snString;
	}
	public static String genOrderNumber(){
		String datetime = DateCollect.getStandardtime().replaceAll("-", "").replace(" ", "").replace(":", "");
		String snString = "";
		synchronized (orderNumber) {
			snString = String.valueOf((orderNumber++)%1000000);
		}
		
		int length = snString.length();
		for(int i=0;i<6-length;i++){
			snString="0"+snString;
		}
		return datetime+snString;
	}
	
	public static String genOrderId(){
		String datetime = DateCollect.getStandardtime().replaceAll("-", "").replace(" ", "").replace(":", "");
		String snString = "";
		synchronized (orderId) {
			snString = String.valueOf((orderId++)%1000000);
		}
		
		int length = snString.length();
		for(int i=0;i<6-length;i++){
			snString="0"+snString;
		}
		return datetime+snString;
	}
	
	public static String getExchangeCode(String typeNo){
		Random random = new Random();
		int random1 = random.nextInt(899);
		random1 += 100;
		int random2 = random.nextInt(89);
		random2 += 10;
		int random3 = random2*1000+random1;
		String datetime = DateCollect.getDateSimpleString();
		return datetime+typeNo+Integer.toString((random1^random2)%10)+random1+(random2^random3)%10+random2;
	}
	
	public static String getPartnerCode(){
		Random random = new Random();
		int random1 = random.nextInt(899999);
		random1 += 100000;
		String datetime = DateCollect.getDateSimpleString();
		return datetime+random1;
	}
	
	public static boolean checkExchangeCode(String number,String typeNo){
		
		if(null == number || number.length()<14){
			return false;
		}
		if(!typeNo.equals(number.substring(6, 7))){
			return false;
		}
		int random1 = Integer.parseInt(number.substring(8, 11));
		int random2 = Integer.parseInt(number.substring(12, 14));
		int random3 = random2*1000+random1;
		if((random1^random2)%10 == Integer.parseInt(number.substring(7, 8))  
			&& 	(random2^random3)%10 == Integer.parseInt(number.substring(11, 12))
			){
			return true;
		}
		return false;
	}
	
	private static String genNumber(String type){
		String datetime = DateCollect.getStandardtime().replaceAll("-", "").replace(" ", "").replace(":", "");
		String snString = "";
		Integer number = idMap.get(type);
		synchronized (number) {
			snString = String.valueOf((number++)%1000000);
		}
		
		int length = snString.length();
		for(int i=0;i<6-length;i++){
			snString="0"+snString;
		}
		return datetime+snString;
	}
	
	public static String genDirectPayTradeNo(){
		return genNumber("directPayTradeNo");
	}
}
