package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelRoomTypeServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2017/10/13 0013.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelRoomTypeRemoteService extends IHotelRoomTypeServiceFacade {
}
