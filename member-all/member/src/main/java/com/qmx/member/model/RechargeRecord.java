package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;

import java.math.BigDecimal;
import java.util.Date;

@TableName("recharge_record")
public class RechargeRecord extends BaseModel {
    /**
     * 所属人id
     */
    @TableField("member_id")
    private Long memberId;
    /**
     * 供应商id
     */
    @TableField("supplier_id")
    private Long supplierId;
    /**
     * 集团供应商id
     */
    @TableField("group_supplier_id")
    private Long groupSupplierId;
    /**
     * 所属会员
     */
    @TableField("member_user")
    private Long memberUser;
    /**
     * 会员卡号
     */
    @TableField("card_number")
    private String cardNumber;
    /**
     * 会员名
     */
    @TableField("name")
    private String name;
    /**
     * 订单号
     */
    @TableField("sn")
    private String sn;
    /**
     * 充值金额
     */
    @TableField("money")
    private BigDecimal money;
    /**
     * 赠送金额
     */
    @TableField("give_money")
    private BigDecimal giveMoney;
    /**
     * 赠送积分
     */
    @TableField("give_integral")
    private Integer giveIntegral;
    /**
     * 充值时间
     */
    @TableField("time")
    private Date time;
    /**
     * 充值状态
     */
    @TableField("state")
    private Boolean state;
    /**
     * 线下同步状态
     */
    @TableField("syn_state")
    private Boolean synState;

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Long supplierId) {
        this.supplierId = supplierId;
    }

    public Long getGroupSupplierId() {
        return groupSupplierId;
    }

    public void setGroupSupplierId(Long groupSupplierId) {
        this.groupSupplierId = groupSupplierId;
    }

    public Long getMemberUser() {
        return memberUser;
    }

    public void setMemberUser(Long memberUser) {
        this.memberUser = memberUser;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public BigDecimal getMoney() {
        return money;
    }

    public void setMoney(BigDecimal money) {
        this.money = money;
    }

    public BigDecimal getGiveMoney() {
        return giveMoney;
    }

    public void setGiveMoney(BigDecimal giveMoney) {
        this.giveMoney = giveMoney;
    }

    public Integer getGiveIntegral() {
        return giveIntegral;
    }

    public void setGiveIntegral(Integer giveIntegral) {
        this.giveIntegral = giveIntegral;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Boolean getState() {
        return state;
    }

    public void setState(Boolean state) {
        this.state = state;
    }

    public Boolean getSynState() {
        return synState;
    }

    public void setSynState(Boolean synState) {
        this.synState = synState;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
