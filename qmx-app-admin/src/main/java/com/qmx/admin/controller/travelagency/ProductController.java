package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.travelagency.ProductRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.ProductDto;
import com.qmx.travelagency.api.enumerate.OutTicketType;
import com.qmx.travelagency.api.enumerate.UseTicketType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("/taProduct")
@RequestMapping("/taProduct")
public class ProductController extends BaseController {
    @Autowired
    private ProductRemoteService productRemoteService;

    @RequestMapping(value = "/list")
    public String list(ProductDto dto, ModelMap model) {
        RestResponse<PageDto<ProductDto>> restResponse = productRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/product/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        model.addAttribute("outTickets", OutTicketType.values());
        model.addAttribute("useTickets", UseTicketType.values());
        return "/travelagency/product/add";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<ProductDto> restResponse = productRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("outTickets", OutTicketType.values());
        model.addAttribute("useTickets", UseTicketType.values());
        return "/travelagency/product/edit";
    }

    @RequestMapping(value = "/save")
    public String save(ProductDto dto) {
        RestResponse<ProductDto> restResponse = productRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(ProductDto dto) {
        RestResponse<ProductDto> restResponse = productRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = productRemoteService.deleteDto(getAccessToken(), id);
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
