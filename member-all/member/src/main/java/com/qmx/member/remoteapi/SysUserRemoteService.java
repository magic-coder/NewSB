package com.qmx.member.remoteapi;

import com.qmx.coreservice.api.user.facade.ISysUserServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by liubin on 2017/8/22.
 */
@FeignClient(
        name = "${com.qmx.eureka.coreservice.name}"
)
public interface SysUserRemoteService extends ISysUserServiceFacade {
}
