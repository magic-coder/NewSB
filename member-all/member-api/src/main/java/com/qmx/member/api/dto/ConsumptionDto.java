package com.qmx.member.api.dto;

import com.fasterxml.jackson.databind.util.JSONPObject;
import com.qmx.base.api.dto.QueryDto;
import com.qmx.member.api.enumerate.MemberSex;
import com.qmx.member.api.enumerate.MemberSource;
import com.qmx.member.api.enumerate.MemberState;
import com.qmx.member.api.enumerate.ProductType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ApiModel
public class ConsumptionDto extends QueryDto {
    @ApiModelProperty(value = "id", example = "id")
    private Long id;
    private Long levelId;
    private String levelName;
    private Long associatedId;
    private String associatedName;
    private String integralProportion;

    private List<String> ids;

    private HashMap<ProductType,List<AssociatedDto>> map;

    public HashMap<ProductType, List<AssociatedDto>> getMap() {
        return map;
    }

    public void setMap(HashMap<ProductType, List<AssociatedDto>> map) {
        this.map = map;
    }

    public List<String> getIds() {
        return ids;
    }

    public void setIds(List<String> ids) {
        this.ids = ids;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public Long getLevelId() {
        return levelId;
    }

    public void setLevelId(Long levelId) {
        this.levelId = levelId;
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
