package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.Discount;
import com.qmx.member.model.MemberLevel;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface DiscountMapper extends IBaseMapper<Discount> {
    Discount findByLevelId(@Param("levelId") Long levelId);

    void delByLevenId(@Param("id")Long id);

}
