package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysTicketsServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 门票管理
 * @Date Created on 2017/12/1 14:26.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface TicketsRemoteService extends ISysTicketsServiceFacade {
}