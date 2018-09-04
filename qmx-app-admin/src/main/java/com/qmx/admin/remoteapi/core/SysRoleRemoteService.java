package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.ISysRoleServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * 角色远程服务
 * Created by liubin on 2017/9/27 11:57.
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysRoleRemoteService extends ISysRoleServiceFacade {
}
