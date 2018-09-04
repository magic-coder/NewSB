package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxWristbandConfigRemoteService;
import com.qmx.admin.remoteapi.wx.WxWristbandRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxWristbandConfigDto;
import com.qmx.wxbasics.api.dto.WxWristbandDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxWristband")
public class WxWristbandController extends BaseController {

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxWristbandRemoteService wxWristbandRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxWristbandConfigRemoteService wxWristbandConfigRemoteService;

    @RequestMapping(value = "/list")
    public String list(WxWristbandDto dto, ModelMap model) {
        RestResponse<PageDto<WxWristbandDto>> restResponse = wxWristbandRemoteService.findList(getAccessToken(), dto);
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("type", "list");
        model.addAttribute("dto", dto);
        model.addAttribute("siteUrl", siteUrl);
        model.addAttribute("aid", aid);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxwristband/list";

    }

    @RequestMapping(value = "/config")
    public String config(ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        RestResponse<WxWristbandConfigDto> restResponse = wxWristbandConfigRemoteService.findByAid(aid);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        WxWristbandConfigDto dto = restResponse.getData();
        if (dto == null) {
            dto = new WxWristbandConfigDto();
            dto.setAuthorizer(aid);
            dto.setName(Boolean.FALSE);
            dto.setPhone(Boolean.FALSE);
            dto.setIdcard(Boolean.FALSE);
        }
        model.addAttribute("config", dto);
        model.addAttribute("type", "config");
        return "/wx/wxwristbandconfig/list";
    }

    @RequestMapping(value = "/saveconfig")
    public String saveconfig(WxWristbandConfigDto dto, ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        dto.setAuthorizer(aid);
        WxWristbandConfigDto dto1 = null;
        if (dto.getId() != null) {
            dto1 = wxWristbandConfigRemoteService.updateWxWristbandConfig(getAccessToken(), dto).getData();
        } else {
            dto1 = wxWristbandConfigRemoteService.createWxWristbandConfig(getAccessToken(), dto).getData();
        }
        model.addAttribute("config", dto1);
        model.addAttribute("msg", "操作成功");
        return "redirect:config";
    }
}
