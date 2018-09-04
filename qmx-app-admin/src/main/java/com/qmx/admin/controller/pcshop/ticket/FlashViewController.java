package com.qmx.admin.controller.pcshop.ticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.common.FlashViewRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.shop.api.dto.common.FlashViewDto;
import com.qmx.shop.api.enumerate.common.CarouselTypeEnum;
import com.qmx.shop.api.enumerate.common.PlatformTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("/pcticket/flashview")
@RequestMapping("/pcticket/flashview")
public class FlashViewController extends BaseController {
    @Autowired
    private FlashViewRemoteService flashViewRemoteService;

    @RequestMapping(value = "/list")
    public String list(FlashViewDto dto, ModelMap model) {
        model.addAttribute("type", "flashviewlist");
        dto.setCarouselType(CarouselTypeEnum.Ticket);
        //设置默认查询微信端数据
        dto.setPlatformType(PlatformTypeEnum.PC);
        RestResponse<PageDto<FlashViewDto>> restResponse = flashViewRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/pcshop/ticket/flashview/list";
    }

    @RequestMapping(value = "/add")
    public String add() {
        return "/pcshop/ticket/flashview/add";
    }

    @RequestMapping(value = "/save")
    public String save(FlashViewDto dto) {
        dto.setCarouselType(CarouselTypeEnum.Ticket);
        //设置为微信端数据
        dto.setPlatformType(PlatformTypeEnum.PC);
        RestResponse<FlashViewDto> restResponse = flashViewRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<FlashViewDto> restResponse = flashViewRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/pcshop/ticket/flashview/edit";
    }

    @RequestMapping(value = "/update")
    public String update(FlashViewDto dto) {
        dto.setCarouselType(CarouselTypeEnum.Ticket);
        RestResponse<FlashViewDto> restResponse = flashViewRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
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
