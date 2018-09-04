package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.ISysDictServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 字典管理远程实现类
 * @Date Created on 2017/12/27 11:13.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysDictRemoteService extends ISysDictServiceFacade {
}
