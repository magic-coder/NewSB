package com.qmx.admin.config;
import com.qmx.admin.interceptor.*;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * @Author liubin
 * @Description
 * @Date Created on 2017/12/11 11:04.
 * @Modified By
 */
@Configuration
public class WebMvcConfig extends WebMvcConfigurerAdapter {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        /**
         * 系统Token拦截器
         */
        registry.addInterceptor(tokenInterceptor())
                .addPathPatterns("/**").excludePathPatterns("/open/**")
                .excludePathPatterns("/api/**")
                .excludePathPatterns("/error");

        /**
         * 系统open拦截器
         */
        registry.addInterceptor(openInterceptor()).addPathPatterns("/open/**");


        /**
         * 恶意请求拦截器
         */
        registry.addInterceptor(maliciousRequestInterceptor())
                .addPathPatterns("/**");


        /**
         * 系统api拦截器
         */
        registry.addInterceptor(sysApiInterceptor()).addPathPatterns("/api/**");

        /**
         * 系统访问日志拦截器
         */
        registry.addInterceptor(eventInterceptor()).addPathPatterns("/**");

        /**
         * 系统通知拦截器
         */
        registry.addInterceptor(messageNotifyInterceptor())
                .addPathPatterns("/**").excludePathPatterns("/open/**")
                .excludePathPatterns("/api/**");

        //列表参数保留
        registry.addInterceptor(listInterceptor()).addPathPatterns("/**");

        super.addInterceptors(registry);
    }

    /**
     * 系统Token拦截器
     * @return
     */
    @Bean
    TokenInterceptor tokenInterceptor(){
        return new TokenInterceptor();
    }

    /**
     * 系统open拦截器
     * @return
     */
    @Bean
    SysOpenInterceptor openInterceptor(){
        return new SysOpenInterceptor();
    }

    /**
     * 恶意请求拦截器
     * @return
     */
    @Bean
    MaliciousRequestInterceptor maliciousRequestInterceptor(){
        MaliciousRequestInterceptor maliciousRequestInterceptor=  new MaliciousRequestInterceptor();
        maliciousRequestInterceptor.setMaxMaliciousTimes(16);
        maliciousRequestInterceptor.setMinRequestIntervalTime(500L);
        return maliciousRequestInterceptor;
    }

    /**
     * 系统api拦截器
     * @return
     */
    @Bean
    SysApiInterceptor sysApiInterceptor(){
        return new SysApiInterceptor();
    }

    /**
     * 日志拦截器
     * @return
     */
    @Bean
    EventInterceptor eventInterceptor(){
        return new EventInterceptor();
    }

    @Bean
    MessageNotifyInterceptor messageNotifyInterceptor(){
        return new MessageNotifyInterceptor();
    }

    @Bean
    ListInterceptor listInterceptor(){
        return new ListInterceptor();
    }
}
