package com.qmx.admin.remoteapi.teamticket;

import com.qmx.teamticket.api.facade.ITtAchievementsBillServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * Created by earnest on 2018/5/21 0021.
 */
@FeignClient(name = "${com.qmx.eureka.teamticketservice.name}")
public interface TtAchievementsBillRemoteService extends ITtAchievementsBillServiceFacade {
}
