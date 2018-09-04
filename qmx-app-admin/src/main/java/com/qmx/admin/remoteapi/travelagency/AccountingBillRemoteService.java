package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.IAccountingBillServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/5/2 0002.
 */
@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface AccountingBillRemoteService extends IAccountingBillServiceFacade {
}
