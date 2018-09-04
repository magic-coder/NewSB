package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.api.enumerate.ProductType;
import com.qmx.member.model.Associated;
import com.qmx.member.model.Consumption;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AssociatedMapper extends IBaseMapper<Associated> {

    List<Associated> findByConsumptionId(@Param("id") Long id, @Param("type") ProductType type);

    void delByConsumptionId(@Param("id") Long id);
}
