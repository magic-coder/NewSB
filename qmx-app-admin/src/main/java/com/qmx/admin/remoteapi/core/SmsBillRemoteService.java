package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.message.sms.facade.ISmsBillFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 短信账单管理
 * @Date Created on 2018/3/22 13:55.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SmsBillRemoteService extends ISmsBillFacade {
}
