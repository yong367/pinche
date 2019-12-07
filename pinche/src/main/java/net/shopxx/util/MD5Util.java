package net.shopxx.util;

import java.security.MessageDigest;

public class MD5Util {
	public static String md5Encode(String inStr){
		try{
			MessageDigest md5 = null;
			md5 = MessageDigest.getInstance("MD5");
			byte[] byteArray = inStr.getBytes("UTF-8");
			return hexToString(md5.digest(byteArray));
		}catch (Exception e){
		return "";
		}

	}
	
	public static String hexToString(byte[] bytes){
		StringBuffer hexValue = new StringBuffer();
	    for (int i = 0; i < bytes.length; i++) {
	        int val = ((int) bytes[i]) & 0xff;
	        if (val < 16) {
	            hexValue.append("0");
	        }
	        hexValue.append(Integer.toHexString(val));
	    }
	    return hexValue.toString();
	}

	public static void main(String[] args) throws Exception {
		String str="card_info=MTdkYmVlNjdiYjRlM2MyYTlmNWZiNGZmZjA3YjBmNjI0NmNiNGRhN2ZkMzllNGM4&channel_id=9&client_iP=192.168.0.1&ext=test&is_sdk=0&mch_id=1638&notify_url=http://www.dsq521.cn:15527/gatewaycardpaycallback.jsp&order_id=20180503103001000001&pay_amount=0&pay_type=1&remark=test&ts=1525314601911&key=289986dad60b41188b2e0cd2b1ebae7f";
				/*String str="card_info=NWRkNjRlZWM3ZmE1YjMyMDVmZGZkZmQ2Y2JiMWRkOTQ5M2FjNjY3OTU5NGYxYmEzZDlmYzM2MzM2" +
				"MmIwZGUwNA==&channel_id=9&client_iP=192.168.0.1&ext=test&is_sdk=0&mch_id=1638&notify_url=http://www.dsq521.cn:15527/gatewaycardpaycallback.jsp&order_id=20180503093550000001&pay_amount=10&pay_type=1&remark=test&ts=1525311350992&key=289986dad60b41188b2e0cd2b1ebae7f";
		*/
		System.out.println(MD5Util.md5Encode(str).toUpperCase());
	}
}
