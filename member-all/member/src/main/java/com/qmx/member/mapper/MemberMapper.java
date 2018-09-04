package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.Member;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberMapper extends IBaseMapper<Member> {
    void updateState();

    Member findByOpenId(@Param("openid") String openid);
}
