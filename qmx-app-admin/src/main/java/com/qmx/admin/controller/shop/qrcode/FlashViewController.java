package com.qmx.admin.controller.shop.qrcode;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.qrcode.FlashViewRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.shop.api.dto.qrcode.FlashViewDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("/qrcode/flashview")
@RequestMapping("/qrcode/flashview")
public class FlashViewController extends BaseController {
    @Autowired
    private FlashViewRemoteService flashViewRemoteService;

    @RequestMapping(value = "/list")
    public String list(FlashViewDto dto, ModelMap model) {
        model.addAttribute("type", "flashviewlist");
        RestResponse<PageDto<FlashViewDto>> restResponse = flashViewRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/shop/qrcode/flashview/list";
    }

    @RequestMapping(value = "/add")
    public String add(Long groupId, ModelMap modelMap) {
        modelMap.addAttribute("groupId", groupId);
        return "/shop/qrcode/flashview/add";
    }

    @RequestMapping(value = "/save")
    public String save(FlashViewDto dto) {
        RestResponse<FlashViewDto> restResponse = flashViewRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml?groupId=" + restResponse.getData().getGroupId();
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<FlashViewDto> restResponse = flashViewRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/shop/qrcode/flashview/edit";
    }

    @RequestMapping(value = "/update")
    public String update(FlashViewDto dto) {
        RestResponse<FlashViewDto> restResponse = flashViewRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml?groupId=" + restResponse.getData().getGroupId();
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = flashViewRemoteService.deleteDto(getAccessToken(), id);
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
