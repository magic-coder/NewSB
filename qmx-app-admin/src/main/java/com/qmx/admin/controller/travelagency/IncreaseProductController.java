package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.travelagency.IncreaseProductRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.IncreaseProductDto;
import com.qmx.travelagency.api.enumerate.ProductType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("/taIncreaseProduct")
@RequestMapping("/taIncreaseProduct")
public class IncreaseProductController extends BaseController {
    @Autowired
    private IncreaseProductRemoteService increaseProductRemoteService;

    @RequestMapping(value = "/list")
    public String list(IncreaseProductDto dto, ModelMap model) {
        RestResponse<PageDto<IncreaseProductDto>> restResponse = increaseProductRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/increaseproduct/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        model.addAttribute("types", ProductType.values());
        return "/travelagency/increaseproduct/add";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<IncreaseProductDto> restResponse = increaseProductRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("types", ProductType.values());
        return "/travelagency/increaseproduct/edit";
    }

    @RequestMapping(value = "/save")
    public String save(IncreaseProductDto dto) {
        RestResponse<IncreaseProductDto> restResponse = increaseProductRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(IncreaseProductDto dto) {
        RestResponse<IncreaseProductDto> restResponse = increaseProductRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = increaseProductRemoteService.deleteDto(getAccessToken(), id);
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
