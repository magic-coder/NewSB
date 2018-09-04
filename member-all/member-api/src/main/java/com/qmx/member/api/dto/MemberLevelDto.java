package com.qmx.member.api.dto;

import com.qmx.base.api.dto.QueryDto;
import io.swagger.annotations.ApiModel;

@ApiModel
public class MemberLevelDto extends QueryDto {
    private Long id;
    private String name;
    private String rechargePoint;
    private String consumptionDiscount;
    private String consumptionPoint;
    private Boolean levelLock;
    private Double integral;
    private Long upgradeId;

    public Long getUpgradeId() {
        return upgradeId;
    }

    public void setUpgradeId(Long upgradeId) {
        this.upgradeId = upgradeId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
