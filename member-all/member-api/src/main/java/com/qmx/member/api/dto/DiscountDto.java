package com.qmx.member.api.dto;

import com.qmx.base.api.dto.QueryDto;
import com.qmx.member.api.enumerate.ProductType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.HashMap;
import java.util.List;

@ApiModel
public class DiscountDto extends QueryDto {
    @ApiModelProperty(value = "id", example = "id")
    private Long id;
    private Long levelId;
    private String levelName;
    private Long associated;
    private String associatedName;
    private String rate;
    private Boolean superposition;

    private List<String> ids;

    private HashMap<ProductType,List<AssociatedDto>> map;

    public List<String> getIds() {
        return ids;
    }

    public void setIds(List<String> ids) {
        this.ids = ids;
    }

    public HashMap<ProductType, List<AssociatedDto>> getMap() {
        return map;
    }

    public void setMap(HashMap<ProductType, List<AssociatedDto>> map) {
        this.map = map;
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

    public Long getAssociated() {
        return associated;
    }

    public void setAssociated(Long associated) {
        this.associated = associated;
    }

    public String getRate() {
        return rate;
    }

    public String getLevelName() {
        return levelName;
    }

    public String getAssociatedName() {
        return associatedName;
    }

    public void setAssociatedName(String associatedName) {
        this.associatedName = associatedName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
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
