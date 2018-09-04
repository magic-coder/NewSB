package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.travelagency.OrderPrintRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.OrderPrintSetDto;
import com.qmx.travelagency.api.dto.TravelAgencyDto;
import com.qmx.travelagency.api.enumerate.OutTicketType;
import com.qmx.travelagency.api.enumerate.UseTicketType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller("/taOrderprintSet")
@RequestMapping("/taOrderprintSet")
public class OrderPrintSetController extends BaseController {
    @Autowired
    private OrderPrintRemoteService orderPrintRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;

    @RequestMapping(value = "/list")
    public String list(OrderPrintSetDto dto, ModelMap model) {
        RestResponse<PageDto<OrderPrintSetDto>> restResponse = orderPrintRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/printset/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        model.addAttribute("outTickets", OutTicketType.values());
        model.addAttribute("useTickets", UseTicketType.values());
        return "/travelagency/printset/add";
    }

    @RequestMapping(value = "/gettravelagency")
    public String gettravelagency(TravelAgencyDto dto, ModelMap model) {
        RestResponse<PageDto<TravelAgencyDto>> restResponse = travelAgencyRemoteService.findNotPrintSet(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("dto", dto);
        return "/travelagency/printset/travelagencylist";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<OrderPrintSetDto> restResponse = orderPrintRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("outTickets", OutTicketType.values());
        model.addAttribute("useTickets", UseTicketType.values());
        return "/travelagency/printset/edit";
    }

    @RequestMapping(value = "/save")
    public String save(OrderPrintSetDto dto, HttpServletRequest request) {
        List<Long> ids = OrderPrintSetDto.getIds(request);
        dto.setTravelagencyIds(ids);
        RestResponse<OrderPrintSetDto> restResponse = orderPrintRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(OrderPrintSetDto dto, HttpServletRequest request) {
        List<Long> ids = OrderPrintSetDto.getIds(request);
        dto.setTravelagencyIds(ids);
        RestResponse<OrderPrintSetDto> restResponse = orderPrintRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = orderPrintRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }
}
