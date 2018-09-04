package com.qmx.member.api.dto;

import com.qmx.base.api.dto.QueryDto;
import com.qmx.member.api.enumerate.GiveType;
import com.qmx.member.api.enumerate.RechargeType;
import com.qmx.member.api.enumerate.RuleType;
import io.swagger.annotations.ApiModel;

@ApiModel
public class RechargeRuleDto extends QueryDto {

    private Long id;
    private Long levelId;
    private RuleType type;
    private RechargeType rechargeType;
    private Double amount;
    private Double minAmount;
    private Double maxAmount;
    private GiveType give;
    private Double integralPoint;
    private Double moneyPoint;
    private Double discountPoint;

    public Double getDiscountPoint() {
        return discountPoint;
    }

    public void setDiscountPoint(Double discountPoint) {
        this.discountPoint = discountPoint;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getLevelId() {
        return levelId;
    }

    public void setLevelId(Long levelId) {
        this.levelId = levelId;
    }

    public RuleType getType() {
        return type;
    }

    public RechargeType getRechargeType() {
        return rechargeType;
    }

    public void setRechargeType(RechargeType rechargeType) {
        this.rechargeType = rechargeType;
    }

    public void setType(RuleType type) {
        this.type = type;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public Double getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(Double minAmount) {
        this.minAmount = minAmount;
    }

    public Double getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(Double maxAmount) {
        this.maxAmount = maxAmount;
    }

    public GiveType getGive() {
        return give;
    }

    public void setGive(GiveType give) {
        this.give = give;
    }

    public Double getIntegralPoint() {
        return integralPoint;
    }

    public void setIntegralPoint(Double integralPoint) {
        this.integralPoint = integralPoint;
    }

    public Double getMoneyPoint() {
        return moneyPoint;
    }

    public void setMoneyPoint(Double moneyPoint) {
        this.moneyPoint = moneyPoint;
    }
}
