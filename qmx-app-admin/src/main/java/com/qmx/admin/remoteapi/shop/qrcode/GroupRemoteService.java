package com.qmx.admin.remoteapi.shop.qrcode;

import com.qmx.shop.api.facade.qrcode.IGroupServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface GroupRemoteService extends IGroupServiceFacade {
}
