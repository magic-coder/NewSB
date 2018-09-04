package com.qmx.admin.interceptor;
import com.qmx.base.core.utils.CookieUtil;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.NamedThreadLocal;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Author liubin
 * @Description 列表查询
 * @Date Created on 2018/4/28 14:36.
 * @Modified By
 */
public class ListInterceptor extends HandlerInterceptorAdapter {
	protected static Logger logger = LoggerFactory.getLogger(ListInterceptor.class);
	/** 重定向视图名称前缀 */
	private static final String REDIRECT_VIEW_NAME_PREFIX = "redirect:list";

	/** 列表查询Cookie名称 */
	private static final String LIST_QUERY_COOKIE_NAME = "listQuery";
	
	private final ThreadLocal<Long> startTimeThreadLocal = new NamedThreadLocal<Long>("ThreadLocal StartTime");
	@Override
	public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// 最大内存: {}M; 已分配内存: {}M; 已分配内存中的剩余空间: {}M; 最大可用内存:
		// {}M.
		// long total = Runtime.getRuntime().totalMemory() /
		// 1024 / 1024;
		// long max = Runtime.getRuntime().maxMemory() /
		// 1024 / 1024;
		// long free = Runtime.getRuntime().freeMemory() /
		// 1024 / 1024;
		// , max, total, free, max - total + free
		super.afterCompletion(request, response, handler, ex);
	}


	@Override
	public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response, Object handler) throws Exception {
		startTimeThreadLocal.set(System.currentTimeMillis());
		return super.preHandle(request, response, handler);
	}


	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		if (modelAndView != null && modelAndView.isReference()) {
			String viewName = modelAndView.getViewName();
			if (StringUtils.startsWith(viewName, REDIRECT_VIEW_NAME_PREFIX)) {
				String listQuery = CookieUtil.getCookie(request, LIST_QUERY_COOKIE_NAME);
				if (StringUtils.isNotEmpty(listQuery)) {
					if (StringUtils.startsWith(listQuery, "?")) {
						listQuery = listQuery.substring(1);
					}
					if (StringUtils.contains(viewName, "?")) {
						modelAndView.setViewName(viewName + "&" + listQuery);
					} else {
						modelAndView.setViewName(viewName + "?" + listQuery);
					}
					String ck = CookieUtil.getCookie(request,LIST_QUERY_COOKIE_NAME);
					CookieUtil.removeCookie(request, response, LIST_QUERY_COOKIE_NAME);
					String ck2 = CookieUtil.getCookie(request,LIST_QUERY_COOKIE_NAME);
				}
			}
		}
	}
	
}