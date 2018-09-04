package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;

import java.util.Date;

@TableName("sign")
public class Sign extends BaseModel {
    /**
     * 所属人ID
     */
    @TableField("member_id")
    private Long memberId;
    /**
     * 签到时间
     */
    @TableField("time")
    private Date time;
    /**
     * 获得积分
     */
    @TableField("integral")
    private Integer integral;
    /**
     * 连续签到次数
     */
    @TableField("continuous_sign")
    private Integer continuousSign;

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
}
