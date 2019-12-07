package net.shopxx.util;

import net.shopxx.entity.model.WaterMarkModel;
import net.shopxx.entity.model.WaterModel;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @use 利用Java代码给图片加水印
 */
public class WaterMarkUtils {
    
    /**
     * 合并二维码
     * @param filePath  水印图片原地址
     * 
     * @return 返回水印后图片的字节输出流
     * @throws IOException
     */

    public static void addWaterMark(int x,int y,int tx,int ty,int wx,int wy,String content,Image src,Image qrcode,int srcCodeImgWidth,int srcCodeImgHeight,String filePath,String fileOutPath) throws IOException {
        File file = new File(filePath);
        Font font = new Font("宋体",  Font.PLAIN, 20);                     //水印字体
        Color color=new Color(0,0,255);                          //水印图片色彩以及透明度

        Image srcImg = ImageIO.read(file);//文件转化为图片
        int srcImgWidth = srcImg.getWidth(null);//获取图片的宽
        int srcImgHeight = srcImg.getHeight(null);//获取图片的高
        // 加水印
        BufferedImage bufImg = new BufferedImage(srcImgWidth, srcImgHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bufImg.createGraphics();
        g.drawImage(srcImg, 0, 0, srcImgWidth, srcImgHeight, null);
        g.setColor(color); //根据图片的背景设置水印颜色
        g.setFont(font);              //设置字体
        
        //画水印
       // g.drawString(content,wx,wy);
//        if (taskFlow != null) {
//            g.drawString(taskFlow, taskFlowX, taskFlowY);
//        }
        g.drawImage(qrcode,x,y,srcCodeImgWidth,srcCodeImgHeight,null);
        if(src != null) {
            int srcHeadImgWidth = src.getWidth(null);//获取头像的宽
            int srcHeadImgHeight = src.getHeight(null);//获取头像的高
            //g.drawImage(src, x-325, y-285, srcHeadImgWidth + 50, srcHeadImgHeight + 50, null); 485   387
            g.drawImage(src, tx, ty, srcHeadImgWidth + 100, srcHeadImgHeight + 100, null);
        }
        g.dispose();
        File fileOut = new File(fileOutPath);
        File destDir = fileOut.getParentFile();
        if (destDir != null) {
            destDir.mkdirs();
        }
        FileOutputStream out = new FileOutputStream(fileOut);
        ImageIO.write(bufImg, "png", out);
    }

    public static void processWaterMark(WaterMarkModel waterMarkModel) throws IOException {
        Font font = new Font("微软雅黑",  Font.PLAIN, 18);                     //水印字体
        Color color=new Color(255,255,255);                          //水印图片色彩以及透明度
        Image srcImg = getBufferedImageByUrl(waterMarkModel.getResourcePath());//文件转化为图片
        int srcImgWidth = srcImg.getWidth(null);//获取图片的宽
        int srcImgHeight = srcImg.getHeight(null);//获取图片的高
        // 加水印
        BufferedImage bufImg = new BufferedImage(srcImgWidth, srcImgHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bufImg.createGraphics();
        g.drawImage(srcImg, 0, 0, srcImgWidth, srcImgHeight, null);
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g.setColor(color); //根据图片的背景设置水印颜色
        g.setFont(font);              //设置字体
        for (WaterModel waterModel:waterMarkModel.getResult()){
            if(waterModel.getType().equals(WaterModel.Type.IMAGE)){
                g.drawImage(waterModel.getImgResource(), waterModel.getxIndex(), waterModel.getyIndex(), waterModel.getWaterWidth(), waterModel.getWaterHeight(), null);
            }else{
                if(waterModel.getColor()!=null){
                    g.setColor(waterModel.getColor());
                }
                if(waterModel.getFont()!=null){
                    g.setFont(waterModel.getFont());
                }
                g.drawString(waterModel.getContent(), waterModel.getxIndex(), waterModel.getyIndex());
                g.setColor(color); //根据图片的背景设置水印颜色
                g.setFont(font);
            }
        }
        g.dispose();
        File fileOut = new File(waterMarkModel.getFileOutPath());
        File destDir = fileOut.getParentFile();
        if (destDir != null) {
            destDir.mkdirs();
        }
        FileOutputStream out = new FileOutputStream(fileOut);
        ImageIO.write(bufImg, "png", out);
    }
    

    public static void addTitleWaterMark(List<Map<String,String>> list, String filePath, String fileOutPath)throws Exception{
        File file = new File(filePath);
        Font font = new Font("微软雅黑",  Font.PLAIN, 15);                     //水印字体
        Color color=new Color(255,255,255);                          //水印图片色彩以及透明度

        Image srcImg = ImageIO.read(file);//文件转化为图片
        int srcImgWidth = srcImg.getWidth(null);//获取图片的宽
        int srcImgHeight = srcImg.getHeight(null);//获取图片的高
        // 加水印
        BufferedImage bufImg = new BufferedImage(srcImgWidth, srcImgHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bufImg.createGraphics();
        g.drawImage(srcImg, 0, 0, srcImgWidth, srcImgHeight, null);
        g.setColor(color); //根据图片的背景设置水印颜色
        g.setFont(font);
        if (list.size() > 0 && list != null) {
            for (int i = 0;i<list.size();i++) {
                Map<String, String> map = list.get(i); 
                g.drawString(map.get("xuhao")+"  "+map.get("taskFlow"),Integer.parseInt(String.valueOf(map.get("indexX"))),Integer.parseInt(String.valueOf(map.get("indexY"))));
            }
        }
        g.dispose();
        File fileOut = new File(fileOutPath);
        File destDir = fileOut.getParentFile();
        if (destDir != null) {
            destDir.mkdirs();
        }
        FileOutputStream out = new FileOutputStream(fileOut);
        ImageIO.write(bufImg, "png", out);
    }
    /*public static int getWatermarkLength(String waterMarkContent, Graphics2D g) {
        return g.getFontMetrics(g.getFont()).charsWidth(waterMarkContent.toCharArray(), 0, waterMarkContent.length());
    }*/
    /**
     * 根据文件网络路径生成BufferedImage
     * @param headImageUrl
     *
     */
    public static BufferedImage getBufferedImageByUrl(String headImageUrl) {
        HttpURLConnection httpUrl =null;
        BufferedImage src=null;
        try {
            //请求url获取图片
            InputStream in = null;
            Boolean flag = false;
            int times = 0;
            URL url = new URL(headImageUrl);
            while (!flag && times <= 60) {
                try {
                    httpUrl = (HttpURLConnection) url.openConnection();
                    httpUrl.connect();
                    in= httpUrl.getInputStream();
                    flag =true;
                }catch (Exception e){
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e1) {
                        e.printStackTrace();
                    }
                    times++;
                    flag  = false;
                }
            }
            BufferedInputStream bis=new BufferedInputStream(in);
            src = ImageIO.read(bis);
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(httpUrl!=null){
                httpUrl.disconnect();
            }
        }
        return src;
    }

    public static List<String> processTextLength(String text, int length){
        String chinese = "[\u4e00-\u9fa5]";
      List<String> list = new ArrayList<>();
        List<String> result = new ArrayList<>();
        boolean isSurpassFlag=false;//是否超过图片文字制定长度
        for (int i = 0; i < text.length(); i++) {
            String temp = text.substring(i, i + 1);
            int j=i+1;
            if (temp.matches(chinese)) {
               list.add("");
            }
            list.add(temp);
            if((length-1)<=list.size() && list.size()<=(length+1)){
            result.add(processListStr(list));
            list.clear();
            isSurpassFlag=true;
            }else{
                isSurpassFlag=false;
            }
        }
        if(!isSurpassFlag){
            result.add(processListStr(list));
            list.clear();
        }
        return result;
    }

    private static String processListStr(List<String> list){
       StringBuilder stringBuilder=new StringBuilder("");
        for (String str:list) {
            stringBuilder.append(str);
        }
        return stringBuilder.toString();
    }

}