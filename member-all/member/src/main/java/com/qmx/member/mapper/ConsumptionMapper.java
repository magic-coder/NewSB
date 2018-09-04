package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.Consumption;
import com.qmx.member.model.Discount;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ConsumptionMapper extends IBaseMapper<Consumption> {
    Consumption findByLevelId(@Param("levelId")Long levelId);

    void delByLevenId(@Param("id")Long id);
}
