package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.ISysPermissionServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * 权限远程服务
 * Created by liubin on 2017/8/24.
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysPermissionRemoteService extends ISysPermissionServiceFacade {
}
