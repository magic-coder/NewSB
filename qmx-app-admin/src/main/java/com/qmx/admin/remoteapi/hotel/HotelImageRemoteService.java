package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelImageServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2017/10/17 0017.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelImageRemoteService extends IHotelImageServiceFacade {
}
