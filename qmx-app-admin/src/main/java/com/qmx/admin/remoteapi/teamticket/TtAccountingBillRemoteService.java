package com.qmx.admin.remoteapi.teamticket;

import com.qmx.teamticket.api.facade.ITtAccountingBillServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/5/2 0002.
 */
@FeignClient(name = "${com.qmx.eureka.teamticketservice.name}")
public interface TtAccountingBillRemoteService extends ITtAccountingBillServiceFacade {
}
