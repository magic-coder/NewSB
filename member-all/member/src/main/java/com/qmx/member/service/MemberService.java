package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.mapper.MemberMapper;
import com.qmx.member.model.Member;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

@Service
@CacheConfig(cacheNames = "memberService")
public class MemberService extends BaseService<Member> {
    private MemberMapper memberMapper;

    public void updateState() {
        memberMapper.updateState();
    }

    public Member findByOpenId(String openid) {
        return memberMapper.findByOpenId(openid);
    }
}
