package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelOrderCheckServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by zcl on 2017/10/31.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelOrderCheckRemoteService extends IHotelOrderCheckServiceFacade{
}
