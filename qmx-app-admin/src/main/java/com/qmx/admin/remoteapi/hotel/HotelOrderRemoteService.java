package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelOrderServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by zcl on 2017/10/12.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelOrderRemoteService extends IHotelOrderServiceFacade{
}
