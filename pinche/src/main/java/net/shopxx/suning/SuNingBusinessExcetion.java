package net.shopxx.suning;

import com.suning.api.exception.SuningApiException;

public class SuNingBusinessExcetion extends SuningApiException{
    private String code;
    private String message;
    private String interfaceName;

    public SuNingBusinessExcetion(String code, String message, String interfaceName) {
        this.code = code;
        this.message = message;
        this.interfaceName = interfaceName;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "SuNingBusinessExcetion{" +
                "code='" + code + '\'' +
                ", message='" + message + '\'' +
                ", interfaceName='" + interfaceName + '\'' +
                '}';
    }
}
