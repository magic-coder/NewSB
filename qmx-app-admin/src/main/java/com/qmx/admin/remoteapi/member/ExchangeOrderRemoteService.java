package com.qmx.admin.remoteapi.member;

import com.qmx.member.api.facade.IExchangeOrderServiceFacade;
import com.qmx.member.api.facade.IExchangeServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.memberservice.name}")
public interface ExchangeOrderRemoteService extends IExchangeOrderServiceFacade{
}
