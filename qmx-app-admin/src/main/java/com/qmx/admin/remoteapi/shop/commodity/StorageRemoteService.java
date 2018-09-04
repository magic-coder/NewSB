package com.qmx.admin.remoteapi.shop.commodity;

import com.qmx.shop.api.facade.commodity.IStorageServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/22  9:36
 */
@FeignClient("${com.qmx.eureka.shopservice.name}")
public interface StorageRemoteService extends IStorageServiceFacade {
}
