package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ITicketsStockServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 门票库存管理
 * @Date Created on 2017/12/19 15:04.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface TicketsStockRemoteService extends ITicketsStockServiceFacade {
}