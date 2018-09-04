package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;

@TableName("member_level")
public class MemberLevel extends BaseModel {
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
     * 等级名称
     */
    @TableField("name")
    private String name;
    /**
     * 充值积分比率
     */
    @TableField("recharge_point")
    private String rechargePoint;
    /**
     * 消费折扣
     */
    @TableField("upgrade_id")
    private Long upgradeId;
    /**
     * 升级等级Id
     */
    @TableField("consumption_discount")
    private String consumptionDiscount;
    /**
     * 消费积分比率
     */
    @TableField("consumption_point")
    private String consumptionPoint;
    /**
     * 等级是否锁定（是否可以升级）
     */
    @TableField("level_lock")
    private Boolean levelLock;
    /**
     * 升级所需积分
     */
    @TableField("integral")
    private Double integral;

    public Long getUpgradeId() {
        return upgradeId;
    }

    public void setUpgradeId(Long upgradeId) {
        this.upgradeId = upgradeId;
    }

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRechargePoint() {
        return rechargePoint;
    }

    public void setRechargePoint(String rechargePoint) {
        this.rechargePoint = rechargePoint;
    }

    public String getConsumptionDiscount() {
        return consumptionDiscount;
    }

    public void setConsumptionDiscount(String consumptionDiscount) {
        this.consumptionDiscount = consumptionDiscount;
    }

    public String getConsumptionPoint() {
        return consumptionPoint;
    }

    public void setConsumptionPoint(String consumptionPoint) {
        this.consumptionPoint = consumptionPoint;
    }

    public Boolean getLevelLock() {
        return levelLock;
    }

    public void setLevelLock(Boolean levelLock) {
        this.levelLock = levelLock;
    }

    public Double getIntegral() {
        return integral;
    }

    public void setIntegral(Double integral) {
        this.integral = integral;
    }
}
