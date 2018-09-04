package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;
import com.qmx.member.api.enumerate.MemberSex;
import com.qmx.member.api.enumerate.MemberSource;
import com.qmx.member.api.enumerate.MemberState;

import java.util.Date;

@TableName("consumption")
public class Consumption extends BaseModel {
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
     * 会员等级
     */
    @TableField("level_id")
    private Long levelId;
    /**
     * 会员等级名称
     */
    @TableField("level_name")
    private String levelName;
    /**
     * 关联产品
     */
    @TableField("associated_id")
    private Long associatedId;
    /**
     * 关联产品名字
     */
    @TableField("associated_name")
    private String associatedName;
    /**
     * 积分比例
     */
    @TableField("integral_proportion")
    private String integralProportion;

    public Long getLevelId() {
        return levelId;
    }

    public void setLevelId(Long levelId) {
        this.levelId = levelId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
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

    public Long getAssociatedId() {
        return associatedId;
    }

    public void setAssociatedId(Long associatedId) {
        this.associatedId = associatedId;
    }

    public String getAssociatedName() {
        return associatedName;
    }

    public void setAssociatedName(String associatedName) {
        this.associatedName = associatedName;
    }

    public String getIntegralProportion() {
        return integralProportion;
    }

    public void setIntegralProportion(String integralProportion) {
        this.integralProportion = integralProportion;
    }
}
