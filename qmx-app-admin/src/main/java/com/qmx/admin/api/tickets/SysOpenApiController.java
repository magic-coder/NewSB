package com.qmx.admin.api.tickets;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseOpenController;
import com.qmx.admin.remoteapi.core.SysUserApiRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.tickets.SysOpenApiRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.constants.Constants;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.coreservice.api.user.dto.SysUserApiDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.tickets.api.dto.SysDistributionPriceDTO;
import com.qmx.tickets.api.dto.SysOrderDTO;
import com.qmx.tickets.api.dto.SysRefundDTO;
import com.qmx.tickets.api.dto.SysSightDTO;
import com.qmx.tickets.api.externalapi.openapi.request.*;
import com.qmx.tickets.api.externalapi.openapi.response.GetProductListResponse;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/open/openapi")
public class SysOpenApiController extends BaseOpenController {
    private static final String APPKEY = "appkey";

    @Autowired
    private SysOpenApiRemoteService sysOpenApiRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysUserApiRemoteService sysUserApiRemoteService;

    public void validation(HttpServletRequest request, String secretKey) {
        String appkey = request.getParameter(APPKEY);
        String sign = request.getParameter("sign");
        String timestamp = request.getParameter("timestamp");
        String body = request.getParameter("body");
        Assert.notNull(appkey, "appkey不能为空");
        Assert.notNull(sign, "sign不能为空");
        Assert.notNull(timestamp, "timestamp不能为空");
        Assert.notNull(body, "body不能为空");
        try {
            JSONObject.parseObject(body);
        } catch (Exception e) {
            throw new BusinessException("body不是json格式");
        }
        try {
            Long.parseLong(timestamp);
        } catch (Exception e) {
            throw new BusinessException("timestamp格式错误,不是Long类型");
        }
        Long s = System.currentTimeMillis() - Long.parseLong(timestamp);
        if (s > 10 * 60 * 1000) {
            throw new BusinessException("时间验证失败");
        }
        String str = appkey + body + secretKey + timestamp;
        String newSign = DigestUtils.md5Hex(str);
        if (!newSign.equalsIgnoreCase(sign)) {
            throw new BusinessException("签名验证失败");
        }
    }

    /**
     * 查询产品列表
     */
    @RequestMapping(value = "/getProductList", method = RequestMethod.POST)
    public Object getProductList(HttpServletRequest request,
                                 HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            GetProductListRequest dto = new GetProductListRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);

            String method = json.getString("method");
            if (GetProductListRequest.MethodEnum.LIST.name().equalsIgnoreCase(method)) {
                dto.setMethod(GetProductListRequest.MethodEnum.LIST);
                try {
                    JSONArray snList = json.getJSONArray("snList");
                    dto.setSnList(snList.toJavaList(String.class));
                } catch (Exception e) {
                    throw new BusinessException("snList参数错误,不是List<String>类型");
                }
            } else {
                dto.setMethod(GetProductListRequest.MethodEnum.PAGE);
                try {
                    Integer pageIndex = json.getInteger("pageIndex");
                    Integer pageSize = json.getInteger("pageSize");
                    dto.setPageIndex(pageIndex);
                    dto.setPageSize(pageSize);
                } catch (Exception e) {
                    throw new BusinessException("分页查询pageIndex,pageSize参数错误,不是int类型");
                }
            }

            RestResponse<GetProductListResponse> restResponse = sysOpenApiRemoteService.findProductList(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            GetProductListResponse data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "查询产品列表失败,失败原因" + e.getMessage());
            } else {
                object.put("msg", "查询产品列表失败,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    /**
     * 查询产品价格信息
     */
    @RequestMapping(value = "/getProductPriceList", method = RequestMethod.POST)
    public Object getProductPriceList(HttpServletRequest request,
                                      HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);

            GetProductPriceListRequest dto = new GetProductPriceListRequest();
            dto.setUserId(sysUserDto.getId());

            String productId = json.getString("productId");
            dto.setProductId(productId);
            String startTime = json.getString("startTime");
            dto.setStartTime(startTime);
            String endTime = json.getString("endTime");
            dto.setEndTime(endTime);

            RestResponse<List<SysDistributionPriceDTO>> restResponse = sysOpenApiRemoteService.findProductPriceList(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            List<SysDistributionPriceDTO> data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "查询产品价格信息,失败原因" + e.getMessage());
            } else {
                object.put("msg", "查询产品价格信息,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    /**
     * 查询当前分销商的景区列表
     */
    @RequestMapping(value = "/getSightList", method = RequestMethod.POST)
    public Object getSightList(HttpServletRequest request,
                               HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            GetSightListRequest dto = new GetSightListRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);

            String method = json.getString("method");
            if (GetSightListRequest.MethodEnum.LIST.name().equalsIgnoreCase(method)) {
                dto.setMethod(GetSightListRequest.MethodEnum.LIST);
                try {
                    JSONArray sightIdList = json.getJSONArray("sightIdList");
                    dto.setSightIdList(sightIdList.toJavaList(String.class));
                } catch (Exception e) {
                    throw new BusinessException("sightIdList参数错误,不是List<Long>类型");
                }
            } else {
                dto.setMethod(GetSightListRequest.MethodEnum.PAGE);
                try {
                    Integer pageIndex = json.getInteger("pageIndex");
                    Integer pageSize = json.getInteger("pageSize");
                    dto.setPageIndex(pageIndex);
                    dto.setPageSize(pageSize);
                } catch (Exception e) {
                    throw new BusinessException("分页查询pageIndex,pageSize参数错误,不是int类型");
                }
            }

            RestResponse<List<SysSightDTO>> restResponse = sysOpenApiRemoteService.findSightList(dto);

            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            List<SysSightDTO> data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "查询当前分销商的景区列表,失败原因" + e.getMessage());
            } else {
                object.put("msg", "查询当前分销商的景区列表,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    /**
     * 验证订单
     */
    @RequestMapping(value = "/verify", method = RequestMethod.POST)
    public Object verify(HttpServletRequest request,
                         HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            CreateOrderRequest dto = new CreateOrderRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);

            String outSn = json.getString("outSn");
            dto.setOutSn(outSn);
            String contactName = json.getString("contactName");
            dto.setContactName(contactName);
            String contactMobile = json.getString("contactMobile");
            dto.setContactMobile(contactMobile);
            String productSn = json.getString("productSn");
            dto.setProductSn(productSn);
            try {
                Integer quantity = json.getInteger("quantity");
                dto.setQuantity(quantity);
            } catch (Exception e) {
                throw new BusinessException("quantity参数错误,不是int类型");
            }

            RestResponse<Boolean> restResponse = sysOpenApiRemoteService.verifyOrder(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            Boolean data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "验证订单,失败原因" + e.getMessage());
            } else {
                object.put("msg", "验证订单,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    /**
     * 创建订单
     */
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public Object create(HttpServletRequest request,
                         HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            CreateOrderRequest dto = new CreateOrderRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);

            String outSn = json.getString("outSn");
            dto.setOutSn(outSn);
            String contactName = json.getString("contactName");
            dto.setContactName(contactName);
            String contactMobile = json.getString("contactMobile");
            dto.setContactMobile(contactMobile);
            String productSn = json.getString("productSn");
            dto.setProductSn(productSn);
            String useDate = json.getString("useDate");
            dto.setUseDate(useDate);
            try {
                BigDecimal salePrice = json.getBigDecimal("salePrice");
                dto.setSalePrice(salePrice);
            } catch (Exception e) {
                throw new BusinessException("salePrice(售卖价格)参数类型错误");
            }
            if (StringUtils.isNotEmpty(json.getString("passengerList"))) {
                try {
                    JSONArray passengerList = json.getJSONArray("passengerList");
                    dto.setPassengerList(passengerList.toJavaList(PassengerInfoDTO.class));
                } catch (Exception e) {
                    throw new BusinessException("passengerList参数错误,不是List<PassengerInfoDTO>类型");
                }
            }

            try {
                Integer quantity = json.getInteger("quantity");
                dto.setQuantity(quantity);
            } catch (Exception e) {
                throw new BusinessException("quantity参数错误,不是int类型");
            }

            RestResponse<String> restResponse = sysOpenApiRemoteService.createOrder(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            String data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "创建订单,失败原因" + e.getMessage());
            } else {
                object.put("msg", "创建订单,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    /**
     * 支付订单
     */
    @RequestMapping(value = "/payment", method = RequestMethod.POST)
    public Object payment(HttpServletRequest request,
                          HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            PayOrderRequest dto = new PayOrderRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);
            try {
                Long orderId = json.getLong("orderId");
                dto.setOrderId(orderId);
            } catch (Exception e) {
                throw new BusinessException("参数错误,orderId不是Long类型");
            }

            RestResponse restResponse = sysOpenApiRemoteService.payOrder(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            Object data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "支付订单,失败原因" + e.getMessage());
            } else {
                object.put("msg", "支付订单,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    /**
     * 查询订单信息
     */
    @RequestMapping(value = "/getOrderInfo", method = RequestMethod.POST)
    public Object getOrderInfo(HttpServletRequest request,
                               HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            QueryOrderRequest dto = new QueryOrderRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);
            try {
                Long orderId = json.getLong("orderId");
                dto.setOrderId(orderId);
            } catch (Exception e) {
                throw new BusinessException("参数错误,orderId不是Long类型");
            }
            try {
                Boolean queryEticket = json.getBoolean("queryEticket");
                dto.setQueryEticket(queryEticket);
            } catch (Exception e) {
                throw new BusinessException("参数错误,queryEticket不是Boolean类型");
            }
            RestResponse<SysOrderDTO> restResponse = sysOpenApiRemoteService.findOrderInfo(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            Object data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "查询订单信息,失败原因" + e.getMessage());
            } else {
                object.put("msg", "查询订单信息,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }

    }

    /**
     * 订单申请退款
     */
    @RequestMapping(value = "/refund", method = RequestMethod.POST)
    public Object refund(HttpServletRequest request,
                         HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            RefundOrderRequest dto = new RefundOrderRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);
            try {
                Long orderId = json.getLong("orderId");
                dto.setOrderId(orderId);
            } catch (Exception e) {
                throw new BusinessException("参数错误,orderId不是Long类型");
            }
            String refundId = json.getString("refundId");
            dto.setRefundId(refundId);
            try {
                Integer refundQuantity = json.getInteger("refundQuantity");
                dto.setRefundQuantity(refundQuantity);
            } catch (Exception e) {
                throw new BusinessException("参数错误,refundQuantity不是int类型");
            }
            try {
                JSONArray refundList = json.getJSONArray("refundList");
                dto.setRefundList(refundList.toJavaList(String.class));
            } catch (Exception e) {
                throw new BusinessException("refundList参数错误,不是List<String>类型");
            }

            RestResponse<SysRefundDTO> restResponse = sysOpenApiRemoteService.refundOrder(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            Object data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "订单申请退款,失败原因" + e.getMessage());
            } else {
                object.put("msg", "订单申请退款,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    /**
     * 用户通知订单已退款
     */
    @RequestMapping(value = "/notifyRefund", method = RequestMethod.POST)
    public Object notifyRefund(HttpServletRequest request,
                               HttpServletResponse response) {
        try {
            /**
             * 签名，时间验证
             */
            SysUserDto sysUserDto = (SysUserDto) request.getAttribute(USER_INFO);
            SysUserApiDTO sysUserApiDTO = (SysUserApiDTO) request.getAttribute(USER_API_INFO);
            validation(request, sysUserApiDTO.getSecretKey());

            RefundOrderRequest dto = new RefundOrderRequest();
            dto.setUserId(sysUserDto.getId());

            String body = request.getParameter("body");
            JSONObject json = JSONObject.parseObject(body);
            try {
                Long orderId = json.getLong("orderId");
                dto.setOrderId(orderId);
            } catch (Exception e) {
                throw new BusinessException("参数错误,orderId不是Long类型");
            }
            String refundId = json.getString("refundId");
            dto.setRefundId(refundId);
            try {
                Integer refundQuantity = json.getInteger("refundQuantity");
                dto.setRefundQuantity(refundQuantity);
            } catch (Exception e) {
                throw new BusinessException("参数错误,refundQuantity不是int类型");
            }
            try {
                JSONArray refundList = json.getJSONArray("refundList");
                dto.setRefundList(refundList.toJavaList(String.class));
            } catch (Exception e) {
                throw new BusinessException("refundList参数错误,不是List<String>类型");
            }
            RestResponse<Boolean> restResponse = sysOpenApiRemoteService.notifyOrderRefundByUser(dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            Object data = restResponse.getData();
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("data", data);
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject object = new JSONObject();
            object.put("code", "500");
            if (e instanceof BusinessException || e instanceof ValidationException) {
                object.put("msg", "用户通知订单已退款,失败原因" + e.getMessage());
            } else {
                object.put("msg", "用户通知订单已退款,未知异常");
            }
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return object;
        }
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
        String appkey = request.getParameter(APPKEY);
        SysUserApiDTO userApiDTO = sysUserApiRemoteService.findByAppkey(appkey).getData();
        if (userApiDTO == null) {
            JSONObject object = new JSONObject();
            object.put("code", "500");
            object.put("msg", "不存在的appkey");
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return false;
        }
        SysUserDto sysUserDto = sysUserRemoteService.findById(userApiDTO.getUserId()).getData();
        if (sysUserDto == null) {
            JSONObject object = new JSONObject();
            object.put("code", "500");
            object.put("msg", "appkey未绑定用户");
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return false;
        }
        request.setAttribute(USER_INFO, sysUserDto);
        request.setAttribute(USER_API_INFO, userApiDTO);
        return true;
    }

    @Override
    public String getAppKey(HttpServletRequest request) {
        String appkey = request.getParameter(APPKEY);
        if (appkey != null) {
            return appkey;
        }
        return null;
    }

    @Override
    public String getApiName(HttpServletRequest request) {
        return request.getRequestURI();
    }

    @Override
    public String getRequestStr(HttpServletRequest request) {
        String body = request.getParameter(API_BODY);
        //存放请求内容，如果本类其他方法要使用请求内容(如果以流的方式接收的再次获取会报错拿不到数据)，可以用这个属性获取
        request.setAttribute(Constants.API_LOG_REQ_CONTENT_ATTRIBUTE_NAME, body);
        //返回这个内容用于存储日志
        return body;
    }
}
