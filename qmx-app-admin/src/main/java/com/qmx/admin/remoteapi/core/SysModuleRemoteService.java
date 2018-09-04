package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.ISysModuleServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by liubin on 2017/9/11 13:26.
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysModuleRemoteService extends ISysModuleServiceFacade {
}
