package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.IAchievementsInfoServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/3/14 0014.
 */
@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface AchievementsInfoRemoteService extends IAchievementsInfoServiceFacade {
}
