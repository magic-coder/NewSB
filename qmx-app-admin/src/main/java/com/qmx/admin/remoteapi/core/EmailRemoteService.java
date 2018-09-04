package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.message.email.facade.IEmailServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 邮件发送服务
 * @Date Created on 2017/12/14 15:26.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface EmailRemoteService extends IEmailServiceFacade {
}
