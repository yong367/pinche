package net.shopxx.util;

/**
 * @author zhangmengfei
 * @date 2019-9-9 - 8:52
 */
public class ResponseData {

    private Integer code=1;
    private String message;
    private Object data;

    public ResponseData() {
    }

    public ResponseData(Integer code, String message, Object data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public static ResponseData success(Integer code, String message, Object data){
        return new ResponseData(code, message, data);
    }

    public Integer getCode() {
        return this.code;
    }

    public String getMessage() {
        return this.message;
    }

    public Object getData() {
        return this.data;
    }

    public void setCode(final Integer code) {
        this.code = code;
    }

    public void setMessage(final String message) {
        this.message = message;
    }

    public void setData(final Object data) {
        this.data = data;
    }


}
