package com.qmx.admin.remoteapi.wx;


import com.qmx.wxbasics.api.facade.IWxWristbandConfigServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient(name = "${com.qmx.eureka.wxbasiceservice.name}")
public interface WxWristbandConfigRemoteService extends IWxWristbandConfigServiceFacade {
}
