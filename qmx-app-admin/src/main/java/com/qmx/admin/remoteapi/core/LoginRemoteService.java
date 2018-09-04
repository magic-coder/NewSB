package com.qmx.admin.remoteapi.core;
import com.qmx.coreservice.api.user.facade.ILoginServiceFacade;
import org.springframework.cloud.netflix.feign.FeignClient;

/**
 * 登录服务远程接口
 * Created by liubin on 2017/8/29.
 */
@FeignClient("${com.qmx.eureka.coreservice.name}")
public interface LoginRemoteService extends ILoginServiceFacade {
}
