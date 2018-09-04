package com.qmx.member.api.enumerate;

public enum StateType {
    YFDHM("已发兑换码"),
    YLQ("已领取"),
    YFH("已通知发货");

    private String title;

    StateType(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
