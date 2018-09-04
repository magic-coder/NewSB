package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.ISysAreaServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 地区管理远程实现类
 * @Date Created on 2017/11/28 14:43.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysAreaRemoteService extends ISysAreaServiceFacade {
}
