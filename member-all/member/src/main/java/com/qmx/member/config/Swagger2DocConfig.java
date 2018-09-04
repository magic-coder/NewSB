package com.qmx.member.config;

import io.swagger.annotations.ApiOperation;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

/**
 * Swagger2 配置
 * Created by liubin on 2017/9/1 14:54.
 */
@Configuration
@EnableSwagger2
public class Swagger2DocConfig {
    /**
     * apis()可以指定有某个注解的方法需要生成API文档，还可以指定扫描哪个包来生成文档
     * 比如：apis(RequestHandlerSelectors.basePackage("com.demo.web.controller"))
     */
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo()).select()
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                .paths(PathSelectors.any()).build();
    }


    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("会员系统接口文档").description("会员系统接口文档")
                .contact(new Contact("liubin", "暂无", "email.com"))
                .termsOfServiceUrl("http://gds.qmx.com")
                .version("1.0.0").build();
    }
}
