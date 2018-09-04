package com.qmx.admin.remoteapi.shop.common;

import com.qmx.shop.api.facade.common.IFlashViewServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/12  15:08
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface FlashViewRemoteService extends IFlashViewServiceFacade {
}
