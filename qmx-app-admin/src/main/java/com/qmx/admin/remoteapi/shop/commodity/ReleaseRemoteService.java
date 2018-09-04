package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.IReleaseServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/10  14:54
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface ReleaseRemoteService extends IReleaseServiceFacade {
}
