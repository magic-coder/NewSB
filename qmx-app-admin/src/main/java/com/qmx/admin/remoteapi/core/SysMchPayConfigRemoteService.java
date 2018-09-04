package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.pay.facade.ISysPayConfigServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 支付配置
 * @Date Created on 2017/12/29 16:26.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysMchPayConfigRemoteService extends ISysPayConfigServiceFacade {
}
