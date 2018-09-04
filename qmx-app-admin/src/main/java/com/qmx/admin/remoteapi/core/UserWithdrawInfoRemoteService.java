package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.IUserWithdrawInfoServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 用户提现资料信息远程管理服务
 * @Date Created on 2018/1/23 9:46.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface UserWithdrawInfoRemoteService extends IUserWithdrawInfoServiceFacade {
}
