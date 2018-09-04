package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.IDeptServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * 部门管理远程实现类
 * Created by liubin on 2017/9/20 18:32.
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface DeptRemoteService extends IDeptServiceFacade {
}
