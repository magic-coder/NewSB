package com.qmx.member.api.enumerate;

public enum RuleType {
    section("区间"),
    fixed("固定");

    private String title;

    RuleType(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
