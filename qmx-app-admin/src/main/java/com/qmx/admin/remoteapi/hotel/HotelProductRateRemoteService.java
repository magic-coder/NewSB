package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelProductRateServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2017/10/16 0016.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelProductRateRemoteService extends IHotelProductRateServiceFacade {
}
