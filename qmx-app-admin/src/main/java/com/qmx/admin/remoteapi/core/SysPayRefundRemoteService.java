package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.pay.facade.IPayRefundServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 支付退款远程实现类
 * @Date Created on 2018/1/2 15:32.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface SysPayRefundRemoteService extends IPayRefundServiceFacade {
}
