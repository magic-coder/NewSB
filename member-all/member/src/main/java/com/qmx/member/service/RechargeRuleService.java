package com.qmx.member.service;

import com.qmx.member.api.dto.RechargeRuleDto;
import com.qmx.member.api.enumerate.RuleType;
import com.qmx.base.core.base.BaseService;
import com.qmx.member.mapper.RechargeRuleMapper;
import com.qmx.member.model.RechargeRule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@CacheConfig(cacheNames = "rechargeRuleService")
public class RechargeRuleService extends BaseService<RechargeRule> {

    @Autowired
    private RechargeRuleMapper rechargeRuleMapper;

    public List<RechargeRule> findByLevelId(Long levelId){
        return rechargeRuleMapper.findByLevelId(levelId);
    }
    public List<RechargeRule> findRules(RechargeRuleDto dto){
        return rechargeRuleMapper.findRules(dto);
    }

    public void delByLevenId(Long id) {
        rechargeRuleMapper.delByLevenId(id);
    }
}
