package com.qmx.admin.config;
import com.aliyun.openservices.ons.api.MessageListener;
import com.aliyun.openservices.ons.api.bean.ConsumerBean;
import com.aliyun.openservices.ons.api.bean.Subscription;
import com.qmx.admin.listener.AppAdminNotifyListener;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * @Author liubin
 * @Description 阿里云消息队列配置
 * @Date Created on 2018/5/8 11:01.
 * @Modified By
 */
@Configuration
@ConditionalOnProperty(prefix = "com.qmx", name = "open-aliyun-mq", havingValue = "true")
public class AliyunONSConfig {

    @Value("${com.qmx.aliyunons.producerId}")
    private String producerId;
    @Value("${com.qmx.aliyunons.consumerId}")
    private String consumerId;
    @Value("${com.qmx.aliyunons.accessKey}")
    private String accessKey;
    @Value("${com.qmx.aliyunons.secretKey}")
    private String secretKey;
    @Value("${com.qmx.aliyunons.onsAddr}")
    private String onsAddr;
    @Value("${com.qmx.aliyunons.topic}")
    private String mqTopic;

    @Bean("appAdminNotifyListener")
    public AppAdminNotifyListener getAppAdminNotifyListener(){
        return new AppAdminNotifyListener();
    }

    @Bean(value = "aliyunONSConsumer",initMethod = "start",destroyMethod = "shutdown")
    public ConsumerBean getConsumerBean(){
        ConsumerBean consumerBean = new ConsumerBean();
        Properties properties = new Properties();
        properties.setProperty("ConsumerId",consumerId);
        properties.setProperty("AccessKey",accessKey);
        properties.setProperty("SecretKey",secretKey);
        //properties.setProperty("ONSAddr",onsAddr);
        consumerBean.setProperties(properties);
        Subscription subscription = new Subscription();
        subscription.setExpression("*");
        subscription.setTopic(mqTopic);
        Map<Subscription,MessageListener> messageListenerMap = new HashMap<>();
        messageListenerMap.put(subscription,getAppAdminNotifyListener());
        consumerBean.setSubscriptionTable(messageListenerMap);
        return consumerBean;
    }
}
