package net.shopxx.util;


import net.shopxx.entity.Member;
import net.shopxx.service.MemberService;
import org.apache.commons.lang.StringUtils;

import javax.inject.Inject;
import java.util.Random;

public class CodeUtils {
        public static void main(String[] args) {
            /*------采用随机6位Id防止泄露ID------*/
            Random random = new Random();
            String result="";
            for (int i=0;i<6;i++)
            {
                result+=random.nextInt(10);
            }
            /*------采用随机6位Id防止泄露ID------*/
            System.out.println(result);
            String str=toSerialCode(Long.valueOf(result).longValue());//随机ID转随机编码
            System.out.println(str);
            long lon=codeToId(str);//随机编码转ID
            System.out.println(lon);
     }

     public synchronized static String generateShareCode(){
         /*------采用随机6位Id防止泄露ID------*/
         Random random = new Random();
         String result="";
         for (int i=0;i<6;i++)
         {
             result+=random.nextInt(10);
         }
         /*------采用随机6位Id防止泄露ID------*/
        return toSerialCode(Long.valueOf(result).longValue()).toUpperCase();
     }



    /** 自定义进制（选择你想要的进制数，不能重复且最好不要0、1这些容易混淆的字符） */
    private static final char[] r=new char[]{'q', 'w', 'e', '8', 's', '2', 'd', 'z', 'x', '9', 'c', '7', 'p', '5', 'k', '3', 'm', 'j', 'u', 'f', 'r', '4', 'v', 'y', 't', 'n', '6', 'b', 'g', 'h'};

    /** 定义一个字符用来补全邀请码长度（该字符前面是计算出来的邀请码，后面是用来补全用的） */
    private static final char b='a';

    /** 进制长度 */
    private static final int binLen=r.length;

    /** 邀请码长度 */
    private static final int s=6;

    /**
     * 根据ID生成随机码
     * @param id ID
     * @return 随机码
     */
    public static String toSerialCode(long id) {
        char[] buf=new char[32];
        int charPos=32;

        while((id / binLen) > 0) {
            int ind=(int)(id % binLen);
            buf[--charPos]=r[ind];
            id /= binLen;
        }
        buf[--charPos]=r[(int)(id % binLen)];
        String str=new String(buf, charPos, (32 - charPos));
        // 不够长度的自动随机补全
        if(str.length() < s) {
            StringBuilder sb=new StringBuilder();
            sb.append(b);
            Random rnd=new Random();
            for(int i=1; i < s - str.length(); i++) {
                sb.append(r[rnd.nextInt(binLen)]);
            }
            str+=sb.toString();
        }
        return str;
    }

    /**
     * 根据随机码生成ID
     * @param
     * @return ID
     */
    public static long codeToId(String code) {
        char chs[]=code.toCharArray();
        long res=0L;
        for(int i=0; i < chs.length; i++) {
            int ind=0;
            for(int j=0; j < binLen; j++) {
                if(chs[i] == r[j]) {
                    ind=j;
                    break;
                }
            }
            if(chs[i] == b) {
                break;
            }
            if(i > 0) {
                res=res * binLen + ind;
            } else {
                res=ind;
            }
        }
        return res;
    }
}
