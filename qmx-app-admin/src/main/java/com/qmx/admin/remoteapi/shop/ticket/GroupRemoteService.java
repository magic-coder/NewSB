package com.qmx.admin.remoteapi.shop.ticket;

import com.qmx.shop.api.facade.ticket.IGroupServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface GroupRemoteService extends IGroupServiceFacade {
}
