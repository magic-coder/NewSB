package com.qmx.admin.remoteapi.marketing;

import com.qmx.marketing.api.facade.IWxLuckdrawParticipateServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.marketingservice.name}")
public interface WxLuckdrawParticipateRemoteService extends IWxLuckdrawParticipateServiceFacade {
}
