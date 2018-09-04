package com.qmx.member.api.enumerate;

public enum SourceType {
    chongzhi("充值"),
    xiaofei("消费"),
    huodong("活动");

    private String title;

    SourceType(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
