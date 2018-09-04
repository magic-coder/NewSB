package com.qmx.admin.remoteapi.marketing;

import com.qmx.marketing.api.facade.IWxLuckdrawServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.marketingservice.name}")
public interface WxLuckdrawRemoteService extends IWxLuckdrawServiceFacade {
}
