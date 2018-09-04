package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;
import com.qmx.member.api.enumerate.GiveType;
import com.qmx.member.api.enumerate.RechargeType;
import com.qmx.member.api.enumerate.RuleType;

/**
 * 充值规则
 */
@TableName("discount")
public class Discount extends BaseModel {
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
    @TableField("associated")
    private Long associated;
    /**
     * 关联产品名字
     */
    @TableField("associated_name")
    private String associatedName;
    /**
     * 折扣率
     */
    @TableField("rate")
    private String rate;
    /**
     * 是否与优惠券叠加
     */
    @TableField("superposition")
    private Boolean superposition;

    public Long getLevelId() {
        return levelId;
    }

    public void setLevelId(Long levelId) {
        this.levelId = levelId;
    }

    public Long getAssociated() {
        return associated;
    }

    public void setAssociated(Long associated) {
        this.associated = associated;
    }

    public String getRate() {
        return rate;
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

    public String getAssociatedName() {
        return associatedName;
    }

    public void setAssociatedName(String associatedName) {
        this.associatedName = associatedName;
    }

    public void setGroupSupplierId(Long groupSupplierId) {
        this.groupSupplierId = groupSupplierId;
    }

    public void setRate(String rate) {
        this.rate = rate;
    }

    public Boolean getSuperposition() {
        return superposition;
    }

    public void setSuperposition(Boolean superposition) {
        this.superposition = superposition;
    }
}
