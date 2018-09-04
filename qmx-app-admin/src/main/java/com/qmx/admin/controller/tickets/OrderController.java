package com.qmx.admin.controller.tickets;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.QueryPayOrderRemoteService;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysOrderSourceRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.tickets.*;
import com.qmx.admin.utils.PassengerInfoUtil;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import com.qmx.base.core.utils.CookieUtil;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.pay.dto.SysPayOrderDto;
import com.qmx.coreservice.api.pay.enumerate.PayOrderStatusEnum;
import com.qmx.coreservice.api.user.constant.OrderSourceConstant;
import com.qmx.coreservice.api.user.dto.SysOrderSourceDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.PayMethodEnum;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.tickets.api.dto.*;
import com.qmx.tickets.api.enumerate.*;
import com.qmx.tickets.api.query.SysDistributionVO;
import com.qmx.tickets.api.query.SysOrderVO;
import com.qmx.tickets.api.query.SysSightVO;
import com.qmx.tickets.api.query.SysTicketsVO;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.util.*;

/**
 * @Author liubin
 * @Description 订单管理
 * @Date Created on 2017/12/5 15:51.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/order")
public class OrderController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(OrderController.class);

    @Autowired
    private TicketsTypeRemoteService ticketsTypeRemoteService;
    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TicketsRemoteService ticketsRemoteService;
    @Autowired
    private DistributionRemoteService distributionRemoteService;
    @Autowired
    private SysOrderSourceRemoteService orderSourceRemoteService;
    @Autowired
    private TicketsOrderServiceRemoteService orderServiceRemoteService;
    //@Autowired
    //private BookRuleRemoteService bookRuleRemoteService;
    @Autowired
    private SightRemoteService sightRemoteService;
    @Autowired
    private QueryPayOrderRemoteService queryPayOrderRemoteService;


    @RequestMapping("/ticketsList")
    public String ticketsList(
            HttpServletRequest request,String name,ModelMap model,
            String sn,Boolean marketable,Integer pageIndex,Integer pageSize) {
        SysUserDto userDto = getCurrentMember();
        if(userDto.getUserType() == SysUserType.distributor){
            SysDistributionVO distributionVO = new SysDistributionVO();
            distributionVO.setPageIndex(pageIndex);
            distributionVO.setPageSize(pageSize);
            distributionVO.setProductSn(sn);
            distributionVO.setProductName(name);
            distributionVO.setMemberId(userDto.getId());
            distributionVO.setMarketable(marketable);
            RestResponse<PageDto<SysDistributionDTO>> restResponse = distributionRemoteService.findPageWithBasic(getAccessToken(),distributionVO);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            request.setAttribute("page", restResponse.getData());
        }else{
            SysTicketsVO sysTicketsVO = new SysTicketsVO();
            sysTicketsVO.setPageIndex(pageIndex);
            sysTicketsVO.setPageSize(pageSize);
            sysTicketsVO.setSn(sn);
            sysTicketsVO.setName(name);
            sysTicketsVO.setMarketable(marketable);
            RestResponse<PageDto<SysTicketsDTO>> restResponse = distributionRemoteService.findPageForDistribution(getAccessToken(), sysTicketsVO);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            request.setAttribute("page", restResponse.getData());
        }
        model.addAttribute("currentMember",userDto);
        model.addAllAttributes(RequestUtils.getQueryParams(request));
        return "/tickets/order/tickets_list";
    }

    @RequestMapping("/addTicketsOrder")
    public String addOrder(HttpServletRequest request, Long id) {
        Assert.notNull(id, "门票id不能为空");
        SysUserDto sysUserDto = getCurrentMember();
        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysTicketsDTO sysTicketsDTO = restResponse.getData();
        if (sysTicketsDTO == null) {
            throw new BusinessException("未找到门票id：" + id);
        }
        if (!sysTicketsDTO.getMarketable()) {
            throw new BusinessException("该门票已下架");
        }

        SysBookRuleDTO bookRuleDTO = null;
        SysRefundRuleDTO refundRuleDTO = null;
        SysConsumeRuleDTO consumeRuleDTO = null;
        List<PayMethodEnum> list = new ArrayList<>();
        //获取支付方式
        if (sysUserDto.getUserType() == SysUserType.distributor) {
            RestResponse<SysDistributionDTO> distribution = distributionRemoteService.findDistribution(getAccessToken(), sysUserDto.getId(), id);
            if (!distribution.success()) {
                throw new BusinessException(distribution.getErrorMsg());
            }
            list.add(PayMethodEnum.ALIPAY_QR);
            list.add(PayMethodEnum.DEPOSIT);
            list.add(PayMethodEnum.DEPOSIT_CREDIT);
            list.add(PayMethodEnum.WX_NATIVE);
            request.setAttribute("distribution", distribution.getData());
            SysDistributionDTO sysDistributionDTO = distribution.getData();
            if (sysDistributionDTO != null) {
                //request.setAttribute("bookRule",sysDistributionDTO.getBookRule());
                //request.setAttribute("consumeRule",sysDistributionDTO.getConsumeRule());
                //request.setAttribute("refundRule",sysDistributionDTO.getRefundRule());
                bookRuleDTO = sysDistributionDTO.getBookRule();
                refundRuleDTO = sysDistributionDTO.getRefundRule();
                consumeRuleDTO = sysDistributionDTO.getConsumeRule();
                RestResponse<SysOrderSourceDTO> restOrderSource = orderSourceRemoteService.findSysByCodeAndModuleId(OrderSourceConstant.FENXIAO,getCurrentModuleId(request));
                if (!restOrderSource.success()) {
                    throw new BusinessException(restOrderSource.getErrorMsg());
                }
                SysOrderSourceDTO orderSourceDTO = restOrderSource.getData();
                Assert.notNull(orderSourceDTO,"未找到订单来源");
                List<SysOrderSourceDTO> orderSourceDTOList = new ArrayList<>();
                orderSourceDTOList.add(orderSourceDTO);
                request.setAttribute("orderSources", orderSourceDTOList);
            }
        } else {
            RestResponse<List<SysOrderSourceDTO>> restOrderSource = orderSourceRemoteService.findEffectiveList(getAccessToken(),getCurrentModuleId(request));
            if (!restOrderSource.success()) {
                throw new BusinessException(restOrderSource.getErrorMsg());
            }
            list.add(PayMethodEnum.OFFLINE_PAY);
            //request.setAttribute("bookRule",sysTicketsDTO.getDefaultBookRule());
            //request.setAttribute("consumeRule",sysTicketsDTO.getDefaultConsumeRule());
            //request.setAttribute("refundRule",sysTicketsDTO.getDefaultRefundRule());
            bookRuleDTO = sysTicketsDTO.getDefaultBookRule();
            refundRuleDTO = sysTicketsDTO.getDefaultRefundRule();
            consumeRuleDTO = sysTicketsDTO.getDefaultConsumeRule();
            request.setAttribute("orderSources", restOrderSource.getData());
        }

        if (bookRuleDTO == null || refundRuleDTO == null || consumeRuleDTO == null) {
            throw new BusinessException("产品规则信息为空。");
        }

        request.setAttribute("bookRule", bookRuleDTO);
        request.setAttribute("consumeRule", consumeRuleDTO);
        request.setAttribute("refundRule", refundRuleDTO);
        request.setAttribute("dto", restResponse.getData());
        request.setAttribute("paymentMethods", list);
        return "/tickets/order/add_order";
    }

    //@ResponseBody
    @RequestMapping(value = "/saveTicketsOrder", method = RequestMethod.POST)
    public String saveTicketsOrder(HttpServletRequest request,
                                   SysOrderDTO order, Long productId,Boolean sendSms) {
        SysUserDto currentMember = getCurrentMember();
        Assert.notNull(productId, "产品id不能为空");
        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(productId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysTicketsDTO sysTicketsDTO = restResponse.getData();
        if (sysTicketsDTO == null) {
            throw new BusinessException("未找到门票信息：" + productId);
        }
        order.setProductId(productId);

        SysBookRuleDTO sysBookRuleDTO = sysTicketsDTO.getDefaultBookRule();
        if (sysBookRuleDTO.getPassengerInfoType() != PassengerInfoTypeEnum.NONE) {
            int quantity = 1;
            if (sysBookRuleDTO.getPassengerInfoType() == PassengerInfoTypeEnum.ALL) {
                quantity = order.getQuantity();
            }
            List<SysPassengerInfoDTO> passengerInfoList = PassengerInfoUtil.getPassengerInfos(request, quantity);
            order.setPassengerInfos(passengerInfoList);
        }
        order.setSaleChannel(SaleChannelEnum.INTERNAL_ORDER);
        if (currentMember.getUserType() == SysUserType.distributor ||
                currentMember.getUserType() == SysUserType.distributor2) {
            Assert.notNull(order.getOrderSourceId(),"订单来源不能为空");
            //order.setOrderSourceId(960813213983784961L);//分销商
            order.setSaleChannel(SaleChannelEnum.BACK_ORDER);
        }
        order.setBookRuleId(sysTicketsDTO.getDefaultBookRuleId());
        order.setConsumeRuleId(sysTicketsDTO.getDefaultConsumeRuleId());
        order.setRefundRuleId(sysTicketsDTO.getDefaultRefundRuleId());
        //order.setVsdate("2018-02-06");
        // order.setVedate("2018-02-06");
        //order.setWeekDays("1,2,3,4,5,6,0");
        //.setSalePrice(new BigDecimal("10.20"));
        long s = System.currentTimeMillis();
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.createOrder(getAccessToken(), order);
        if (!orderResponse.success()) {
            throw new BusinessException(orderResponse.getErrorMsg());
        }
        logger.info("下单用时:{}ms",System.currentTimeMillis()-s);
        SysOrderDTO orderDTO = orderResponse.getData();
        PayMethodEnum payMethod = orderDTO.getPaymentMethod();
        if (payMethod != null) {
            //支付方式不为空就执行支付订单
            if (currentMember.getUserType() == SysUserType.distributor ||
                    currentMember.getUserType() == SysUserType.distributor2) {
                //判断支付类型
                if (payMethod == PayMethodEnum.ALIPAY_QR || payMethod == PayMethodEnum.WX_NATIVE) {
                    //跳转到在线支付
                    return "redirect:onlinePayPage?orderId=" + orderDTO.getId();
                } else if (payMethod == PayMethodEnum.DEPOSIT || payMethod == PayMethodEnum.DEPOSIT_CREDIT) {
                    //不处理
                } else {
                    throw new ValidationException("支付方式有误:" + payMethod);
                }
            } else {
                payMethod = PayMethodEnum.OFFLINE_PAY;
            }
            RestResponse<SysOrderDTO> orderPayResponse = orderServiceRemoteService.paid(getAccessToken(), orderDTO.getId(), payMethod, "支付订单");
            if (!orderPayResponse.success()) {
                throw new BusinessException(orderPayResponse.getErrorMsg());
            }
            //调用发货
            if(sendSms != null && sendSms){
                try{
                    RestResponse<Boolean> shippingResponse = orderServiceRemoteService.orderShipping(getAccessToken(),orderDTO.getId());
                    if (!shippingResponse.success()) {
                        throw new BusinessException(shippingResponse.getErrorMsg());
                    }
                }catch (Exception e){
                    logger.error(e.getMessage());
                }
            }
        }
        return "redirect:orderList";
    }

    /**
     * 在线支付页面
     *
     * @param request
     * @param orderId
     * @return
     */
    @RequestMapping(value = "/onlinePayPage")//,method = RequestMethod.POST
    public String onlinePayPage(HttpServletRequest request, Long orderId, PayMethodEnum payMethod) {
        Assert.notNull(orderId, "订单号不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(orderId);
        if (!orderResponse.success()) {
            throw new ValidationException(orderResponse.getErrorMsg());
        }
        SysOrderDTO orderDTO = orderResponse.getData();
        Assert.notNull(orderDTO, "未找到订单信息");
        //验证
        if (orderDTO.getPayStatus() != OrderPayStatusEnum.UNPAID) {
            throw new ValidationException("订单支付状态异常：" + orderDTO.getPayStatus());
        }
        //过期
        if (new Date().after(orderDTO.getExpire())) {
            throw new ValidationException("订单已过支付日期：" + orderDTO.getExpire());
        }
        if(payMethod == null){
            payMethod = orderDTO.getPaymentMethod();
        }
        if (payMethod != PayMethodEnum.ALIPAY_QR && payMethod != PayMethodEnum.WX_NATIVE) {
            throw new ValidationException("支付方式有误：" + payMethod);
        }

        //请求支付信息
        RestResponse<SysPayOrderDto> payOrderResponse = orderServiceRemoteService.getOnlinePayInfo(orderId, payMethod,null,null);
        if (!payOrderResponse.success()) {
            throw new ValidationException(payOrderResponse.getErrorMsg());
        }
        SysPayOrderDto sysPayOrderDto = payOrderResponse.getData();
        Map<String, Object> result = sysPayOrderDto.getPayResult();
        if (result != null) {
            String codeUrl = (String) result.get("codeUrl");
            if (codeUrl != null) {
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                QRCodeUtil.encode(codeUrl, 220, 220, out);
                byte[] tempbyte = out.toByteArray();
                String base64Url = Base64Util.encodeToString(tempbyte);
                request.setAttribute("codeUrl", "data:image/png;base64," + base64Url);
            }
        }
        request.setAttribute("payOrder",sysPayOrderDto);
        request.setAttribute("payMethod", payMethod);
        request.setAttribute("orderInfo", orderDTO);
        return "/tickets/order/pay_page";
    }

    /**
     * 查询在线支付订单状态
     * @param orderId
     * @return
     */
    @ResponseBody
    @RequestMapping("/queryPayStatus")
    public Boolean queryPayStatus(Long orderId){
        if(orderId == null){
            return Boolean.FALSE;
        }
        RestResponse<SysPayOrderDto> payOrderResponse = queryPayOrderRemoteService.queryUpdatePayOrderStatus(orderId+"",null,null);
        if(payOrderResponse.success()){
            SysPayOrderDto sysPayOrder = payOrderResponse.getData();
            if(sysPayOrder.getPayStatus() == PayOrderStatusEnum.SUCCESS ||
                    sysPayOrder.getPayStatus() == PayOrderStatusEnum.FAIL){
                return Boolean.TRUE;
            }
        }
        return Boolean.FALSE;
    }

    /**
     * 支付订单
     *
     * @param request
     * @param orderId
     * @return
     */
    //@ResponseBody
    @RequestMapping(value = "/payOrderPage")//,method = RequestMethod.POST
    public String payOrderPage(HttpServletRequest request, Long orderId) {
        Assert.notNull(orderId, "orderId不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(orderId);
        if (!orderResponse.success()) {
            throw new ValidationException(orderResponse.getErrorMsg());
        }
        SysOrderDTO orderDTO = orderResponse.getData();
        Assert.notNull(orderDTO, "未找到订单信息");
        //验证
        if (orderDTO.getPayStatus() != OrderPayStatusEnum.UNPAID) {
            throw new ValidationException("订单支付状态异常：" + orderDTO.getPayStatus());
        }
        //过期
        if (new Date().after(orderDTO.getExpire())) {
            throw new ValidationException("订单已过支付日期：" + orderDTO.getExpire());
        }

        SysUserDto sysUserDto = getCurrentMember();
        List<PayMethodEnum> list = new ArrayList<>();
        if (sysUserDto.getUserType() != SysUserType.distributor &&
                sysUserDto.getUserType() != SysUserType.distributor) {
            list.add(PayMethodEnum.OFFLINE_PAY);
        } else {
            list.add(PayMethodEnum.ALIPAY_QR);
            list.add(PayMethodEnum.DEPOSIT);
            list.add(PayMethodEnum.DEPOSIT_CREDIT);
            list.add(PayMethodEnum.WX_NATIVE);
        }
        request.setAttribute("orderInfo", orderDTO);
        request.setAttribute("paymentMethods", list);
        return "/tickets/order/order_pay";
    }

    /**
     * 支付订单
     *
     * @param request
     * @param orderId
     * @return
     */
    //@ResponseBody
    @RequestMapping(value = "/payOrder")//,method = RequestMethod.POST
    public String payOrder(HttpServletRequest request, Long orderId, PayMethodEnum payMethod,Boolean sendSms) {
        Assert.notNull(orderId, "orderId不能为空");
        Assert.notNull(payMethod, "支付方式不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(orderId);
        if (!orderResponse.success()) {
            throw new ValidationException(orderResponse.getErrorMsg());
        }
        SysOrderDTO orderDTO = orderResponse.getData();
        Assert.notNull(orderDTO, "未找到订单信息");
        //验证
        if (orderDTO.getPayStatus() != OrderPayStatusEnum.UNPAID) {
            throw new ValidationException("订单支付状态异常：" + orderDTO.getPayStatus());
        }
        //过期
        if (new Date().after(orderDTO.getExpire())) {
            throw new ValidationException("订单已过支付日期：" + orderDTO.getExpire());
        }
        SysUserDto sysUserDto = getCurrentMember();
        if (sysUserDto.getUserType() != SysUserType.distributor &&
                sysUserDto.getUserType() != SysUserType.distributor) {
            payMethod = PayMethodEnum.OFFLINE_PAY;
        } else {
            if (payMethod == PayMethodEnum.ALIPAY_QR ||
                    payMethod == PayMethodEnum.DEPOSIT ||
                    payMethod == PayMethodEnum.DEPOSIT_CREDIT ||
                    payMethod == PayMethodEnum.WX_NATIVE) {
                //满足条件
            } else {
                throw new ValidationException("支付方式异常：" + payMethod);
            }
            if (payMethod == PayMethodEnum.ALIPAY_QR ||
                    payMethod == PayMethodEnum.WX_NATIVE) {
                //在线支付跳转
                return "redirect:onlinePayPage?orderId=" + orderDTO.getId() + "&payMethod=" + payMethod;
            }
        }
        RestResponse<SysOrderDTO> orderPayResponse = orderServiceRemoteService.paid(getAccessToken(), orderId, payMethod, "支付订单");
        if (!orderPayResponse.success()) {
            throw new ValidationException(orderPayResponse.getErrorMsg());
        }
        //调用发货
        if(sendSms != null && sendSms){
            try{
                RestResponse<Boolean> shippingResponse = orderServiceRemoteService.orderShipping(getAccessToken(),orderDTO.getId());
                if (!shippingResponse.success()) {
                    throw new BusinessException(shippingResponse.getErrorMsg());
                }
            }catch (Exception e){
                logger.error(e.getMessage());
            }
        }
        return "redirect:orderList";
    }

    @RequestMapping("/orderList")
    public String orderList(HttpServletRequest request, SysOrderVO sysOrderVO) {
        String snAndName = RequestUtils.getString(request, "snAndName", null);
        if (StringUtils.isNumeric(snAndName)) {
            sysOrderVO.setProductSn(snAndName);
        } else {
            sysOrderVO.setProductName(snAndName);
        }
        RestResponse<PageDto<SysOrderDTO>> orderResponse = orderServiceRemoteService.findPage(getAccessToken(), sysOrderVO);
        if (!orderResponse.success()) {
            throw new BusinessException(orderResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysOrderVO);

        SysUserDto currentMember = getCurrentMember();
        //仅限管理员
        if (currentMember.getUserType() == SysUserType.admin) {
            UserQueryVo userQueryVo = new UserQueryVo();
            userQueryVo.setPageSize(20);
            userQueryVo.setUserType(SysUserType.supplier);
            RestResponse<PageDto<SysUserDto>> supplierResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
            if (!supplierResponse.success()) {
                throw new BusinessException(supplierResponse.getErrorMsg());
            }
            PageDto<SysUserDto> supplierPage = supplierResponse.getData();
            SysSightVO sysSightVO = new SysSightVO();
            sysSightVO.setPageSize(20);
            RestResponse<PageDto<SysSightDTO>> sightResponse = sightRemoteService.findPage(getAccessToken(), sysSightVO);
            if (!sightResponse.success()) {
                throw new BusinessException(sightResponse.getErrorMsg());
            }
            PageDto<SysSightDTO> sightPage = sightResponse.getData();
            if (supplierPage != null) {
                request.setAttribute("supplierList", supplierPage.getRecords());
            }
            if (sightPage != null) {
                request.setAttribute("sightList", sightPage.getRecords());
            }
        }

        RestResponse<List<SysOrderSourceDTO>> orderSourceResponse = orderSourceRemoteService.findEffectiveList(getAccessToken(),getCurrentModuleId(request));
        if (!orderSourceResponse.success()) {
            throw new BusinessException(orderSourceResponse.getErrorMsg());
        }
        List<SysOrderSourceDTO> orderSourcePage = orderSourceResponse.getData();

        if (orderSourcePage != null) {
            request.setAttribute("orderSources", orderSourcePage);
        }

        List<SaleChannelEnum> list = new ArrayList<>();
        list.add(SaleChannelEnum.BACK_ORDER);
        list.add(SaleChannelEnum.OTA_ORDER);
        list.add(SaleChannelEnum.QR_CODE_PAY);
        list.add(SaleChannelEnum.INTERNAL_ORDER);
        list.add(SaleChannelEnum.WAP_SHOP);
        list.add(SaleChannelEnum.WX_APPLET);
        list.add(SaleChannelEnum.PC_SHOP);
        request.setAttribute("snAndName", snAndName);
        request.setAttribute("saleChannels", list);
        request.setAttribute("payStatusList", OrderPayStatusEnum.values());
        request.setAttribute("payMethodList", PayMethodEnum.values());
        request.setAttribute("refundStatusList", RefundStatusEnum.values());
        request.setAttribute("shippingStatusList", ShippingStatusEnum.values());
        request.setAttribute("flagCollapsedx", RequestUtils.getString(request, "flagCollapsed", "false"));
        request.setAttribute("currentMember", currentMember);
        request.setAttribute("page", orderResponse.getData());
        return "/tickets/order/list";
    }

    /**
     * 订单发送短信
     * @param orderId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/shipping",method = RequestMethod.POST)
    public RestResponse shipping(Long orderId) {
        Assert.notNull(orderId, "orderId不能为空");
        RestResponse<Boolean> orderResponse = orderServiceRemoteService.orderShipping(getAccessToken(), orderId);
        return orderResponse;
    }

    @RequestMapping("/view")
    public String view(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(id);
        if (!orderResponse.success()) {
            throw new BusinessException(orderResponse.getErrorMsg());
        }
        request.setAttribute("order", orderResponse.getData());
        return "/tickets/order/view_bak";
    }

    /**
     * 修改使用日期预览
     *
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/preModifyUseTime")
    public String preModifyUseTime(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(id);
        if (!orderResponse.success()) {
            throw new BusinessException(orderResponse.getErrorMsg());
        }
        SysUserDto sysUserDto = getCurrentMember();
        SysOrderDTO orderDTO = orderResponse.getData();
        //分销商只支持指定日期的
        if(sysUserDto.getUserType() == SysUserType.distributor){
            if(!orderDTO.getSpecifyDate()){
                throw new ValidationException("该订单不支持改期");
            }
        }
        if(orderDTO.getDistributionId() != null){
            RestResponse<SysDistributionDTO> restResponse = distributionRemoteService.findById(orderDTO.getDistributionId());
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            request.setAttribute("distribution",restResponse.getData());
        }
        request.setAttribute("order", orderResponse.getData());
        return "/tickets/order/pre_modify_use_time";
    }

    @ResponseBody
    @RequestMapping("/doModifyUseTime")
    public RestResponse doModifyUseTime(Long id,String useDate,String vsdate,String vedate) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(id);
        if (!orderResponse.success()) {
            return orderResponse;
        }
        try{
            SysUserDto sysUserDto = getCurrentMember();
            SysOrderDTO orderDTO = orderResponse.getData();
            //分销商只支持指定日期的
            if(sysUserDto.getUserType() == SysUserType.distributor){
                if(!orderDTO.getSpecifyDate()){
                    throw new ValidationException("该订单不支持改期");
                }
            }
            if(orderDTO.getSpecifyDate()){
                Assert.hasText(useDate,"使用日期不能为空");
            }else{
                Assert.hasText(vsdate,"使用日期起不能为空");
                Assert.hasText(vedate,"使用日期止不能为空");
                if(DateUtil.compare(vsdate,vedate,"yyyy-MM-dd")>0){
                    throw new ValidationException("开始日期:"+vsdate+"不能大于结束日期:"+vedate);
                }
            }
            RestResponse<Boolean> restResponse = orderServiceRemoteService.modifyUseTime(getAccessToken(),id,useDate,vsdate,vedate);
            if(!restResponse.success()){
                return restResponse;
            }
        }catch (Exception e){
            return RestResponse.fail(e.getMessage());
        }
        return RestResponse.ok();
    }

    /**
     * 退款预览
     *
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/preRefund")
    public String preRefund(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(id);
        if (!orderResponse.success()) {
            throw new BusinessException(orderResponse.getErrorMsg());
        }
        request.setAttribute("order", orderResponse.getData());
        return "/tickets/order/pre_refund";
    }

    /**
     * 执行退款
     *
     * @param request
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/doRefund")
    public RestResponse doRefund(HttpServletRequest request, Long id, Integer quantity, String remark) {
        Assert.notNull(id, "id不能为空");
        SysRefundDTO refundDTO = new SysRefundDTO();
        refundDTO.setOrderId(id);
        String sn = UUID.randomUUID().toString();
        refundDTO.setSn(sn);
        refundDTO.setQuantity(quantity);
        refundDTO.setRequestId(sn);
        refundDTO.setRemark(remark);
        RestResponse<Boolean> orderResponse = orderServiceRemoteService.refundOrder(getAccessToken(), refundDTO);
        return orderResponse;
    }

    /**
     * 退款审核预览
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/preAuditRefund")
    public String preAuditRefund(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysOrderDTO> orderResponse = orderServiceRemoteService.findById(id);
        if (!orderResponse.success()) {
            throw new BusinessException(orderResponse.getErrorMsg());
        }

        SysOrderDTO sysOrderDTO = orderResponse.getData();
        List<SysRefundDTO> refundDTOList = sysOrderDTO.getSysRefunds();
        SysRefundDTO refundDTO = null;
        if (refundDTOList != null && !refundDTOList.isEmpty()) {
            for (SysRefundDTO refund : refundDTOList) {
                if (refund.getState() == RefundStateEnum.APPLY || refund.getState() == RefundStateEnum.WAITING_THIRD) {
                    refundDTO = refund;
                    break;
                }
            }
        }
        request.setAttribute("order", sysOrderDTO);
        request.setAttribute("refundDTO", refundDTO);
        return "/tickets/order/pre_audit_refund";
    }

    /**
     * 退款审核
     * @param id
     * @param agreeRefund
     * @param remark
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/doAuditRefund",method = RequestMethod.POST)
    public RestResponse doAuditRefund(Long id,Boolean agreeRefund,String remark) {
        Assert.notNull(id, "id不能为空");
        Assert.notNull(agreeRefund, "是否同意退款不能为空");
        if(agreeRefund){
            //同意退款
            return orderServiceRemoteService.agreeRefund(getAccessToken(),id,remark);
        }else {
            //拒绝退款
            return orderServiceRemoteService.disAgreeRefund(getAccessToken(),id,remark);
        }

    }


}
