package com.qmx.admin.remoteapi.member;

import com.qmx.member.api.facade.IRechargeRuleServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.memberservice.name}")
public interface RechargeRuleRemoteService extends IRechargeRuleServiceFacade {
}
