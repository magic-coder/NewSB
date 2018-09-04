package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelProductImpowerServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2017/11/10 0010.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelProductImpowerRemoteService extends IHotelProductImpowerServiceFacade {
}
