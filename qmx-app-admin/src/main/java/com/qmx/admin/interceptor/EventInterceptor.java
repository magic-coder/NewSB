package com.qmx.admin.interceptor;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.base.core.utils.WebUtil;
import cz.mallat.uasparser.OnlineUpdater;
import cz.mallat.uasparser.UASparser;
import cz.mallat.uasparser.UserAgentInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.NamedThreadLocal;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Author liubin
 * @Description 日志拦截器
 * @Date Created on 2017/12/26 9:12.
 * @Modified By
 */
public class EventInterceptor extends HandlerInterceptorAdapter {
    protected static Logger logger = LoggerFactory.getLogger(EventInterceptor.class);

    private final ThreadLocal<Long> startTimeThreadLocal = new NamedThreadLocal<Long>("ThreadLocal StartTime");
    static UASparser uasParser = null;

    // 初始化uasParser对象
    static {
        try {
            uasParser = new UASparser(OnlineUpdater.getVendoredInputStream());
        } catch (IOException e) {
            logger.error("", e);
        }
    }

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        // 开始时间（该数据只有当前请求的线程可见）
        startTimeThreadLocal.set(System.currentTimeMillis());
        return super.preHandle(request, response, handler);
    }

    public void afterCompletion(final HttpServletRequest request, HttpServletResponse response, Object handler,
                                final Exception ex) throws Exception {
        final Long startTime = startTimeThreadLocal.get();
        final Long endTime = System.currentTimeMillis();
        // 保存日志
        String userAgent = null;
        try {
            UserAgentInfo userAgentInfo = uasParser.parse(request.getHeader("user-agent"));
            userAgent = userAgentInfo.getOsName() + " " + userAgentInfo.getType() + " " + userAgentInfo.getUaName();
            //String str = JSONUtil.toJson(userAgentInfo);
            //logger.info("UserAgentInfo:" + str);
        } catch (IOException e) {
            logger.error("", e);
        }
        //String path = request.getServletPath();
        String requestUri = request.getRequestURI();
        try {
            String message = "开始时间: {}; 结束时间: {}; 耗时: {}ms; Method:{}; URI: {};Status:{};userAgent:{};Host:{}; ";
            logger.info(message, DateUtil.format(startTime, "HH:mm:ss.SSS"),
                    DateUtil.format(endTime, "HH:mm:ss.SSS"), (endTime - startTime),
                    request.getMethod(), requestUri, response.getStatus(), userAgent, WebUtil.getHost(request));
        } catch (Exception e) {
            logger.error("Save event log cause error :", e);
        }
        super.afterCompletion(request, response, handler, ex);
    }
}
