package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.ISysOrderSourceServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 订单来源管理
 * @Date Created on 2017/12/8 11:08.
 * @Modified By
 */
@FeignClient(value = "${com.qmx.eureka.coreservice.name}")
public interface SysOrderSourceRemoteService extends ISysOrderSourceServiceFacade {
}