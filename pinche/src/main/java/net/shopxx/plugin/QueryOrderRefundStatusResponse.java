package net.shopxx.plugin;

public class QueryOrderRefundStatusResponse {
    private boolean orderRefundStatus;
    private String message;

    public boolean isOrderRefundStatus() { return orderRefundStatus; }

    public void setOrderRefundStatus(boolean orderRefundStatus) { this.orderRefundStatus = orderRefundStatus; }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
