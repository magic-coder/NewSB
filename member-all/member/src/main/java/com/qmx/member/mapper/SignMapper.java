package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.Exchange;
import com.qmx.member.model.Sign;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface SignMapper extends IBaseMapper<Sign> {

    Sign findByMemberId(@Param("id") Long id);

    Sign isContinuousSign(@Param("id")Long id);
}
