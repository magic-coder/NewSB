package com.qmx.admin.api.pay;
import com.qmx.admin.controller.common.BaseApiController;
import com.qmx.admin.remoteapi.core.WxPayNotifyRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.constants.Constants;
import org.apache.commons.io.IOUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Author liubin
 * @Description 接收处理微信通知
 * @Date Created on 2017/10/27 11:18.
 * @Modified By
 */
@Controller
@RequestMapping("/api/pay/wxPay")
public class NotifyWxPayController extends BaseApiController {

	private static final Logger _log = LoggerFactory.getLogger(NotifyWxPayController.class);

	@Autowired
	private WxPayNotifyRemoteService wxPayNotifyRemoteService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
		return true;
	}

	@Override
	public String getAppKey(HttpServletRequest request) {
		try{
			String xmlResult = IOUtils.toString(request.getInputStream(), request.getCharacterEncoding());
			if(StringUtils.hasText(xmlResult)){
				//存放请求内容，如果本类其他方法要使用请求内容(如果以流的方式接收的再次获取会报错拿不到数据)，可以用这个属性获取
				request.setAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME,xmlResult);
				Document document = DocumentHelper.parseText(xmlResult);
				Element element = document.getRootElement();
				if(element != null){
					return element.elementText("mch_id");
				}
			}
		}catch (Exception e){
			_log.error(e.getMessage());
		}
		return null;
	}

	@Override
	public String getApiName(HttpServletRequest request) {
		return request.getRequestURI();
	}

	@Override
	public String getRequestStr(HttpServletRequest request) {
		String xmlResult = (String)request.getAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME);
		return xmlResult;
	}

	/**
	 * 微信支付(统一下单接口)后台通知响应
	 * @param request
	 * @return
	 * @throws ServletException
	 * @throws IOException
     */
	@ResponseBody
	@RequestMapping("/wxPayNotify")
	public String wxPayNotifyRes(HttpServletRequest request) throws ServletException, IOException {
		_log.info("====== 开始接收微信支付回调通知 ======");
		String notifyRes = doWxPayRes(request);
		_log.info("响应给微信:{}", notifyRes);
		_log.info("====== 完成接收微信支付回调通知 ======");
		return notifyRes;
	}

	public String doWxPayRes(HttpServletRequest request) throws ServletException, IOException {
		String logPrefix = "【微信支付回调通知】";
		String xmlResult = (String)request.getAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME);
		_log.info("{}通知请求数据:reqStr={}", logPrefix, xmlResult);
		try{
			RestResponse<String> restResponse = wxPayNotifyRemoteService.payNotify(xmlResult);
			if(restResponse.success()){
				return restResponse.getData();
			}
			//return wxPayNotifyRemoteService.payNotify(xmlResult);
			//doWxPayNotify(xmlResult);
		}catch (Exception e){
			_log.error(e.getMessage());
		}
		return "fail";
	}

}
