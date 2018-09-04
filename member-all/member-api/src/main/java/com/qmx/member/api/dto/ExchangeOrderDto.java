package com.qmx.member.api.dto;

import com.qmx.base.api.dto.QueryDto;
import com.qmx.member.api.enumerate.DeliverType;
import com.qmx.member.api.enumerate.ExchangeProductType;
import com.qmx.member.api.enumerate.StateType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.Date;

@ApiModel
public class ExchangeOrderDto extends QueryDto {
    @ApiModelProperty(value = "id", example = "id")
    private Long id;
    /**
     * 所属人ID
     */
    private Long memberId;
    /**
     * 商品类别
     */
    private Long exchangeId;
    /**
     * 商品数量
     */
    private Integer count;
    /**
     * 消耗积分
     */
    private String integral;
    /**
     * 收货人名字
     */
    private String name;
    /**
     * 手机号
     */
    private String mobile;
    /**
     * 所在地区
     */
    private String area;
    /**
     * 详细地址
     */
    private String address;
    /**
     * 发货方式
     */
    private DeliverType deliverType;
    /**
     * 兑换码
     */
    private String redeemCode;
    /**
     * 订单商品状态
     */
    private StateType stateType;
    /**
     * 状态
     */
    private Boolean state;
    /**
     * 订单号
     */
    private String sn;
    /**
     * 兑换时间
     */
    private Date time;

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public StateType getStateType() {
        return stateType;
    }

    public void setStateType(StateType stateType) {
        this.stateType = stateType;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getExchangeId() {
        return exchangeId;
    }

    public void setExchangeId(Long exchangeId) {
        this.exchangeId = exchangeId;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public String getIntegral() {
        return integral;
    }

    public void setIntegral(String integral) {
        this.integral = integral;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public DeliverType getDeliverType() {
        return deliverType;
    }

    public void setDeliverType(DeliverType deliverType) {
        this.deliverType = deliverType;
    }

    public String getRedeemCode() {
        return redeemCode;
    }

    public void setRedeemCode(String redeemCode) {
        this.redeemCode = redeemCode;
    }

    public Boolean getState() {
        return state;
    }

    public void setState(Boolean state) {
        this.state = state;
    }
}
