package com.qmx.member.api.enumerate;

public enum RechargeType {
    wx("微信"),
    zfb("支付宝"),
    hyye("会员余额"),
    xinajin("现金");

    private String title;

    RechargeType(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
