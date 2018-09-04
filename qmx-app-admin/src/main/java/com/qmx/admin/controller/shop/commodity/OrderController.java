package com.qmx.admin.controller.shop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.commodity.OrderLogRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.OrderRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.OrderVerifyRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.RefundRemoteService;
import com.qmx.admin.utils.ExcelUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.shop.api.dto.commodity.OrderDto;
import com.qmx.shop.api.dto.commodity.OrderLogDto;
import com.qmx.shop.api.dto.commodity.OrderVerifyDto;
import com.qmx.shop.api.dto.commodity.RefundDto;
import com.qmx.shop.api.enumerate.commodity.OrderPaymentStatusEnum;
import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by zcl on 2018/1/4.
 */
@Controller("/commodity/order")
@RequestMapping("/commodity/order")
public class OrderController extends BaseController {
    @Autowired
    private OrderRemoteService orderRemoteService;
    @Autowired
    private OrderLogRemoteService orderLogRemoteService;
    @Autowired
    private RefundRemoteService refundRemoteService;
    @Autowired
    private OrderVerifyRemoteService orderVerifyRemoteService;

    /**
     * 订单列表
     *
     * @param orderDto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/list")
    public String findList(OrderDto orderDto, ModelMap modelMap) {
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), orderDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", orderDto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/shop/commodity/order/list";
    }

    /**
     * 删除订单
     *
     * @param ids
     */
    @ResponseBody
    @RequestMapping("/deleteOrder")
    public JSONObject deleteOrder(String ids) {
        Assert.notNull(ids, "订单id不能为空");
        JSONObject jsonObject = new JSONObject();
        try {
            RestResponse<Boolean> restResponse = orderRemoteService.deleteOrder(ids, getAccessToken());
            jsonObject.put("data", "1");
        } catch (Exception e) {
            jsonObject.put("data", "2");
            e.printStackTrace();
        }
        return jsonObject;
    }

    /**
     * 更新订单
     *
     * @param model
     * @param orderDto
     * @return
     */
    @RequestMapping(value = "/update", method = {RequestMethod.POST})
    public String updateOrder(RedirectAttributes model, OrderDto orderDto) {
        RestResponse<Boolean> restResponse = orderRemoteService.updateOrder(getAccessToken(), orderDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addFlashAttribute("msg", "更新成功");
        return "redirect:list";
    }

    /**
     * 查看订单
     *
     * @param orderId
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/viewOrder")
    public String viewOrder(Long orderId, ModelMap modelMap) {
        RestResponse<OrderDto> orderDto = orderRemoteService.findOrder(getAccessToken(), orderId);
        RestResponse<List<OrderLogDto>> orderLog = orderLogRemoteService.findOrderLog(getAccessToken(), orderId);
        RestResponse<RefundDto> refundDtoRest = refundRemoteService.getRefundByOid(getAccessToken(), orderId);
        if (!orderDto.success()) {
            throw new BusinessException(orderDto.getErrorMsg());
        }
        if (!orderLog.success()) {
            throw new BusinessException(orderLog.getErrorMsg());
        }
        if (!refundDtoRest.success()) {
            throw new BusinessException(refundDtoRest.getErrorMsg());
        }
        for (OrderLogDto orderLogDto : orderLog.getData()) {
            orderLogDto.setLogType(orderLogDto.getType().getType());
        }
        modelMap.addAttribute("orderLogs", orderLog.getData());
        modelMap.addAttribute("dto", orderDto.getData());
        modelMap.addAttribute("refundDto", refundDtoRest.getData());
        return "/shop/commodity/order/view";
    }

    /**
     * 更改订单支付状态
     *
     * @param model
     * @param orderId
     * @return
     */
    @RequestMapping("/changePay")
    public String changePay(RedirectAttributes model, Long orderId) {
        RestResponse<OrderDto> restResponse = orderRemoteService.updateOrderPay(getAccessToken(), orderId);
        if (!restResponse.success()) {
            model.addFlashAttribute("msg", restResponse.getErrorMsg());
        }else {
            if (restResponse.getData().getMailingMethod() == 1) {
                //邮寄
                RestResponse<OrderVerifyDto> verifyDtoRest = orderVerifyRemoteService.creatVerify(getAccessToken(), restResponse.getData());
                if (!verifyDtoRest.success()) {
                    throw new BusinessException(verifyDtoRest.getErrorMsg());
                }
            } else {
                //发码
                restResponse.getData().setVerificationCode(RandomStringUtils.randomNumeric(9));
                RestResponse<OrderVerifyDto> verifyDtoRest = orderVerifyRemoteService.creatVerify(getAccessToken(), restResponse.getData());
                if (!verifyDtoRest.success()) {
                    throw new BusinessException(verifyDtoRest.getErrorMsg());
                }
            }
            model.addFlashAttribute("msg", "操作成功");
        }
        return "redirect:list";
    }


    /**
     * 跳转发货页面
     *
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/skipShipment", method = RequestMethod.GET)
    public String skipShipment(OrderDto dto, ModelMap modelMap) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findOrder(getAccessToken(), dto.getId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        if (restResponse.getData().getPaymentStatus() == OrderPaymentStatusEnum.unpaid) {
            throw new BusinessException("订单未支付不能发货");
        }
        modelMap.addAttribute("orderId", dto.getId());
        return "/shop/commodity/order/shipment";
    }

    /**
     * 发货
     *
     * @param dto
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/shipment", method = RequestMethod.GET)
    public JSONObject shipment(OrderDto dto) {
        JSONObject jsonObject = new JSONObject();
        try {
            RestResponse<Boolean> orderDtoRest = orderRemoteService.shipment(getAccessToken(), dto);
            if (!orderDtoRest.success()) {
                throw new BusinessException(orderDtoRest.getErrorMsg());
            }
            jsonObject.put("data", "success");
        } catch (Exception e) {
            e.printStackTrace();
            jsonObject.put("data", e.getMessage());
        }
        return jsonObject;
    }

    /**
     * 获取准备退款的订单
     *
     * @param orderDto
     * @return
     */
    @ResponseBody
    @RequestMapping("/getRefundsOrderByOrderId")
    public OrderDto getRefundsOrderByOrderId(OrderDto orderDto) {
        Assert.notNull(orderDto.getId(), "订单id不能为空");
        RestResponse<OrderDto> restResponse = orderRemoteService.findOrder(getAccessToken(), orderDto.getId());
        String time = DateUtil.format(restResponse.getData().getCreateTime(), "yyyy-MM-dd HH:mm:ss");
        restResponse.getData().setFormatTime(time);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return restResponse.getData();
    }

    /**
     * 导出订单
     *
     * @param response
     * @param dto
     */
    @ResponseBody
    @RequestMapping(value = "/export", method = RequestMethod.GET)
    public void export(HttpServletResponse response, OrderDto dto) {
        RestResponse<List<OrderDto>> restResponse = orderRemoteService.exportOrder(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("商品订单", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (OrderDto orderDto : restResponse.getData()) {
                Object[] objects = new Object[8];
                objects[0] = orderDto.getId();
                objects[1] = orderDto.getReleaseName();
                objects[2] = orderDto.getTotalAmount();
                objects[3] = orderDto.getQuantity();
                objects[4] = orderDto.getPaymentStatus();
                objects[5] = orderDto.getRefundState();
                objects[6] = orderDto.getCreateTime();
                if (orderDto.getMailingMethod().equals(1)) {
                    objects[7] = "快递";
                } else {
                    objects[7] = "发码";
                }
                collection.add(objects);
            }
            ExcelUtils.export(collection, "商品订单", new String[]{"订单id", "产品名称", "总金额",
                            "商品数量", "支付状态", "退款状态", "订单日期", "发货类型"},
                    new int[]{0, 1, 2, 3, 4, 5, 6, 7}, restResponse.getData().size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}