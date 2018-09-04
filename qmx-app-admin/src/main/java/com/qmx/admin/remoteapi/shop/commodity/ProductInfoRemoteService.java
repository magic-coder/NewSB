package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.IProductInfoServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/4 11:28
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface ProductInfoRemoteService extends IProductInfoServiceFacade {
}
