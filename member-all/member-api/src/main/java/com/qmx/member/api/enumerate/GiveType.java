package com.qmx.member.api.enumerate;

public enum GiveType {
    zhekou("折扣"),
    zengsong("赠送");

    private String title;

    GiveType(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
