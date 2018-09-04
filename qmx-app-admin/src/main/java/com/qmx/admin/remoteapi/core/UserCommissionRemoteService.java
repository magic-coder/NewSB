package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.IUserCommissionFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 用户佣金远程实现类
 * @Date Created on 2018/3/24 16:55.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface UserCommissionRemoteService extends IUserCommissionFacade {
}
