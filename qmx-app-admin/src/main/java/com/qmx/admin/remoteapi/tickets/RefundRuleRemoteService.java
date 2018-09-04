package com.qmx.admin.remoteapi.tickets;

import com.qmx.tickets.api.facade.ISysRefundRuleServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 退款规则远程管理
 * @Date Created on 2018/2/2 14:05.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.ticketservice.name}")
public interface RefundRuleRemoteService extends ISysRefundRuleServiceFacade {
}