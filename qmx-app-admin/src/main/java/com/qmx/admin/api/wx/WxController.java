package com.qmx.admin.api.wx;

import com.qmx.admin.controller.common.BaseApiController;
import com.qmx.admin.controller.common.BaseOpenController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxOpenApiRemoteService;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.base.core.constants.Constants;
import com.qmx.wxbasics.api.dto.WxParames;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Map;

@RestController
@RequestMapping("/api/wxopen")
public class WxController extends BaseApiController {
    @Autowired
    private WxOpenApiRemoteService wxOpenApiRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    /**
     * 验证Api是否合法，返回false时必须设置返回内容
     *
     * @param request
     * @param response
     * @return
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
        /*String req = (String)request.getAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME);
        if("0".equals(request.getParameter("flag"))){
            String resp = "验证失败是返回内容";
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME,resp);
            //response.getWriter().write(resp);这个方法不用实现，拦截器里已实现
            return false;
        }*/
        return true;
    }

    /**
     * 获取appkey
     *
     * @param httpServletRequest
     * @return
     */
    @Override
    public String getAppKey(HttpServletRequest httpServletRequest) {
        return "appkey：记录日志用";
    }

    /**
     * 获取apiName
     *
     * @param httpServletRequest
     * @return
     */
    @Override
    public String getApiName(HttpServletRequest httpServletRequest) {
        return "getApiName：记录日志用";
    }

    /**
     * 获取请求内容
     *
     * @param request
     * @return
     */
    @Override
    public String getRequestStr(HttpServletRequest request) {
        String req = "getRequestStr请求内容：记录日志用";

        //存放请求内容，如果本类其他方法要使用请求内容(如果以流的方式接收的再次获取会报错拿不到数据)，可以用这个属性获取
        request.setAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME, req);
        //返回这个内容用于存储日志
        return req;
    }

    /**
     * 微信获取openid
     */
    @RequestMapping(value = "/getOpenid", method = RequestMethod.GET)
    public void openid(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String appid = RequestUtils.getString(request, "appid", null);
        String code = RequestUtils.getString(request, "code", null);
        String state = RequestUtils.getString(request, "state", null);
        if (code != null) {
            System.err.println(">>>>>>appid==" + appid + "<<<code==" + code + ">>>state==" + state);
            response.sendRedirect(wxAuthorizationRemoteService.getOpenid(appid, code, state).getData());
        }
    }

    @RequestMapping(value = "/openweixin", method = {RequestMethod.GET, RequestMethod.POST})
    public String openweixin(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            Map<String, String> parameMap = RequestUtils.getRequestMap(request);
            Object obj[] = parameMap.keySet().toArray();
            for (int i = 0; i < parameMap.size(); i++) {
                System.out.println("参数:" + obj[i] + "=" + parameMap.get(obj[i]));
            }
            WxParames parames = new WxParames();
            parames.setEncrypt_type(parameMap.get("encrypt_type"));
            parames.setMsg_signature(parameMap.get("msg_signature"));
            parames.setNonce(parameMap.get("nonce"));
            parames.setSignature(parameMap.get("signature"));
            parames.setTimestamp(parameMap.get("timestamp"));
            StringBuffer sb = new StringBuffer();
            InputStream is = request.getInputStream();
            InputStreamReader isr = new InputStreamReader(is, "UTF-8");
            BufferedReader br = new BufferedReader(isr);
            String s = "";
            while ((s = br.readLine()) != null) {
                sb.append(s);
            }
            String xml = sb.toString();
            System.out.println("xml》》》》" + xml);
            String echostr = request.getParameter("echostr");
            if ((echostr != null) && (echostr.length() > 1)) {
                return echostr;
            }
            return wxOpenApiRemoteService.openweixin(parames, xml);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @RequestMapping(value = "/{appid}/openweixin", method = {RequestMethod.GET, RequestMethod.POST})
    public String openweixin(@PathVariable String appid, HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            Map<String, String> parameMap = RequestUtils.getRequestMap(request);
            Object obj[] = parameMap.keySet().toArray();
            for (int i = 0; i < parameMap.size(); i++) {
                System.out.println("参数:" + obj[i] + "=" + parameMap.get(obj[i]));
            }
            WxParames parames = new WxParames();
            parames.setEncrypt_type(parameMap.get("encrypt_type"));
            parames.setMsg_signature(parameMap.get("msg_signature"));
            parames.setNonce(parameMap.get("nonce"));
            parames.setSignature(parameMap.get("signature"));
            parames.setTimestamp(parameMap.get("timestamp"));
            StringBuffer sb = new StringBuffer();
            InputStream is = request.getInputStream();
            InputStreamReader isr = new InputStreamReader(is, "UTF-8");
            BufferedReader br = new BufferedReader(isr);
            String s = "";
            while ((s = br.readLine()) != null) {
                sb.append(s);
            }
            String xml = sb.toString();
            System.out.println("xml》》》》" + xml);
            String echostr = request.getParameter("echostr");
            if ((echostr != null) && (echostr.length() > 1)) {
                return echostr;
            }
            if ("wx570bc396a51b8ff8".equals(appid)) {
                return wxOpenApiRemoteService.weixinCase(parames, xml);
            } else {
                return wxOpenApiRemoteService.weixin(appid, parames, xml);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
