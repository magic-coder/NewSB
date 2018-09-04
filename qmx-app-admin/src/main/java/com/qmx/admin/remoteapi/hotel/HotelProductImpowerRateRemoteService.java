package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelProductImpowerRateServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2017/11/13 0013.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelProductImpowerRateRemoteService extends IHotelProductImpowerRateServiceFacade {
}
