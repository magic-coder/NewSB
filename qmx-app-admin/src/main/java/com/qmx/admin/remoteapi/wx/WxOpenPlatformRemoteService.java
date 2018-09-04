package com.qmx.admin.remoteapi.wx;

import com.qmx.wxbasics.api.facade.IWxOpenPlatformServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.wxbasiceservice.name}")
public interface WxOpenPlatformRemoteService extends IWxOpenPlatformServiceFacade {
}
