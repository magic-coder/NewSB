package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysOpenApiServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface SysOpenApiRemoteService extends ISysOpenApiServiceFacade {
}
