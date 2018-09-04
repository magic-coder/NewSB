package com.qmx.admin.remoteapi.member;

import com.qmx.member.api.facade.IConsumptionServiceFacade;
import com.qmx.member.api.facade.IDiscountServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.memberservice.name}")
public interface DiscountRemoteService extends IDiscountServiceFacade {
}
