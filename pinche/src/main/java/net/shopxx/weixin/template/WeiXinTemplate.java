package net.shopxx.weixin.template;

public enum  WeiXinTemplate {
    APPLY_CASH_TEMPLATE("jmnl4pelsuVci64kj5vjtgWAX6OxPwqXxgPGJl_3xbc","微信提现申请"),
    APPLY_CASH_SUCCESS_TEMPLATE("RzmD-NH6fl5PX3GNn7ekV2Fxijr4cuv-dM1kxRb1bII","提现到账通知"),
    USER_BALANCE_CHANGE_TEMPLATE("dEPk5sQ8Q_UuWwTFJQLEjz_gWJEBqjKmcaqjcGVKC9U","余额变动通知"),
    TICKET_NOTIFY_TEMPLATE("Y_SCRRrMQ9ovF2znTLs4WQ_2xuRa9NaFZ2I4Hpr78WI","激活码发放通知");
    private String templateId;
    private String name;

    WeiXinTemplate(String templateId, String name) {
        this.templateId = templateId;
        this.name = name;
    }

    public String getTemplateId() {
        return templateId;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
