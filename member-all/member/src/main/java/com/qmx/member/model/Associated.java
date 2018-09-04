package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;
import com.qmx.member.api.enumerate.ProductType;

@TableName("associated")
public class Associated extends BaseModel {
    /**
     * 对应等级关联产品ID
     */
    @TableField("associated_id")
    private Long associatedId;
    /**
     * 产品ID
     */
    @TableField("product_id")
    private Long productId;
    /**
     * 产品名字
     */
    @TableField("product_name")
    private String productName;
    /**
     * 产品类别
     */
    @TableField("product_type")
    private ProductType productType;

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public ProductType getProductType() {
        return productType;
    }

    public void setProductType(ProductType productType) {
        this.productType = productType;
    }

    public Long getAssociatedId() {
        return associatedId;
    }

    public void setAssociatedId(Long associatedId) {
        this.associatedId = associatedId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }
}
