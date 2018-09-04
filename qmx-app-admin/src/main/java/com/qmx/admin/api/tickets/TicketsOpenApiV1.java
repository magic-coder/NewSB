package com.qmx.admin.api.tickets;

import com.qmx.admin.controller.common.BaseOpenController;
import com.qmx.base.core.constants.Constants;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Author liubin
 * @Description 测试demo
 * 调用顺序：1.getAppKey
 * 调用顺序：2.getRequestStr
 * 调用顺序：3.preHandle
 * @Date Created on 2017/12/26 10:42.
 * @Modified By
 */
@RestController
@RequestMapping("/open/tickets/v1")
public class TicketsOpenApiV1 extends BaseOpenController {

    /**
     * 验证Api是否合法，返回false时必须设置返回内容
     * @param request
     * @param response
     * @return
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
        String req = (String)request.getAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME);
        if("0".equals(request.getParameter("flag"))){
            String resp = "验证失败是返回内容";
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME,resp);
            //response.getWriter().write(resp);这个方法不用实现，拦截器里已实现
            return false;
        }
        return true;
    }

    /**
     * 获取appkey
     * @param request
     * @return
     */
    @Override
    public String getAppKey(HttpServletRequest request) {
        return request.getParameter("appkey");
    }

    /**
     * 获取apiName
     * @param request
     * @return
     */
    @Override
    public String getApiName(HttpServletRequest request) {
        return request.getRequestURI();
    }

    /**
     * 获取请求内容
     * @param request
     * @return
     */
    @Override
    public String getRequestStr(HttpServletRequest request) {
        String body = request.getParameter(API_BODY);
        //存放请求内容，如果本类其他方法要使用请求内容(如果以流的方式接收的再次获取会报错拿不到数据)，可以用这个属性获取
        request.setAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME,body);
        //返回这个内容用于存储日志
        return body;
    }

    /**
     * 具体请求方法
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping("/demo")
    public Object demo(HttpServletRequest request){
        System.out.println("请求demo方法");
        String resp = "这里是返回内容";

        //设置返回日志
        request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME,resp);
        return resp;
    }
}
