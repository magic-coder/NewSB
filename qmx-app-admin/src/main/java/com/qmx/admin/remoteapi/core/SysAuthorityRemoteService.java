package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.ISysAuthorityServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 用户权限远程管理
 * @Date Created on 2018/4/2 10:54.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysAuthorityRemoteService extends ISysAuthorityServiceFacade {
}
