package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.IOrderRefundServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/4/10 0010.
 */
@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface OrderRefundRemoteService extends IOrderRefundServiceFacade {
}
