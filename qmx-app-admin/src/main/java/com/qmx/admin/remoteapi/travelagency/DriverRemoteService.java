package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.IDriverServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface DriverRemoteService extends IDriverServiceFacade {
}