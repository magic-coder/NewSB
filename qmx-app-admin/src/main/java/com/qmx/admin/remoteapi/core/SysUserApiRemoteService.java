package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.ISysUserApiServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 用户接口远程实现类
 * @Date Created on 2018/2/9 15:22.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysUserApiRemoteService extends ISysUserApiServiceFacade {
}