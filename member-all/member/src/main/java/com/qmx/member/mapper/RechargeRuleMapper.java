package com.qmx.member.mapper;

import com.qmx.member.api.dto.RechargeRuleDto;
import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.RechargeRule;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RechargeRuleMapper extends IBaseMapper<RechargeRule> {

    List<RechargeRule> findByLevelId(@Param("levelId") Long levelId);

    List<RechargeRule> findRules(@Param("dto") RechargeRuleDto dto);

    void delByLevenId(@Param("id") Long id);
}
