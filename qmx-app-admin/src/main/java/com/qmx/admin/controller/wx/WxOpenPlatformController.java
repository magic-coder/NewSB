package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxOpenPlatformRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxOpenPlatformDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/wxOpenPlatform")
public class WxOpenPlatformController extends BaseController {

    @Autowired
    private WxOpenPlatformRemoteService wxOpenPlatformRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxOpenPlatformDto dto, ModelMap model) {
        RestResponse<PageDto<WxOpenPlatformDto>> restResponse = wxOpenPlatformRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxopenplatform/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        return "/wx/wxopenplatform/add";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(WxOpenPlatformDto dto) {
        RestResponse restResponse = wxOpenPlatformRemoteService.createOpenPlatform(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/edit")
    public String edit(ModelMap model, Long id) {
        RestResponse<WxOpenPlatformDto> restResponse = wxOpenPlatformRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxopenplatform/edit";
    }

    @RequestMapping(value = "/update")
    public String update(WxOpenPlatformDto dto) {
        RestResponse restResponse = wxOpenPlatformRemoteService.updateOpenPlatform(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxOpenPlatformRemoteService.deleteOpenPlatform(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
