package com.qmx.admin.remoteapi.helpcenter;

import com.qmx.base.api.dto.RestResponse;
import com.qmx.helpcenter.api.dto.HelpDetailsDto;
import com.qmx.helpcenter.api.dto.HelpExplainDto;
import com.qmx.helpcenter.api.facade.IHelpDetailsServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
@FeignClient(name = "${com.qmx.eureka.helpcenter.name}")
public interface HelpDetailsService extends IHelpDetailsServiceFacade{
}
