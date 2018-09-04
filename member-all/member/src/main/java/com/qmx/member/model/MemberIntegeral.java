package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;
import com.qmx.member.api.enumerate.RechargeType;
import com.qmx.member.api.enumerate.SourceType;

import java.util.Date;

@TableName("member_integeral")
public class MemberIntegeral extends BaseModel {
    /**
     * 所属人id
     */
    @TableField("member_id")
    private Long memberId;
    /**
     * 订单号
     */
    @TableField("sn")
    private String sn;
    /**
     * 订单内容
     */
    @TableField("sn_text")
    private String snText;
    /**
     * 获得/使用积分时间
     */
    @TableField("time")
    private Date time;
    /**
     * 充值/消费积分
     */
    @TableField("integeral")
    private Double integeral;
    /**
     * 积分来源
     */
    @TableField("source_type")
    private SourceType sourceType;
    /**
     * 剩余积分
     */
    @TableField("balance_integeral")
    private Double balanceIntegeral;
    /**
     * 产品id
     */
    @TableField("product_id")
    private Long productId;
    /**
     * 产品名称
     */
    @TableField("product_name")
    private Long productName;
    /**
     * 记录种类 false(消费积分)true(获得积分)
     */
    @TableField("record_type")
    private Boolean recordType;
    /**
     * 订单状态
     */
    @TableField("status")
    private Boolean status;

    public String getSnText() {
        return snText;
    }

    public void setSnText(String snText) {
        this.snText = snText;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Double getIntegeral() {
        return integeral;
    }

    public void setIntegeral(Double integeral) {
        this.integeral = integeral;
    }

    public SourceType getSourceType() {
        return sourceType;
    }

    public void setSourceType(SourceType sourceType) {
        this.sourceType = sourceType;
    }

    public Double getBalanceIntegeral() {
        return balanceIntegeral;
    }

    public void setBalanceIntegeral(Double balanceIntegeral) {
        this.balanceIntegeral = balanceIntegeral;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Long getProductName() {
        return productName;
    }

    public void setProductName(Long productName) {
        this.productName = productName;
    }

    public Boolean getRecordType() {
        return this.recordType;
    }

    public void setRecordType(Boolean recordType) {
        this.recordType = recordType;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }
}
