package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysBookRuleServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 预定规则管理
 * @Date Created on 2018/2/2 14:04.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface BookRuleRemoteService extends ISysBookRuleServiceFacade {
}