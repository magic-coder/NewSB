package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.ISysMessageFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 系统消息远程实现类
 * @Date Created on 2018/3/26 18:01.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysMessageRemoteService extends ISysMessageFacade {
}
