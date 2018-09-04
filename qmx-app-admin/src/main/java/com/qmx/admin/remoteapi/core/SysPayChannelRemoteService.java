package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.pay.facade.ISysPayChannelServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 支付渠道管理
 * @Date Created on 2017/12/29 16:28.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysPayChannelRemoteService extends ISysPayChannelServiceFacade {
}
