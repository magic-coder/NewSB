package com.qmx.admin.remoteapi.teamticket;

import com.qmx.teamticket.api.facade.ITtOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.teamticketservice.name}")
public interface TtOrderRemoteService extends ITtOrderServiceFacade {
}
