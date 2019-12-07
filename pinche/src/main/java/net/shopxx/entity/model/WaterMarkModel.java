package net.shopxx.entity.model;

import java.util.List;

public class WaterMarkModel {
    private List<WaterModel> result;
    private String resourcePath;
    private String fileOutPath;

    public List<WaterModel> getResult() {
        return result;
    }

    public void setResult(List<WaterModel> result) {
        this.result = result;
    }

    public String getResourcePath() {
        return resourcePath;
    }

    public void setResourcePath(String resourcePath) {
        this.resourcePath = resourcePath;
    }

    public String getFileOutPath() {
        return fileOutPath;
    }

    public void setFileOutPath(String fileOutPath) {
        this.fileOutPath = fileOutPath;
    }
}
