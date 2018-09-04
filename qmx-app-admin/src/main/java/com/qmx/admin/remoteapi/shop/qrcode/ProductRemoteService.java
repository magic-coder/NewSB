package com.qmx.admin.remoteapi.shop.qrcode;

import com.qmx.shop.api.facade.qrcode.IProductServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface ProductRemoteService extends IProductServiceFacade {
}
