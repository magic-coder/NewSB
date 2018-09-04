package com.qmx.admin.controller.shop.seat;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.seat.OrderRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.shop.api.dto.seat.OrderDto;
import com.qmx.shop.api.enumerate.seat.SeatOrderStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by earnest on 2018/5/24 0024.
 */
@Controller("/seat/order")
@RequestMapping("/seat/order")
public class OrderController extends BaseController {
    @Autowired
    private OrderRemoteService orderRemoteService;

    @RequestMapping("/list")
    public String list(OrderDto dto, ModelMap model) {
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("types", SeatOrderStatus.values());
        return "/shop/seat/list";
    }
}
