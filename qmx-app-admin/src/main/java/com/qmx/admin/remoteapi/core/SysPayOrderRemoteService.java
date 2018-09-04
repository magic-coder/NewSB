package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.pay.facade.IPayOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 支付远程实现类
 * @Date Created on 2017/12/7 11:20.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysPayOrderRemoteService extends IPayOrderServiceFacade {
}
