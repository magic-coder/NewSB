package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.model.MemberMoney;
import com.qmx.member.model.RechargeRecord;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

@Service
@CacheConfig(cacheNames = "memberMoneyService")
public class MemberMoneyService extends BaseService<MemberMoney> {
}
