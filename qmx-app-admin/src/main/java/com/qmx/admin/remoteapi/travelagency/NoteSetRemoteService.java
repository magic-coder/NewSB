package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.INoteSetServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/3/30 0030.
 */
@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface NoteSetRemoteService extends INoteSetServiceFacade {
}
