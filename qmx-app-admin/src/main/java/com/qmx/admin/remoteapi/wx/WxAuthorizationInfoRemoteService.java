package com.qmx.admin.remoteapi.wx;

import com.qmx.wxbasics.api.facade.IWxAuthorizationInfoServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.wxbasiceservice.name}")
public interface WxAuthorizationInfoRemoteService extends IWxAuthorizationInfoServiceFacade {
}
