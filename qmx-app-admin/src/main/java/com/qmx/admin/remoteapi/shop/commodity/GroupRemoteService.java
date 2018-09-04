package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.IGroupServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/8  11:00
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface GroupRemoteService extends IGroupServiceFacade {
}
