package com.qmx.admin.controller.common;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Author liubin
 * @Description 接口基类
 * @Date Created on 2017/12/26 9:49.
 * @Modified By
 */
public abstract class BaseApiController {
	
	public abstract boolean preHandle(HttpServletRequest request, HttpServletResponse response);
	
	public abstract String getAppKey(HttpServletRequest request);
	
	public abstract String getApiName(HttpServletRequest request);

	public abstract String getRequestStr(HttpServletRequest request);
	
}
