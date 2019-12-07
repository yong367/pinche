package net.shopxx.entity.bo.suning;

import java.math.BigDecimal;

public class SuNingAccount {
    private String accountType;
    private Integer frozenAmount=0;
    private Integer availableAmount=0;
    private boolean upflag=false;//更新标识

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public Integer getFrozenAmount() {
        return frozenAmount;
    }

    public void setFrozenAmount(Integer frozenAmount) {
        this.frozenAmount = frozenAmount;
    }

    public Integer getAvailableAmount() {
        return availableAmount;
    }

    public void setAvailableAmount(Integer availableAmount) {
        this.availableAmount = availableAmount;
    }

    public boolean isUpflag() {
        return upflag;
    }

    public void setUpflag(boolean upflag) {
        this.upflag = upflag;
    }
}
