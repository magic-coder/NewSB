package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.mapper.ExchangeMapper;
import com.qmx.member.mapper.MemberMapper;
import com.qmx.member.model.Exchange;
import com.qmx.member.model.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

@Service
@CacheConfig(cacheNames = "exchangeService")
public class ExchangeService extends BaseService<Exchange> {
    @Autowired
    private ExchangeMapper exchangeMapper ;

    public void updateState() {
        exchangeMapper.updateState();
    }
}
