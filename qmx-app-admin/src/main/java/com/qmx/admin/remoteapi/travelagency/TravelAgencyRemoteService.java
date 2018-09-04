package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.ITravelAgencyServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface TravelAgencyRemoteService extends ITravelAgencyServiceFacade {
}