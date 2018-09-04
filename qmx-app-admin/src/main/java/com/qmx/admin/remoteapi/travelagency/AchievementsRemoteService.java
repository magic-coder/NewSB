package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.IAchievementsServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface AchievementsRemoteService extends IAchievementsServiceFacade {
}
