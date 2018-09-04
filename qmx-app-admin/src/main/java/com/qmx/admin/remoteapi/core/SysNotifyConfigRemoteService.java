package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.ISysNotifyConfigServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 系统通知配置远程实现类
 * @Date Created on 2018/1/12 16:54.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysNotifyConfigRemoteService extends ISysNotifyConfigServiceFacade {
}
