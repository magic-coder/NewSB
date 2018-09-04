package com.qmx.admin.remoteapi.wx;

import com.qmx.wxbasics.api.facade.IWxUserServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.wxbasiceservice.name}")
public interface WxUserRemoteService extends IWxUserServiceFacade {
}
