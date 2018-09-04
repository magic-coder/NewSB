package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.mapper.MemberLevelMapper;
import com.qmx.member.model.MemberLevel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@CacheConfig(cacheNames = "memberLevelService")
public class MemberLevelService extends BaseService<MemberLevel> {

    @Autowired
    private MemberLevelMapper memberLevelMapper;
    @Autowired
    private RechargeRuleService rechargeRuleService ;
    @Autowired
    private ConsumptionService consumptionService ;
    @Autowired
    private DiscountService discountService ;


    public MemberLevel findByName(String name) {
        return memberLevelMapper.findByName(name);
    }

    @Transactional
    public void delAll(Long id, Long aLong) {
        this.del(id,aLong);
        rechargeRuleService.delByLevenId(id);
        consumptionService.delByLevenId(id);
        discountService.delByLevenId(id);

    }
}
