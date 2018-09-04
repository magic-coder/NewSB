package com.qmx.admin.config;
import com.qmx.base.core.freemarker.CustomFreemarkerView;
import com.qmx.base.core.freemarker.shirotag.ShiroTags;
import freemarker.template.Configuration;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;

/**
 * freemarker shiro 标签配置
 * Created by liubin on 2017/9/7 15:48.
 */
@Component
public class FreeMarkerCustomConfig implements InitializingBean {

    @Autowired
    private Configuration configuration;

    @Override
    public void afterPropertiesSet() throws Exception {
        //加上这句后，可以在页面上使用shiro标签
        configuration.setSharedVariable("shiro", new ShiroTags());
        //数字格式化
        //configuration.setNumberFormat("0.##");

    }

    /**
     * 增加自定义视图变量和方法
     *
     * @return
     */
    @Bean
    public CommandLineRunner customFreemarker(FreeMarkerViewResolver resolver) {
        return new CommandLineRunner() {
            @Override
            public void run(String... strings) throws Exception {
                //增加视图
                resolver.setViewClass(CustomFreemarkerView.class);
                //添加自定义解析器
               // Map map = resolver.getAttributesMap();
               // map.put("conver", new MyConver());
            }
        };
    }
}
