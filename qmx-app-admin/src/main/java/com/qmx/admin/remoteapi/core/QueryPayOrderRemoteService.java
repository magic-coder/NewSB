package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.pay.facade.IQueryPayOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 支付查询远程服务类
 * @Date Created on 2018/1/8 15:26.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface QueryPayOrderRemoteService extends IQueryPayOrderServiceFacade {
}
