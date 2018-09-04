package com.qmx.admin.remoteapi.shop.seat;

import com.qmx.shop.api.facade.seat.IOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/5/24 0024.
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface OrderRemoteService extends IOrderServiceFacade {
}
