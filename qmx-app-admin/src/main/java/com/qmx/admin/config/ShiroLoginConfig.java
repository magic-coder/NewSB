package com.qmx.admin.config;
import com.qmx.admin.shiro.ShiroLoginRealm;
import com.qmx.admin.shiro.ShiroRedisCacheManager;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.spring.LifecycleBeanPostProcessor;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.CookieRememberMeManager;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.apache.shiro.web.servlet.SimpleCookie;
import org.apache.shiro.web.session.mgt.ServletContainerSessionManager;
import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
import org.springframework.beans.factory.config.MethodInvokingFactoryBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.LinkedHashMap;
import java.util.Map;

@Configuration
public class ShiroLoginConfig {

    /**
     * cookie对象;
     * @return
     */
    @Bean
    public SimpleCookie rememberMeCookie(){
        //这个参数是cookie的名称，对应前端的checkbox的name = rememberMe
        SimpleCookie simpleCookie = new SimpleCookie("rememberMe");
        //<!-- 记住我cookie生效时间30天 ,单位秒;-->
        simpleCookie.setHttpOnly(true);
        simpleCookie.setMaxAge(259200);
        return simpleCookie;
    }

    /**
     * cookie管理对象;
     * @return
     */
    @Bean
    public CookieRememberMeManager rememberMeManager(){
        CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        //cookieRememberMeManager.setCipherKey(Base64.decode("Z3VucwAAAAAAAAAAAAAAAA=="));
        cookieRememberMeManager.setCookie(rememberMeCookie());
        return cookieRememberMeManager;
    }

    /**
     * 缓存管理器.
     * @return
     */
    @Bean
    public ShiroRedisCacheManager shiroRedisCacheManager() {
        return new ShiroRedisCacheManager();
    }


    /**
     * 身份认证realm;
     * (这个需要自己写，账号密码校验；权限等)
     * @return
     */
    @Bean
    public ShiroLoginRealm myShiroRealm(){
        ShiroLoginRealm myShiroRealm = new ShiroLoginRealm();
        return myShiroRealm;
    }

    @Bean(name="securityManager")
    public SecurityManager securityManager(){
        //安全管理器
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
        securityManager.setRealm(myShiroRealm());
        //rememberme
        securityManager.setRememberMeManager(rememberMeManager());
        securityManager.setSessionManager(servletContainerSessionManager());
        securityManager.setCacheManager(shiroRedisCacheManager());
        return securityManager;
    }

    @Bean
    public ServletContainerSessionManager servletContainerSessionManager(){
        return new ServletContainerSessionManager();
    }

    @Bean
    public ShiroFilterFactoryBean getShiroFilterFactoryBean(SecurityManager securityManager){
        ShiroFilterFactoryBean shiroFilterFactoryBean  = new ShiroFilterFactoryBean();
        // 必须设置 SecurityManager
        shiroFilterFactoryBean.setSecurityManager(securityManager);
        //拦截器.
        Map<String,String> filterChainDefinitionMap = new LinkedHashMap<>();
        //配置退出过滤器,其中的具体的退出代码Shiro已经替我们实现了
        filterChainDefinitionMap.put("/logout", "logout");
        //<!-- 过滤链定义，从上向下顺序执行，一般将 /**放在最为下边 -->
        //swagger
        filterChainDefinitionMap.put("/swagger*","anon");
        filterChainDefinitionMap.put("/*/api-docs","anon");
        filterChainDefinitionMap.put("/webjars/**","anon");
        //静态资源
        filterChainDefinitionMap.put("/assets/**", "anon");
        filterChainDefinitionMap.put("/css/**", "anon");
        filterChainDefinitionMap.put("/font/**", "anon");
        filterChainDefinitionMap.put("/js/**", "anon");
        filterChainDefinitionMap.put("/slider_files/**","anon");
        filterChainDefinitionMap.put("/403", "anon");
        filterChainDefinitionMap.put("/error/**","anon");
        filterChainDefinitionMap.put("/resources/**","anon");

        //匿名访问地址
        filterChainDefinitionMap.put("/file/upload/**","anon");
        filterChainDefinitionMap.put("/login/updateUserPwdByEmail","anon");//通过邮箱修改密码
        filterChainDefinitionMap.put("/login/updatePwdSuccess","anon");//通过邮箱修改密码成功
        filterChainDefinitionMap.put("/login/sendForgetPwdEmailVerifyCode","anon");//忘记密码发送邮件验证码
        filterChainDefinitionMap.put("/login/forgetPassword","anon");//忘记密码页面
        filterChainDefinitionMap.put("/login/bindEmailSuccess","anon");//绑定邮件成功页面
        filterChainDefinitionMap.put("/login/bindUserEmail","anon");//绑定邮箱
        filterChainDefinitionMap.put("/login/sendBindEmailVerifyCode","anon");//发送绑定邮箱验证码
        filterChainDefinitionMap.put("/login/loginVerify","anon");//登录验证
        filterChainDefinitionMap.put("/login/submitLogin", "anon");//提交登录
        filterChainDefinitionMap.put("/login/ajaxLogin", "anon");//ajax登录
        filterChainDefinitionMap.put("/login/submitRegister", "anon");//提交注册
        filterChainDefinitionMap.put("/login/checkRegister", "anon");//检查注册
        filterChainDefinitionMap.put("/info","anon");
        filterChainDefinitionMap.put("/trace","anon");
        filterChainDefinitionMap.put("/common/**","anon");
        filterChainDefinitionMap.put("/0/**","anon");//二维码地址
        filterChainDefinitionMap.put("/1/**","anon");//二维码地址

        filterChainDefinitionMap.put("/api/**","anon");
        filterChainDefinitionMap.put("/open/**","anon");

        filterChainDefinitionMap.put("/tt/**","anon");
        filterChainDefinitionMap.put("/ta/m/**","authc");
        filterChainDefinitionMap.put("/ta/**","anon");


        //rememberMe
        filterChainDefinitionMap.put("/**", "user");
        //filterChainDefinitionMap.put("/**", "authc,user");
        // 如果不设置默认会自动寻找Web工程根目录下的"/login"页面
        shiroFilterFactoryBean.setLoginUrl("/login");
        // 登录成功后要跳转的链接
        //shiroFilterFactoryBean.setSuccessUrl("/main");
        //未授权界面;
        shiroFilterFactoryBean.setUnauthorizedUrl("/403");
        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);
        return shiroFilterFactoryBean;
    }

    @Bean
    public static LifecycleBeanPostProcessor getLifecycleBeanPostProcessor() {
        return new LifecycleBeanPostProcessor();
    }

    @Bean
    public MethodInvokingFactoryBean MethodInvokingFactoryBean(){
        MethodInvokingFactoryBean methodInvokingFactoryBean = new MethodInvokingFactoryBean();
        methodInvokingFactoryBean.setArguments(new Object[]{securityManager()});
        methodInvokingFactoryBean.setStaticMethod("org.apache.shiro.SecurityUtils.setSecurityManager");
        return methodInvokingFactoryBean;
    }

    /**
     *  开启shiro aop注解支持.
     *  使用代理方式,所以需要开启代码支持;
     * @return
     */
    @Bean
    public AuthorizationAttributeSourceAdvisor getAuthorizationAttributeSourceAdvisor() {
        AuthorizationAttributeSourceAdvisor aasa = new AuthorizationAttributeSourceAdvisor();
        aasa.setSecurityManager(securityManager());
        return aasa;//new AuthorizationAttributeSourceAdvisor();
    }

    @Bean
    public DefaultAdvisorAutoProxyCreator getDefaultAdvisorAutoProxyCreator() {
        DefaultAdvisorAutoProxyCreator daap = new DefaultAdvisorAutoProxyCreator();
        daap.setProxyTargetClass(true);
        return daap;
    }
}