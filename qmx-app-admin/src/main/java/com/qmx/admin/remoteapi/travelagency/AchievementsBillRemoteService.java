package com.qmx.admin.remoteapi.travelagency;

import com.qmx.travelagency.api.facade.IAchievementsBillServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/4/28 0028.
 */
@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface AchievementsBillRemoteService extends IAchievementsBillServiceFacade {
}
