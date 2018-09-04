package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysTicketsTypeServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 票型管理
 * @Date Created on 2017/11/30 9:48.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface TicketsTypeRemoteService extends ISysTicketsTypeServiceFacade {
}