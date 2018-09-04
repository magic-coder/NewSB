package com.qmx.admin.remoteapi.member;

import com.qmx.member.api.facade.IMemberServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.memberservice.name}")
public interface MemberRemoteService extends IMemberServiceFacade {
}
