package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IRefundInformServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2017/12/6 0006.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface RefundInformRemoteService extends IRefundInformServiceFacade {
}
