package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.MemberLevel;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberLevelMapper extends IBaseMapper<MemberLevel> {
    MemberLevel findByName(@Param("name") String name);
}
