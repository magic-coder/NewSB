package com.qmx.member.api.dto;

import com.qmx.base.api.dto.QueryDto;
import com.qmx.member.api.enumerate.SourceType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.Date;

@ApiModel
public class MemberIntegeralDto extends QueryDto {
    @ApiModelProperty(value = "id", example = "id")
    private Long id;
    /**
     * 所属人id
     */
    private Long memberId;
    /**
     * 订单号
     */
    private String sn;
    /**
     * 获得/使用积分时间
     */
    private Date time;
    /**
     * 充值/消费积分
     */
    private Double integeral;
    /**
     * 积分来源
     */
    private SourceType sourceType;
    /**
     * 剩余积分
     */
    private Double balanceIntegeral;
    /**
     * 产品id
     */
    private Long productId;
    /**
     * 产品名称
     */
    private Long productName;
    /**
     * 记录种类
     */
    private Boolean recordType;
    /**
     * 订单状态
     */
    private Boolean status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
