package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelInfoServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelInfoRemoteService extends IHotelInfoServiceFacade {
}
