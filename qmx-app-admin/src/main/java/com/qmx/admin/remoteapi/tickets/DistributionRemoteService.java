package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysDistributionServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 分销管理
 * @Date Created on 2017/12/5 17:35.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface DistributionRemoteService extends ISysDistributionServiceFacade {
}