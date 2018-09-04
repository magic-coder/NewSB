package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.IUserChargeInfoServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 用户费用信息管理
 * @Date Created on 2018/3/22 15:46.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface UserChargeInfoRemoteService extends IUserChargeInfoServiceFacade {
}
