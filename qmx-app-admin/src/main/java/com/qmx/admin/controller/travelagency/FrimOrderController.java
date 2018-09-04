package com.qmx.admin.controller.travelagency;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.travelagency.OrderRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.OrderDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("/taFrimOrderController")
@RequestMapping("/ta")
public class FrimOrderController extends BaseController {

    @Autowired
    private OrderRemoteService orderRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;

    @RequestMapping(value = "/{sn}")
    public String sn(@PathVariable String sn, ModelMap model) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findBySn(sn);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        OrderDto orderDto = restResponse.getData();
        if (orderDto != null) {
            model.addAttribute("order", orderDto);
        }
        return "/travelagency/order/frimorder";
    }

    @RequestMapping(value = "/m/{sn}")
    public String msn(@PathVariable String sn, ModelMap model) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findBySn(sn);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        OrderDto orderDto = restResponse.getData();
        if (orderDto != null) {
            model.addAttribute("order", orderDto);
        }
        model.addAttribute("user", getCurrentUser());
        return "/travelagency/order/frimorder";
    }
}
