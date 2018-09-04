package com.qmx.member.api.dto;

import com.qmx.base.api.dto.QueryDto;
import com.qmx.member.api.enumerate.DeliverType;
import com.qmx.member.api.enumerate.ExchangeProductType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.Date;

@ApiModel
public class SignDto extends QueryDto {
    @ApiModelProperty(value = "id", example = "id")
    private Long id;
    @ApiModelProperty(value = "会员id", example = "id")
    private Long memberId;
    @ApiModelProperty(value = "签到时间", example = "2017-01-01 12:15:66")
    private Date time;

    @ApiModelProperty(value = "获得积分", example = "数字")
    private Integer integral;

    @ApiModelProperty(value = "连续签到次数", example = "数字")
    private Integer continuousSign;

    @ApiModelProperty(value = "本月签到", example = "数字")
    private Integer monthSign;

    @ApiModelProperty(value = "累计签到", example = "数字")
    private Integer cumulativeSign;

    @ApiModelProperty(value = "累计奖励", example = "数字")
    private Integer cumulativeRewards;

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

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Integer getIntegral() {
        return integral;
    }

    public void setIntegral(Integer integral) {
        this.integral = integral;
    }

    public Integer getContinuousSign() {
        return continuousSign;
    }

    public void setContinuousSign(Integer continuousSign) {
        this.continuousSign = continuousSign;
    }

    public Integer getMonthSign() {
        return monthSign;
    }

    public void setMonthSign(Integer monthSign) {
        this.monthSign = monthSign;
    }

    public Integer getCumulativeSign() {
        return cumulativeSign;
    }

    public void setCumulativeSign(Integer cumulativeSign) {
        this.cumulativeSign = cumulativeSign;
    }

    public Integer getCumulativeRewards() {
        return cumulativeRewards;
    }

    public void setCumulativeRewards(Integer cumulativeRewards) {
        this.cumulativeRewards = cumulativeRewards;
    }
}
