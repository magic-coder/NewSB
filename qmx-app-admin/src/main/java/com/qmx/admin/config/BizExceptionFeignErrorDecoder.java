package com.qmx.admin.config;

import com.netflix.hystrix.exception.HystrixBadRequestException;
import feign.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Configuration;

/**
 * @Author liubin
 * @Description
 * 要特别注意，对于restful抛出的4xx的错误，也许大部分是业务异常，
 * 并不是服务提供方的异常，因此在进行feign client调用的时候，需要进行errorDecoder去处理，
 * 适配为HystrixBadRequestException，好避开circuit breaker的统计，否则就容易误判，
 * 传几个错误的参数，立马就熔断整个服务了，后果不堪设想。
 * @Date Created on 2017/12/4 10:00.
 * @Modified By
 */
@Configuration
public class BizExceptionFeignErrorDecoder implements feign.codec.ErrorDecoder{

    private static final Logger logger = LoggerFactory.getLogger(BizExceptionFeignErrorDecoder.class);

    @Override
    public Exception decode(String methodKey, Response response) {
        logger.warn(methodKey+":"+response.status());
        if(response.status() >= 400 && response.status() <= 499){
            return new HystrixBadRequestException(response.status()+":"+response.reason());
        }
        return feign.FeignException.errorStatus(methodKey, response);
    }
}