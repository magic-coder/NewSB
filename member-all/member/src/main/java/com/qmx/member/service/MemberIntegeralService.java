package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.model.MemberIntegeral;
import com.qmx.member.model.RechargeRecord;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

@Service
@CacheConfig(cacheNames = "memberIntegeralService")
public class MemberIntegeralService extends BaseService<MemberIntegeral> {
}
