package net.shopxx.util;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PinYinUtils {

    public static String toPinyin(String chinese) {
        String pinyinStr = "";
        char[] newChar = replaceSpecialStr(chinese).toCharArray();
         HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
         defaultFormat.setCaseType(HanyuPinyinCaseType.LOWERCASE);
         defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
         for (int i = 0; i < newChar.length; i++) {
                         if (newChar[i] > 128) {
                                try {
                                    pinyinStr += PinyinHelper.toHanyuPinyinStringArray(newChar[i], defaultFormat)[0];
                                } catch (BadHanyuPinyinOutputFormatCombination e) {
                                    e.printStackTrace();
                               }
                         }else{
                            pinyinStr += newChar[i];
                         }
                   }
              return pinyinStr;
    }

    private static String replaceSpecialStr(String str){
        String regEx="[\n`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。， 、？]";
        String aa = "";//这里是将特殊字符换为aa字符串,""代表直接去掉
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(str);//这里把想要替换的字符串传进来
       return m.replaceAll(aa).trim();
    }

}