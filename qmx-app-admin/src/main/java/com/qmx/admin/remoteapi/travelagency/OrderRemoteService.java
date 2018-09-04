package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.IOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface OrderRemoteService extends IOrderServiceFacade {
}