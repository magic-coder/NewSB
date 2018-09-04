package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.message.sms.facade.ISmsFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 短信管理
 * @Date Created on 2017/12/27 16:47.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SmsRemoteService extends ISmsFacade {
}
