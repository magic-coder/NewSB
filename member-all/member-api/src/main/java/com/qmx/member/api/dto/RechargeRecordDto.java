package com.qmx.member.api.dto;

import com.qmx.base.api.dto.QueryDto;
import io.swagger.annotations.ApiModel;

import java.math.BigDecimal;
import java.util.Date;

@ApiModel
public class RechargeRecordDto extends QueryDto {
    private Long id;
    private Long memberUser;
    private String cardNumber;
    private String name;
    private String sn;
    private BigDecimal money;
    private BigDecimal giveMoney;
    private Integer giveIntegral;
    private Date time;
    private Boolean state;
    private Boolean synState;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
