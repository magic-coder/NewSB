package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;
import com.qmx.member.api.enumerate.DeliverType;
import com.qmx.member.api.enumerate.ExchangeProductType;
import com.qmx.member.api.enumerate.StateType;

import java.util.Date;

@TableName("exchange_order")
public class ExchangeOrder extends BaseModel {
    /**
     * 所属人ID
     */
    @TableField("member_id")
    private Long memberId;
    /**
     * 商品ID
     */
    @TableField("exchange_id")
    private Long exchangeId;
    /**
     * 订单号
     */
    @TableField("sn")
    private String sn;
    /**
     * 商品数量
     */
    @TableField("count")
    private Integer count;
    /**
     * 消耗积分
     */
    @TableField("integral")
    private String integral;
    /**
     * 收货人名字
     */
    @TableField("name")
    private String name;
    /**
     * 手机号
     */
    @TableField("mobile")
    private String mobile;
    /**
     * 所在地区
     */
    @TableField("area")
    private String area;
    /**
     * 详细地址
     */
    @TableField("address")
    private String address;
    /**
     * 发货方式
     */
    @TableField("deliver_type")
    private DeliverType deliverType;
    /**
     * 兑换码
     */
    @TableField("redeem_code")
    private String redeemCode;
    /**
     * 订单商品状态
     */
    @TableField("state_type")
    private StateType stateType;
    /**
     * 状态(成功(失败)
     */
    @TableField("state")
    private Boolean state;
    /**
     * 兑换时间
     */
    @TableField("time")
    private Date time;

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public StateType getStateType() {
        return stateType;
    }

    public void setStateType(StateType stateType) {
        this.stateType = stateType;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
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
