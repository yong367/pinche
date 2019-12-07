package net.shopxx.entity.model;

import java.awt.*;
import java.awt.image.BufferedImage;

/**
 * 水印封装参数实体类
 */
public class WaterModel {
    public enum Type{
        IMAGE,TEXT;
    }
    private int xIndex;//距离X 坐标
    private int yIndex;//距离Y 坐标
    private int waterWidth;//水印高度
    private int waterHeight;//水印宽度
    private BufferedImage imgResource;//图片源
    private String content;//文字内容
    private Type type;
    private Font font;
    private Color color;

    public Font getFont() {
        return font;
    }

    public void setFont(Font font) {
        this.font = font;
    }

    public Color getColor() {
        return color;
    }

    public void setColor(Color color) {
        this.color = color;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }



    public BufferedImage getImgResource() {
        return imgResource;
    }

    public void setImgResource(BufferedImage imgResource) {
        this.imgResource = imgResource;
    }

    public int getxIndex() {
        return xIndex;
    }

    public void setxIndex(int xIndex) {
        this.xIndex = xIndex;
    }

    public int getyIndex() {
        return yIndex;
    }

    public void setyIndex(int yIndex) {
        this.yIndex = yIndex;
    }

    public int getWaterWidth() {
        return waterWidth;
    }

    public void setWaterWidth(int waterWidth) {
        this.waterWidth = waterWidth;
    }

    public int getWaterHeight() {
        return waterHeight;
    }

    public void setWaterHeight(int waterHeight) {
        this.waterHeight = waterHeight;
    }
}
