package com.qmx.member.api.enumerate;

public enum ProductType {
    menpiao("门票"),
    shangpin("商品");

    private String title;

    ProductType(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
