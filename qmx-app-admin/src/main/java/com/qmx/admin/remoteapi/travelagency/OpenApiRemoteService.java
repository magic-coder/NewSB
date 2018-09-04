package com.qmx.admin.remoteapi.travelagency;

import com.alibaba.fastjson.JSONArray;
import com.qmx.travelagency.api.facade.IOpenApiServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

import java.util.List;

@FeignClient("${com.qmx.eureka.travelagency.name}")
public interface OpenApiRemoteService extends IOpenApiServiceFacade {

}