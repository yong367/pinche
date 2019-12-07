package net.shopxx.util;


import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

public class PassWordUtil {
	private static AtomicInteger internalOrderId = new AtomicInteger();

	public static final String generatePwd() {
		String password = UUID.randomUUID().toString();
		password = password.replace("-", "");
		return password;
	}

}
