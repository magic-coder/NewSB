package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.ICategoryServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/5  11:38
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface CategoryRemoteService extends ICategoryServiceFacade {
}
