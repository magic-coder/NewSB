package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.IUserDepositServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 用户预存款远程服务
 * @Date Created on 2018/1/25 16:04.
 * @Modified By
 */
@FeignClient(name = "${com.qmx.eureka.coreservice.name}")
public interface SysUserDepositRemoteService extends IUserDepositServiceFacade {
}
