package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.ITravelagencyPrintRelationServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/3/20 0020.
 */
@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface TravelAgencyPrintRelationRemoteService extends ITravelagencyPrintRelationServiceFacade {
}
