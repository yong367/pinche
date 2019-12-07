package net.shopxx.util;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Random;

public class DateCollect {
	private static Logger logger = LoggerFactory.getLogger(DateCollect.class);
	public static final SimpleDateFormat SDF_yyyyMMddHHmmssSSS = new SimpleDateFormat("yyyyMMddHHmmssSSS");
	public static final SimpleDateFormat SDF_yyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");
	public static final SimpleDateFormat SDF_yyyyMMdd = new SimpleDateFormat("yyyyMMdd");
	public static final SimpleDateFormat SDF_HHmmss = new SimpleDateFormat("HHmmss");
	public static final SimpleDateFormat SDF_VERSION1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public static final SimpleDateFormat SDF_VERSION2 = new SimpleDateFormat("yyyy-MM-dd");
	
	public static final String getDateStr(SimpleDateFormat sdf){
		return sdf.format(new Date());
	}
	
	public static final String getDateStr(Date date, SimpleDateFormat sdf){
		return sdf.format(date);
	}
	
	public static boolean isContains(String container, String[] regx) {
		boolean result = false;

		for (int i = 0; i < regx.length; i++) {
			if (container.indexOf(regx[i]) != -1) {
				return true;
			}
		}
		return result;
	}
	public static double round(double v, int scale) {
		String temp = "###0.";
		for (int i = 0; i < scale; i++) {
			temp += "0";
		}
		return Double.parseDouble(new DecimalFormat(temp).format(v));
	}
	/**
	 * 获取数字串日期
	 * @return
	 */
	public static String getDateString() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	/**
	 * 获取数字串日期
	 * @return
	 */
	public static String getDateSimpleString() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyMMdd");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	/**
	 * 获取数字串日期
	 * @return
	 */
	public static Date getCurrentDate() {
		Date date	=	new Date();
		
		return date;
	}
	
	/**
	 * 获取数字串日期
	 * @return
	 */
	public static Date getDateZero() {
		String nowString=getYMD();
		SimpleDateFormat dd=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date=null;
		try {
			date = dd.parse(nowString+" 00:00:00");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return date;
	}
	/**
	 * 获取标准日期字符串
	 * @return
	 */
	public static String getStandardtime() {
		//TimeZone tz = TimeZone.getTimeZone("ETC/GMT-8"); 
		//TimeZone.setDefault(tz); 
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	
	/**
	 * 获取标准日期字符串
	 * @return
	 */
	public static String getStandardtimeWithSSS() {
		//TimeZone tz = TimeZone.getTimeZone("ETC/GMT-8"); 
		//TimeZone.setDefault(tz); 
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	
	public static String ConvertToStandardtime(Date date) {
		//TimeZone tz = TimeZone.getTimeZone("ETC/GMT-8"); 
		//TimeZone.setDefault(tz); 
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	
	public static Timestamp convertToTimestamp(String timestamp){
		Timestamp result = null;
		try{
			result = Timestamp.valueOf(timestamp);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return  result;
	}
	
	public static Date getDateTime() throws ParseException {
		String dateStr = getStandardtime();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return format.parse(dateStr);
	}
	
	
	/**
	 * 获取年、月
	 * @return
	 */
	public static String getTime() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("HH:mm");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	/**
	 * 获取年、月、日
	 * @return
	 */
	public static String getYMD() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	/**
	 * 获取年、月、日(前一个月)
	 * @return
	 */
	public static String getBeforeD() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		String[] dArray=strDate.split("-");
		dArray[1]	=	String.valueOf(	Integer.parseInt(	dArray[1]	)-1	);
		if(	dArray[1].equals("0")	){
			dArray[1]	=	"12";
			dArray[0]	=	String.valueOf(	Integer.parseInt(	dArray[0]	)-1	);
		}else	if(	dArray[1].length()!=2	)
			dArray[1]	=	"0"+dArray[1];
		
		strDate	=	dArray[0]+"-"+dArray[1]+"-"+dArray[2];
		
		return strDate;
	}
	/**
	 * 获取年、月、日(当前日期的前一个星期)
	 * @return
	 */
	public static String getBeforeDay() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		String[] dArray=strDate.split("-");
		int year=Integer.parseInt	(	dArray[0]	);
		int mon	=Integer.parseInt	(	dArray[1]	);
		int day	=Integer.parseInt	(	dArray[2]	);//String.valueOf
		int i=day-7;
		if(	i<=0	)
		{
			 mon=Integer.parseInt(dArray[1])-1;
			 if(mon>0)
			 {
				 day=getDays(year,mon);
				 day=day+i;
			 }
			 else if(	mon==0	)
			 {
				mon		=	12		;
				year	=	year-1	;
				day		=	getDays(year,mon);
				day		=	day+i;
			 }	
			
		}
		else
		{
			day=i;
		}
		dArray[0]=String.valueOf(year);
		dArray[1]=String.valueOf(mon).length()==2?String.valueOf(mon):("0"+String.valueOf(mon));	
		dArray[2]=String.valueOf(day).length()==2?String.valueOf(day):("0"+String.valueOf(day));	
		
		strDate	=	dArray[0]+"-"+dArray[1]+"-"+dArray[2];
		
		return strDate;
	}
	/*
	 * 是闰年返回true 	366
	 * 是平年返回false 	365
	 * */
	public static boolean isLeapYear(int year)
	{
		boolean flag=false;
		if((year%4==0)&&(year%100==0)&&(year%400==0))
		{
			flag=true;
		}
		
			return flag;
	}
	/*
	 * 根据年,月得到天数
	 * */
	public static int getDays(int year,int mon)
	{
		
		int days=31;
		boolean flag=isLeapYear(year);
		if(flag)days=29;
		else days=28;
		switch(	mon	){
		case	4:days=30;
		break;
		case	6:days=30;
		break;
		case	9:days=30;
		break;
		case	11:days=30;
		break;
		}
		return days;
	}
	/**
	 * 获取年、月
	 * @return
	 */
	public static String getYM() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	
	/**
	 * 获取格式化的年、月、日
	 * @return
	 */
	public static String getFormatYMD(String ymd) {
		String year = "";
		String mod = "";
		String day = "";
		if(null!=ymd&ymd.length()>7)
		{
			 year=ymd.substring(0,4);
			 mod=ymd.substring(4,6);
			 day=ymd.substring(6,8);
		}
		
		return (year+"-"+mod+"-"+day);
	}
	
	public static int getFormatYMD2(String ymd) {
		String year = "";
		String mod = "";
		String day = "";
		if(null!=ymd&ymd.length()>=10)
		{
			 year=ymd.substring(0,4);
			 mod=ymd.substring(5,7);
			 day=ymd.substring(8,10);
		}
		
		return (Integer.parseInt(year+mod+day));
	}
	
	/**
	 * 获取年
	 * @return
	 */
	public static String getYear() {
		Date date	=	new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy");
		format.setLenient(false);
		if (date == null)
			return "";
		String strDate = format.format(date);
		return strDate;
	}
	
	public static String getCode() {
		Calendar calender = Calendar.getInstance();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmSSS");
		format.setLenient(false);
		String strResponseDate = format.format(calender.getTime());
		Random r = new Random(new Date().getTime());
		int rand = r.nextInt(100);
		String strrand = "" + rand;
		if (rand < 10)
			strrand = "0" + rand;
		//		String strip=request.getRemoteAddr();
		//		String strnip="";
		//		for(int i=0;i<strip.length();i++){
		//		   if (strip.charAt(i)!='.')strnip+=strip.charAt(i);
		//		}
		//		String endip=strnip.substring(strnip.length()-2,strnip.length());
		//		return strResponseDate+""+endip+""+strrand;
		return strResponseDate + "" + "" + strrand;
	}
	public static String getPer(String totalsize, String size) {
		String re = "";
		double d_totalsize = 0, d_size = 0, d_per;
		if (totalsize == null || "".equals(totalsize)) {
			totalsize = "0";
		}
		d_totalsize = Double.parseDouble(totalsize);
		if (size == null || "".equals(size)) {
			size = "0";
		}
		d_size = Double.parseDouble(size);
		d_per = round((d_size / d_totalsize) * 100, 2);
		re = String.valueOf(d_per) + "%";
		return re;
	}
	public static String htmlFilter(String message) {

		if (message == null || "".equals(message))
			return "";
		char content[] = new char[message.length()];
		message.getChars(0, message.length(), content, 0);
		StringBuffer result = new StringBuffer(content.length + 50);
		for (int i = 0; i < content.length; i++) {
			switch (content[i]) {
				case '<' :
					result.append("&lt;");
					break;
				case '>' :
					result.append("&gt;");
					break;
				case '&' :
					result.append("&amp;");
					break;
				case '"' :
					result.append("&quot;");
					break;
				default :
					result.append(content[i]);
			}
		}
		return (result.toString());
	}
	public static String dhtmlFilter(String message) {

		if (message == null || "".equals(message))
			return "";
		char content[] = new char[message.length()];
		message.getChars(0, message.length(), content, 0);
		StringBuffer result = new StringBuffer(content.length + 50);
		for (int i = 0; i < content.length; i++) {
			if('"'==content[i]){
				result.append("'");
				continue;
			}
			result.append(content[i]);
		}
		return (result.toString());
	}
	public static String newDateString(String arg) {
		if (arg == null)
			arg = "";
		String newString = "";
		String[] st = arg.split(" ");
		if (st.length > 0) {
			String[] st1 = (st[0]).split("-");
			if (st1.length > 0) {
				newString += st1[1] + "月" + st1[2] + "日";
			}
			newString += " ";
			String[] st2 = (st[1]).split(":");
			if (st2.length > 0) {
				newString += st2[0] + "时" + st2[1] + "分";
			}
		}
		return newString;
	}
	public static String mediaType(String arg) {
		if (arg == null)
			arg = "";
		String newString = "";
		String fileExt = "rar;zip;exe;doc;xls;chm;hlp=rm;mp3;wav;mid;midi;ra;avi;mpg;mpeg;asf;asx;wma;mov;rmi=swf=gif;jpg;jpeg;bmp";
		String[] st = fileExt.split("=");
		for(int i=0;i<st.length;i++){
			String[] sts = st[i].split(";");
			for(int j=0;j<sts.length;j++){
				if(arg.equals(sts[j])){
				switch (i) {
				  case 0 :
					  newString="file";
					  break;
				  case 1 :
					  newString="media";
					  break;
				  case 2 :
					  newString="flash";
					  break;
				  case 3 :
					  newString="image";
					  break; 
				 }
			   }
			}
		}
		return newString;
	}
	public static String getChineseDate() {
		GregorianCalendar c = new GregorianCalendar();
		String year = String.valueOf(c.get(Calendar.YEAR));
		String month = String.valueOf(c.get(Calendar.MONTH) + 1);
		if (c.get(Calendar.MONTH) < 9)
			month = "0" + String.valueOf(c.get(Calendar.MONTH) + 1);
		String day = String.valueOf(c.get(Calendar.DAY_OF_MONTH));
		if (c.get(Calendar.DAY_OF_MONTH) < 10)
			day = "0" + String.valueOf(c.get(Calendar.DAY_OF_MONTH));
		return year + "年" + month + "月" + day + "日";
	}
	
	/*
	 * return 两日期相差多少天
	 */
	public static int differenceDateDay(String date,String distributedate)
	{
		Date date1 = null;
		Date date2 = null;
		if((null==distributedate)||(null==date))
		{
			return 0;
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try {    
			 date1 = format.parse(date);
			 date2 = format.parse(distributedate);
		} catch (Exception e) {    
		    e.printStackTrace();    
		}    
		Long d = (date1.getTime()-date2.getTime())/(24*60*60*1000);
		return d.intValue()+1;
	}
	
	public static Long differenceDate(String date,String distributedate)
	{
		Date date1 = null;
		Date date2 = null;
		if(null==distributedate||"".equals(distributedate)||null==date||"".equals(date))
		{
			return 0L;
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {    
			 date1 = format.parse(date);
			 date2 = format.parse(distributedate);
		} catch (Exception e) {    
		    e.printStackTrace();    
		}    
		Long d = date1.getTime()-date2.getTime();
		return d;
	}
	
	public static String getDayAfterDate(String date,int day)
	{
		Date date1 = null;
		if(null==date||"".equals(date))
		{
			return "";
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try {    
			 date1 = format.parse(date);
			 //date2 = format.parse(distributedate);
		} catch (Exception e) {    
		    e.printStackTrace();    
		}    
		return getDayAfterDate(date1, day);
	}
	
	public static String getDayAfterDate(Date date,int day)
	{
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_MONTH, day);
		SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
		String string = format.format(calendar.getTime());
		return string;
	}
	
	public static String getDayAfterTime(String date,int day)
	{
		Date date1 = null;
		Date date2 = null;
		if(null==date||"".equals(date))
		{
			return "";
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {    
			 date1 = format.parse(date);
			 //date2 = format.parse(distributedate);
		} catch (Exception e) {    
		    e.printStackTrace();    
		}    
		Long l = date1.getTime()+day*24*60*60*1000;
		Date d = new Date(l);
		return format.format(d);
	}
	
	public static String getDayBeforeDate(String date,int day)
	{
		return getDayAfterDate(date, -day);
	}

	

	public static Timestamp getTimestamp(){
		return new Timestamp(System.currentTimeMillis());
	}
	public static int compare(String date1Str,String date2Str){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		try{
			Date d1 = sdf.parse(date1Str);
			Date d2 = sdf.parse(date2Str);
			return d1.compareTo(d2);
		}
		catch (Exception e) {
			return 0;
		}
	}
	public static int getYMDNumber(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return Integer.valueOf(sdf.format(date));
	}
	public static int getYMDMMNumber(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		return Integer.valueOf(sdf.format(date));
	}
	public static Long getYMDHMNumber(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
		return Long.parseLong(sdf.format(date));
	}
	
	public static Date convertToDate(String date) throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return sdf.parse(date);
	}
	public static Date convertTimeToDate(String date) throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		return sdf.parse(date);
	}
	public static Date convertTimeToYMDHMDate(String date) throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		return sdf.parse(date);
	}
	public static String getFormatDateStr(String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(getCurrentDate());
	}
	
	// new methods added by LiBin	
	public static Date toDate(String dateStr, SimpleDateFormat format) throws ParseException {
		return format.parse(dateStr);
	}

	//从日期字符串获得日期数字格式
	public static int getYMDNumberFromStr(String dateStr) {
		try {
			return getYMDNumber(convertTimeToDate(dateStr));
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	public static Long getYMDHMNumberFromStr(String dateStr) {
		try {
			return getYMDHMNumber(convertTimeToYMDHMDate(dateStr));
		} catch (Exception e) {
			e.printStackTrace();
			return 0L;
		}
	}
	//获得当月第一天日期字符串格式
	public static String getYMDStrForCurrentMonthStart() {
		return getYM() + "-01";
	}

	public static int getYMDNumberForCurrentMonthStart(){
		return Integer.parseInt(getYM().replaceAll("-","")+"01");
	}

	public static int getYMDNumberBefore(int day){
		String ymd = getYMD();
		String beforeDay = getDayBeforeDate(ymd,day);
		return Integer.parseInt(beforeDay.replaceAll("-",""));
	}

	public static int getYMDNumberYesterday(){
		return getYMDNumberBefore(1);
	}
	public static String getYesterdayStr(){
		return getDayBeforeDate(getYMD(),1);
	}
}

