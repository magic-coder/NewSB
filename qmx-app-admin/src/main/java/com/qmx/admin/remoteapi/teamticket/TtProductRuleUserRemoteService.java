package com.qmx.admin.remoteapi.teamticket;

import com.qmx.teamticket.api.facade.ITtProductRuleUserServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.teamticketservice.name}")
public interface TtProductRuleUserRemoteService extends ITtProductRuleUserServiceFacade {
}
