package com.qmx.member.api.enumerate;

public enum ExchangeProductType {
    MSXC("美食小吃"),
    FSXL("服饰鞋履"),
    GHHZ("个户化妆"),
    SJSM("手机数码"),
    JYDQ("家用电器"),
    JFJJ("家纺家居"),
    SHYP("生活百货"),
    MYYP("母婴用品"),
    QCYP("汽车用品"),
    YHQ("优惠券"),
    NXYP("女性用品");

    private String title;

    ExchangeProductType(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
