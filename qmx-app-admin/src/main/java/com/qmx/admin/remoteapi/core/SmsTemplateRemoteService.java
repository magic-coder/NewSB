package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.message.sms.facade.ISmsTemplateFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 短信模板管理
 * @Date Created on 2017/11/30 15:01.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.coreservice.name}")
public interface SmsTemplateRemoteService extends ISmsTemplateFacade {
}