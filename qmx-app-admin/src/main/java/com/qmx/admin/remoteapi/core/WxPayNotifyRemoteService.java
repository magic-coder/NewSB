package com.qmx.admin.remoteapi.core;

import com.qmx.coreservice.api.pay.facade.IWxPayNotifyServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author liubin
 * @Description 微信支付通知
 * @Date Created on 2018/1/3 18:13.
 * @Modified By
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface WxPayNotifyRemoteService extends IWxPayNotifyServiceFacade {
}
