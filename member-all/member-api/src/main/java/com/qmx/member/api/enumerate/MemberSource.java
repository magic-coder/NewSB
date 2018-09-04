package com.qmx.member.api.enumerate;

public enum MemberSource {
    wx("微信"),
    xianxia("线下"),
    xsht("线上后台");

    private String title;

    MemberSource(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
