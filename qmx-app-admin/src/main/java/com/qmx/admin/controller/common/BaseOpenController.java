package com.qmx.admin.controller.common;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Author liubin
 * @Description 接口基类
 * @Date Created on 2017/12/26 9:49.
 * @Modified By
 */
public abstract class BaseOpenController {

	protected String API_APPKEY = "appkey";
	protected String API_SIGN = "sign";
	protected String API_TIMESTAMP = "timestamp";
	protected String API_BODY = "body";
	protected String USER_API_INFO = "userApiInfo";
	protected String USER_INFO = "userInfo";

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response){
		return false;
	}
	
	public abstract String getAppKey(HttpServletRequest request);
	
	public abstract String getApiName(HttpServletRequest request);

	public abstract String getRequestStr(HttpServletRequest request);
	
}
