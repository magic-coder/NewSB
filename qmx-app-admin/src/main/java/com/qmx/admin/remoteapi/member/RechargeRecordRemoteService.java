package com.qmx.admin.remoteapi.member;

import com.qmx.member.api.facade.IRechargeRecordServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

@FeignClient("${com.qmx.eureka.memberservice.name}")
public interface RechargeRecordRemoteService extends IRechargeRecordServiceFacade {
}
