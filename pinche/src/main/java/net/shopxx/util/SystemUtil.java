package net.shopxx.util;


import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicInteger;

public class SystemUtil {
	private static AtomicInteger internalOrderId = new AtomicInteger();

	public static String genOrderId() {
		String datetime = getStandardtime();
		String snString = "";
		snString = String.valueOf((internalOrderId.incrementAndGet()) % 1000000).replaceAll("-", "");

		int length = snString.length();
		for (int i = 0; i < 6 - length; i++) {
			snString = "0" + snString;
		}
		return datetime + snString;
	}

	public static String getStandardtime() {
		LocalDateTime date = LocalDateTime.now();
		DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

		return date.format(format);
	}
}
