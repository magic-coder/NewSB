package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.ISysMenuServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * 菜单服务实现接口
 * Created by liubin on 2017/9/19.
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysMenuRemoteService extends ISysMenuServiceFacade {
}
