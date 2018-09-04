package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 订单管理
 * @Date Created on 2017/12/8 11:53.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface TicketsOrderServiceRemoteService extends ISysOrderServiceFacade {
}