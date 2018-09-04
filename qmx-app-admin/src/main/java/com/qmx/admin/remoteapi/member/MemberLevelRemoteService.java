package com.qmx.admin.remoteapi.member;

import com.qmx.member.api.facade.IMemberLevelServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.memberservice.name}")
public interface MemberLevelRemoteService extends IMemberLevelServiceFacade {
}
