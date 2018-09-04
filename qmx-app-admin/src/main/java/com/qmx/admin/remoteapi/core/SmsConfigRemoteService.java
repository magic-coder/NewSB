package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.message.sms.facade.ISmsConfigFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 短信配置管理
 * @Date Created on 2017/12/25 18:19.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SmsConfigRemoteService extends ISmsConfigFacade {
}
