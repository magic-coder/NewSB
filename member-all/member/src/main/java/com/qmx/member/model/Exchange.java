package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;
import com.qmx.member.api.enumerate.DeliverType;
import com.qmx.member.api.enumerate.ExchangeProductType;
import com.qmx.member.api.enumerate.ProductType;

import java.util.Date;

@TableName("exchange")
public class Exchange extends BaseModel {
    /**
     * 商品类别
     */
    @TableField("exchange_product_type")
    private ExchangeProductType exchangeProductType;
    /**
     * 图片
     */
    @TableField("image")
    private String image;
    /**
     * 商品说明
     */
    @TableField("text")
    private String text;
    /**
     * 商品名字
     */
    @TableField("product_name")
    private String productName;
    /**
     * 所需积分
     */
    @TableField("integeral")
    private String integeral;
    /**
     * 发货方式
     */
    @TableField("deliver_type")
    private DeliverType deliverType;
    /**
     * 过期时间
     */
    @TableField("expiry_time")
    private Date expiryTime;
    /**
     * 商品状态(0过期,1正常)
     */
    @TableField("state")
    private Boolean state;

    public Date getExpiryTime() {
        return expiryTime;
    }

    public Boolean getState() {
        return state;
    }

    public void setState(Boolean state) {
        this.state = state;
    }

    public void setExpiryTime(Date expiryTime) {
        this.expiryTime = expiryTime;
    }

    public ExchangeProductType getExchangeProductType() {
        return exchangeProductType;
    }

    public void setExchangeProductType(ExchangeProductType exchangeProductType) {
        this.exchangeProductType = exchangeProductType;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getIntegeral() {
        return integeral;
    }

    public void setIntegeral(String integeral) {
        this.integeral = integeral;
    }

    public DeliverType getDeliverType() {
        return deliverType;
    }

    public void setDeliverType(DeliverType deliverType) {
        this.deliverType = deliverType;
    }
}
