package com.qmx.admin.api.tickets;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseOpenController;
import com.qmx.admin.remoteapi.core.SysUserApiRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsOrderServiceRemoteService;
import com.qmx.admin.remoteapi.travelagency.OpenApiRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.constants.Constants;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.user.dto.SysUserApiDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.APPTypeEnum;
import com.qmx.tickets.api.dto.ConsumeEticketDTO;
import com.qmx.tickets.api.enumerate.ConsumeTypeEnum;
import org.apache.commons.codec.digest.DigestUtils;
import org.bouncycastle.math.ec.ScaleYPointMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @Author liubin
 * @Description 测试demo
 * 调用顺序：1.getAppKey
 * 调用顺序：2.getRequestStr
 * 调用顺序：3.preHandle
 * @Date Created on 2017/12/26 10:42.
 * @Modified By
 */
@Controller
@RequestMapping("/open/tickets/offline/v1")
public class TicketsOfflineOpenApi extends BaseOpenController {

    @Autowired
    private SysUserApiRemoteService sysUserApiRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TicketsOrderServiceRemoteService orderServiceRemoteService;

    /**
     * 验证Api是否合法，返回false时必须设置返回内容
     * @param request
     * @param response
     * @return
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
        String appkey = request.getParameter(API_APPKEY);
        String timestamp = request.getParameter(API_TIMESTAMP);
        String sign = request.getParameter(API_SIGN);
        String body = request.getParameter(API_BODY);
        try{
            if(!StringUtils.hasText(appkey)){
                throw new ValidationException("appkey不能为空");
            }
            if(!StringUtils.hasText(timestamp)){
                throw new ValidationException("timestamp不能为空");
            }
            Long ts = Long.parseLong(timestamp);
            if(Math.abs(System.currentTimeMillis() - ts) > 1000 * 60 * 20){
                throw new ValidationException("请求已过期，请重新请求");
            }
            if(!StringUtils.hasText(sign)){
                throw new ValidationException("sign不能为空");
            }
            if(!StringUtils.hasText(body)){
                throw new ValidationException("body内容不能为空");
            }
            SysUserApiDTO userApiDTO = sysUserApiRemoteService.findByAppkey(appkey).getData();
            if(userApiDTO == null){
                throw new ValidationException("未找到appkey");
            }
            String str = appkey + body + userApiDTO.getSecretKey() + timestamp;
            String newSign = DigestUtils.md5Hex(str);
            if (!newSign.equalsIgnoreCase(sign)) {
                throw new ValidationException("签名认证失败");
            }
            if(userApiDTO.getAppType() == APPTypeEnum.USER){
                SysUserDto sysUserDto = sysUserRemoteService.findById(userApiDTO.getUserId()).getData();
                if (sysUserDto == null) {
                    throw new ValidationException("未找到关联用户");
                }
                request.setAttribute(USER_INFO,sysUserDto);
            }
            request.setAttribute(USER_API_INFO,userApiDTO);
        }catch (Exception e){
            //response.getWriter().write(resp);这个方法不用实现，拦截器里已实现
            RestResponse restResponse = RestResponse.fail(500,e.getMessage());
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME,JSONObject.toJSONString(restResponse));
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
    @RequestMapping("/orderList")
    public Object orderList(HttpServletRequest request){
        RestResponse restResponse = null;
        try{
            String body = (String) request.getAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME);
            JSONObject jsonObject = JSONObject.parseObject(body);
            SysUserApiDTO userApiDTO = (SysUserApiDTO)request.getAttribute(USER_API_INFO);
            //SysUserDto sysUserDto = (SysUserDto)request.getAttribute(USER_INFO);
            Long userId = userApiDTO.getUserId();
            Boolean flag = userApiDTO.getAppType() == APPTypeEnum.USER;
            JSONObject data = jsonObject.getJSONObject("data");
            Assert.notNull(data,"data为空");
            String start = data.getString("startTime");
            String end = data.getString("endTime");
            Date startTime = DateUtil.parseDateTime(start+" 00:00:00");
            Date endTime = DateUtil.parseDateTime(end+" 23:59:59");
            Integer maxRow = data.getInteger("maxRow");
            restResponse = orderServiceRemoteService.findOffLineOrderList(userId,startTime,endTime,flag,maxRow);
        }catch (Exception e){
            restResponse = RestResponse.fail(e.getMessage());
        }finally {
            //设置返回日志
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME,JSONObject.toJSONString(restResponse));
        }
        return restResponse;
    }

    /**
     * 更新线下同步状态
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping("/updateOfflineSyncStatus")
    public Object updateOfflineSyncStatus(HttpServletRequest request){
        RestResponse restResponse = null;
        try{
            String body = (String) request.getAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME);
            JSONObject jsonObject = JSONObject.parseObject(body);
            JSONArray data = jsonObject.getJSONArray("data");
            Assert.notNull(data,"data为空");
            List<Long> ids = new ArrayList<>();
            for (Object id: data) {
                ids.add(Long.parseLong(id+""));
            }
            restResponse = orderServiceRemoteService.updateOfflineSyncStatus(ids);
        }catch (Exception e){
            restResponse = RestResponse.fail(e.getMessage());
        }finally {
            //设置返回日志
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME,JSONObject.toJSONString(restResponse));
        }
        return restResponse;
    }

    @ResponseBody
    @RequestMapping("/consumeEticket")
    public Object consumeEticket(HttpServletRequest request){
        RestResponse restResponse = null;
        try{
            String body = (String) request.getAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME);
            JSONObject jsonObject = JSONObject.parseObject(body);
            //SysUserDto sysUserDto = (SysUserDto)request.getAttribute(USER_INFO);
            //Long supplierId = sysUserDto.getId();
            SysUserApiDTO userApiDTO = (SysUserApiDTO)request.getAttribute(USER_API_INFO);
            Boolean flag = userApiDTO.getAppType() == APPTypeEnum.USER;
            JSONArray data = jsonObject.getJSONArray("data");
            String consumeType = jsonObject.getString("consumeType");
            Assert.notNull(data,"data为空");
            Assert.notNull(consumeType,"consumeType为空");
            ConsumeTypeEnum consumeTypeEnum = ConsumeTypeEnum.valueOf(consumeType);
            Assert.isTrue(consumeTypeEnum == ConsumeTypeEnum.OFFLINE,"消费类型错误:"+consumeTypeEnum);
            List<ConsumeEticketDTO> list = new ArrayList<>();
            for (Object id: data) {
                ConsumeEticketDTO dto = new ConsumeEticketDTO();
                dto.setSn(id+"");
                dto.setConsumeType(consumeTypeEnum);
                dto.setConsumeDate(new Date());
                list.add(dto);
            }
            restResponse = orderServiceRemoteService.consumeEticket(userApiDTO.getUserId(),flag,list);
        }catch (Exception e){
            restResponse = RestResponse.fail(e.getMessage());
        }finally {
            //设置返回日志
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME,JSONObject.toJSONString(restResponse));
        }
        return restResponse;
    }
}
