package com.qmx.admin.interceptor;
import com.qmx.admin.constants.ApiConstants;
import com.qmx.admin.controller.common.BaseApiController;
import com.qmx.base.core.constants.Constants;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.base.core.utils.WebUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.NamedThreadLocal;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author liubin
 * @Description api接口拦截器
 * @Date Created on 2017/12/20 14:53.
 * @Modified By
 */
public class SysApiInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(SysApiInterceptor.class);
    private NamedThreadLocal<Long> startTimeThreadLocal = new NamedThreadLocal<Long>("StopWatch-StartTime");
    private NamedThreadLocal<String> apiThreadLocal = new NamedThreadLocal<>("apiThreadLocal");

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        logger.info("进入api接口拦截器:" + request.getMethod() + " " + request.getRequestURI());
        getHeadersInfo(request);
        long beginTime = System.currentTimeMillis();//1、开始时间
        startTimeThreadLocal.set(beginTime);//线程绑定变量（该数据只有当前请求的线程可见）
        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Object obj = handlerMethod.getBean();
        if (obj instanceof BaseApiController) {
            BaseApiController bean = (BaseApiController) obj;
            String appKey = bean.getAppKey(request);
            String apiName = bean.getApiName(request);
            apiThreadLocal.set(appKey);
            request.setAttribute(ApiConstants.API_NAME_ATTRIBUTE_NAME,apiName);
            String requestInfo = bean.getRequestStr(request);
            logger.info(appKey+"--request--"+request.getMethod()+"--"+apiName+"--content-->"+requestInfo);
            Boolean flag = bean.preHandle(request,response);
            if(!flag){
                String resp = request.getAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME)+"";
                request.removeAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME);
                logger.info(appKey+"--"+apiName+"--response-->"+resp);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write(resp);
            }
            return flag;
        }
        return true;
    }

    /**
     * 获取header信息
     * @param request
     */
    private static void getHeadersInfo(HttpServletRequest request) {
        //Map<String, String> map = new HashMap<String, String>();
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String key = headerNames.nextElement();
            String value = request.getHeader(key);
            logger.info("header-key:"+key+"-->"+value);
            //map.put(key, value);
        }
    }

    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        long endTime = System.currentTimeMillis();//2、结束时间
        long beginTime = startTimeThreadLocal.get();//得到线程绑定的局部变量（开始时间）
        long consumeTime = endTime - beginTime;//3、消耗的时间
        // 记录到日志文件
        String appKey = apiThreadLocal.get();
        String apiName = (String)request.getAttribute(ApiConstants.API_NAME_ATTRIBUTE_NAME);
        String resp = request.getAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME)+"";
        request.removeAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME);
        request.removeAttribute(ApiConstants.API_NAME_ATTRIBUTE_NAME);
        logger.info(appKey+"--"+apiName+"--response-->"+resp);
        String requestUri = request.getRequestURI();
        String message = "开始时间: {}; 结束时间: {}; 耗时: {}ms; Method:{}; URI: {};Status:{}; Host:{}; ";
        logger.info(message, DateUtil.format(beginTime, "HH:mm:ss.SSS"),
                DateUtil.format(endTime, "HH:mm:ss.SSS"), consumeTime,
                request.getMethod(), requestUri, response.getStatus(), WebUtil.getHost(request));
    }

}