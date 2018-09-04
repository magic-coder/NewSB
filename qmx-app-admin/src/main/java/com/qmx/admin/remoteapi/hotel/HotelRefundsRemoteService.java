package com.qmx.admin.remoteapi.hotel;

import com.qmx.hotel.api.facade.IHotelRefundsServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by zcl on 2017/10/25.
 */
@FeignClient("${com.qmx.eureka.hotelservice.name}")
public interface HotelRefundsRemoteService extends IHotelRefundsServiceFacade{
}
