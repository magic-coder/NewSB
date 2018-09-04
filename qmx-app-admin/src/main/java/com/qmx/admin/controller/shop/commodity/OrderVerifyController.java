package com.qmx.admin.controller.shop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.commodity.OrderRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.OrderVerifyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.shop.api.dto.commodity.OrderDto;
import com.qmx.shop.api.dto.commodity.OrderVerifyDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by zcl on 2018/1/6.
 */
@Controller("/commodity/orderverify")
@RequestMapping("/commodity/orderverify")
public class OrderVerifyController extends BaseController {
    @Autowired
    private OrderVerifyRemoteService orderVerifyRemoteService;
    @Autowired
    private OrderRemoteService orderRemoteService;

    @RequestMapping(value = "/list")
    public String findList(OrderVerifyDto dto, ModelMap modelMap) {
        RestResponse<PageDto<OrderVerifyDto>> restResponse = orderVerifyRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/shop/commodity/vefify/list";
    }

    /**
     * 跳转验证页面
     *
     * @param
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/skipverifycode")
    public String skipShipment(String verifycode, ModelMap modelMap) {
        if (null == verifycode) {
            verifycode = "";
        }
        RestResponse<List<OrderVerifyDto>> listRestResponse = orderVerifyRemoteService.findByCode(verifycode);
        if (!listRestResponse.success()) {
            throw new RuntimeException(listRestResponse.getErrorMsg());
        }
        List<OrderDto> orderDtoList = new ArrayList<>();
        if (null != listRestResponse.getData() && !listRestResponse.getData().isEmpty()) {
            for (OrderVerifyDto dto : listRestResponse.getData()) {
                RestResponse<OrderDto> orderDtoRest = orderRemoteService.findOrder(getAccessToken(), dto.getOrderId());
                if (!orderDtoRest.success()) {
                    throw new RuntimeException(listRestResponse.getErrorMsg());
                }
                orderDtoRest.getData().setVerifyId(dto.getId());
                orderDtoList.add(orderDtoRest.getData());
            }
        }
        modelMap.addAttribute("orderList", orderDtoList);
        return "/shop/commodity/vefify/verifycode";
    }

    /**
     * 验证码验证
     *
     * @param dto
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/verifycode", method = RequestMethod.GET)
    public JSONObject shipment(OrderVerifyDto dto) {
        JSONObject jsonObject = new JSONObject();
        RestResponse<Boolean> restResponse = orderVerifyRemoteService.verifyCode(getAccessToken(), dto);
        if (restResponse.success()) {
            jsonObject.put("data", "success");
        } else {
            jsonObject.put("data", restResponse.getErrorMsg());
        }
        return jsonObject;
    }

    /**
     * 删除
     *
     * @param ids
     */
    @ResponseBody
    @RequestMapping("/delete")
    public JSONObject delete(String ids) {
        Assert.notNull(ids, "订单id不能为空");
        JSONObject jsonObject = new JSONObject();
        RestResponse<Boolean> restResponse = orderVerifyRemoteService.delete(ids, getAccessToken());
        if (restResponse.success()) {
            jsonObject.put("data", "success");
        } else {
            jsonObject.put("data", "error");
        }
        return jsonObject;
    }

    @ResponseBody
    @RequestMapping("/send")
    public JSONObject send(Long orderId) {
        JSONObject jsonObject = new JSONObject();
        try {
            Assert.notNull(orderId, "订单id不能为空");
            RestResponse<Boolean> booleanRest = orderVerifyRemoteService.sendMessage(orderId, getAccessToken());
            if (!booleanRest.success()) {
                jsonObject.put("data", "fail");
            } else {
                jsonObject.put("data", "success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonObject.put("data", "fail");
        }
        return jsonObject;
    }
}