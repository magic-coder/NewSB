package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.IOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by zcl on 2018/1/4.
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface OrderRemoteService extends IOrderServiceFacade {
}
