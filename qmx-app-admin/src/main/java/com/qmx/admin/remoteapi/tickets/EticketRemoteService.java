package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysEticketServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 电子票管理
 * @Date Created on 2017/12/11 14:55.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface EticketRemoteService extends ISysEticketServiceFacade {
}