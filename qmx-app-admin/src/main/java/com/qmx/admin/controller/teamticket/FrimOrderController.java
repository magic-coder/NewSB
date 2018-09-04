package com.qmx.admin.controller.teamticket;

import com.qmx.admin.remoteapi.teamticket.TtOrderRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.teamticket.api.dto.TtOrderDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/tt")
public class FrimOrderController {
    @Autowired
    private TtOrderRemoteService ttOrderRemoteService;

    @RequestMapping(value = "/{sn}")
    public String add(@PathVariable String sn, ModelMap model) {
        RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.findBySn(sn);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        TtOrderDto orderDto = restResponse.getData();
        if (orderDto != null) {
            model.addAttribute("order", orderDto);
        }
        return "/teamticket/ttorder/frimorder";
    }
}
