package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.ISupplyRelationServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/5 0005 9:43
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface SupplyRelationRemoteService extends ISupplyRelationServiceFacade {
}
