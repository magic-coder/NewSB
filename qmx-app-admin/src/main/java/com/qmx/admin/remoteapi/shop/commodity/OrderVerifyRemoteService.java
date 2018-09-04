package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.IOrderVerifyServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by zcl on 2018/1/6.
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface OrderVerifyRemoteService extends IOrderVerifyServiceFacade {
}
