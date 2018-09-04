package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.user.facade.IUserWithdrawServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 用户提现远程服务
 * @Date Created on 2018/1/23 9:47.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface UserWithdrawRemoteService extends IUserWithdrawServiceFacade {
}
