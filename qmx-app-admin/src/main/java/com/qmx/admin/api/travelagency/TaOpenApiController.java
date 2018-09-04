package com.qmx.admin.api.travelagency;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseOpenController;
import com.qmx.admin.remoteapi.core.SysUserApiRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.OpenApiRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.constants.Constants;
import com.qmx.coreservice.api.user.dto.SysUserApiDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.travelagency.api.dto.OrderDto;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RestController
@RequestMapping("/open/travelagency")
public class TaOpenApiController extends BaseOpenController {
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysUserApiRemoteService sysUserApiRemoteService;
    @Autowired
    private OpenApiRemoteService openApiRemoteService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
        try {
            String appkey = request.getParameter("appkey");
            String sign = request.getParameter("sign");
            String timestamp = request.getParameter("timestamp");
            String body = request.getParameter("body");//{"appkey":"",data:..}
            SysUserApiDTO userApiDTO = sysUserApiRemoteService.findByAppkey(appkey).getData();
            if (userApiDTO == null) {
                JSONObject object = new JSONObject();
                object.put("code", "200");
                object.put("msg", "不存在的appkey");
                request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
                return false;
            }
            SysUserDto sysUserDto = sysUserRemoteService.findById(userApiDTO.getUserId()).getData();
            if (sysUserDto == null) {
                JSONObject object = new JSONObject();
                object.put("code", "200");
                object.put("msg", "appkey未绑定用户");
                request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
                return false;
            }
            Long s = System.currentTimeMillis() - Long.parseLong(timestamp);
            if (s > 10 * 60 * 1000) {
                JSONObject object = new JSONObject();
                object.put("code", "200");
                object.put("msg", "时间验证失败");
                request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
                return false;
            }
            String str = appkey + body + userApiDTO.getSecretKey() + timestamp;
            String newSign = DigestUtils.md5Hex(str);
            if (!newSign.equalsIgnoreCase(sign)) {
                JSONObject object = new JSONObject();
                object.put("code", "200");
                object.put("msg", "签名验证失败");
                request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
                return false;
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("msg", "参数错误");
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return false;
        }
    }

    @Override
    public String getAppKey(HttpServletRequest request) {
        String appkey = request.getParameter("appkey");
        return appkey;
    }

    @Override
    public String getApiName(HttpServletRequest request) {
        String apiName = request.getRequestURI();
        return apiName;
    }

    @Override
    public String getRequestStr(HttpServletRequest request) {
        String req = request.getParameter("body");
        request.setAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME, req);
        return req;
    }

    @RequestMapping(value = "/getOrderList", method = RequestMethod.POST)
    public RestResponse<List<OrderDto>> getOrderList(HttpServletRequest request) {
        String appkey = request.getParameter("appkey");
        SysUserApiDTO userApiDTO = sysUserApiRemoteService.findByAppkey(appkey).getData();
        SysUserDto sysUserDto = sysUserRemoteService.findById(userApiDTO.getUserId()).getData();

        RestResponse<List<OrderDto>> result = openApiRemoteService.getOrderList(sysUserDto.getId());

        //设置返回日志
        request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, result);
        return result;
    }

    @RequestMapping(value = "/updateStatus", method = RequestMethod.POST)
    public RestResponse<Object> updateStatus(HttpServletRequest request) {

        String body = request.getParameter("body");
        JSONObject json = JSONObject.parseObject(body);
        JSONObject data = json.getJSONObject("data");
        String type = data.getString("type");
        JSONArray idsStr = data.getJSONArray("ids");
        Long[] ids = JSONArray.toJavaObject(idsStr, Long[].class);

        Assert.notNull(type, "修改同步状态的类型不能为空!");
        Assert.notNull(ids, "ID不能为空!");

        RestResponse<Object> result = openApiRemoteService.updateStatus(body);

        //设置返回日志
        request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, result);
        return result;
    }

    @RequestMapping(value = "/orderConsume", method = RequestMethod.POST)
    public RestResponse<Object> orderConsume(HttpServletRequest request) {
        String body = request.getParameter("body");
        JSONObject json = JSONObject.parseObject(body);
        JSONObject data = json.getJSONObject("data");
        Long infoid = data.getLong("infoid");
        Integer quantity = data.getInteger("quantity");

        RestResponse<Object> result = openApiRemoteService.orderConsume(infoid, quantity);

        //设置返回日志
        request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, result);
        return result;
    }

}
