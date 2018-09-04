package com.qmx.admin.remoteapi.teamticket;

import com.qmx.teamticket.api.facade.ITtProductRuleServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.teamticketservice.name}")
public interface TtProductRuleRemoteService extends ITtProductRuleServiceFacade {
}
