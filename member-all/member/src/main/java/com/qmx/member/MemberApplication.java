package com.qmx.member;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.feign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@EnableDiscoveryClient
@EnableAspectJAutoProxy
@SpringBootApplication
@EnableTransactionManagement
@ComponentScan(basePackages = "com.qmx")
@EnableFeignClients(basePackages = "com.qmx")
@EnableScheduling
public class MemberApplication {
    protected final static Logger logger = LoggerFactory.getLogger(MemberApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(MemberApplication.class, args);

        logger.info("sussess!");
        System.err.println("sample started. http://localhost:7001/");
        System.err.println("文档. http://localhost:7001/doc.html");
        System.err.println("文档. http://localhost:7001/swagger-ui.html");
    }
}
