package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysSightServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 景区管理
 * @Date Created on 2017/11/27 14:30.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface SightRemoteService extends ISysSightServiceFacade {
}