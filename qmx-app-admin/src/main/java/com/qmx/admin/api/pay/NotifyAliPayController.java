package com.qmx.admin.api.pay;
import com.qmx.admin.controller.common.BaseApiController;
import com.qmx.admin.remoteapi.core.AliPayNotifyRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.constants.Constants;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.coreservice.api.pay.constant.PayConstant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * @Author liubin
 * @Description 接收处理支付宝通知
 * @Date Created on 2017/10/27 11:00.
 * @Modified By
 */
@Controller
@RequestMapping("/api/pay/alipay")
public class NotifyAliPayController extends BaseApiController {

	private static final Logger _log = LoggerFactory.getLogger(NotifyAliPayController.class);

	@Autowired
	private AliPayNotifyRemoteService aliPayNotifyRemoteService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
		return true;
	}

	@Override
	public String getAppKey(HttpServletRequest request) {
		return request.getParameter("trade_no");
	}

	@Override
	public String getApiName(HttpServletRequest request) {
		return request.getRequestURI();
	}

	@Override
	public String getRequestStr(HttpServletRequest request) {
		String req = JSONUtil.toJson(getRequestParams(request));
		//存放请求内容，如果本类其他方法要使用请求内容(如果以流的方式接收的再次获取会报错拿不到数据)，可以用这个属性获取
		request.setAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME,req);
		//返回这个内容用于存储日志
		return req;
	}

	/**
	 * 支付宝移动支付后台通知响应
	 * @param request
	 * @return
	 * @throws ServletException
	 * @throws IOException
     */
	@ResponseBody
	@RequestMapping(value = "/payNotify")
	public Object aliPayNotifyRes(HttpServletRequest request) throws ServletException, IOException {
		_log.info("====== 开始接收支付宝支付回调通知 ======");
		Object notifyRes = doAliPayRes(request);
		_log.info("响应给支付宝:{}", notifyRes);
		_log.info("====== 完成接收支付宝支付回调通知 ======");
		return notifyRes;
	}

	public Object doAliPayRes(HttpServletRequest request) throws ServletException, IOException {
		String logPrefix = "【支付宝支付回调通知】";
		//获取支付宝POST过来反馈信息
		Map<String,String> params = getRequestParams(request);
		_log.info("{}通知请求数据:reqStr={}", logPrefix, params);
		if(params.isEmpty()) {
			_log.error("{}请求参数为空", logPrefix);
			return PayConstant.RETURN_ALIPAY_VALUE_FAIL;
		}
		try{
			RestResponse<String> restResponse = aliPayNotifyRemoteService.payNotify(JSONUtil.toJson(params));
			if(restResponse.success()){
				return restResponse.getData();
			}
			//return aliPayNotifyRemoteService.payNotify(params);
			//return doAliPayNotify(params);
		}catch (Exception e){
			e.printStackTrace();
		}
		return "fail";
	}


	/**
	 * 获取支付宝请求参数
	 * @param request
	 * @return
	 */
	private Map<String,String> getRequestParams(HttpServletRequest request){
		//获取支付宝POST过来反馈信息
		Map<String,String> params = new HashMap<String,String>();
		Map requestParams = request.getParameterMap();
		for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
			String name = (String) iter.next();
			String[] values = (String[]) requestParams.get(name);
			String valueStr = "";
			for (int i = 0; i < values.length; i++) {
				valueStr = (i == values.length - 1) ? valueStr + values[i]
						: valueStr + values[i] + ",";
			}
			//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
			//valueStr = new String(valueStr.getBytes("ISO-8859-1"), "gbk");
			params.put(name, valueStr);
		}
		return params;
	}

	
}
