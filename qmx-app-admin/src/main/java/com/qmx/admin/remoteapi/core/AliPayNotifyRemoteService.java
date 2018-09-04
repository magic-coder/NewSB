package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.pay.facade.IAliPayNotifyServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 支付宝支付通知
 * @Date Created on 2018/1/3 18:13.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface AliPayNotifyRemoteService extends IAliPayNotifyServiceFacade {
}
