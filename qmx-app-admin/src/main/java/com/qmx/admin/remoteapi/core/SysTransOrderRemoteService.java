package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.pay.facade.ISysTransOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 支付转账远程实现类
 * @Date Created on 2018/2/7 17:14.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysTransOrderRemoteService extends ISysTransOrderServiceFacade {
}
