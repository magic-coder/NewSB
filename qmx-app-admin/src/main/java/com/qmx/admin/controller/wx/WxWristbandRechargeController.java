package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxWristbandRechargeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxWristbandRechargeDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxWristbandRecharge")
public class WxWristbandRechargeController extends BaseController {

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxWristbandRechargeRemoteService wxWristbandRechargeRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    @RequestMapping(value = "/list")
    public String list(WxWristbandRechargeDto dto, ModelMap model) {
        RestResponse<PageDto<WxWristbandRechargeDto>> restResponse = wxWristbandRechargeRemoteService.findList(getAccessToken(), dto);
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("type", "record");
        model.addAttribute("dto", dto);
        model.addAttribute("siteUrl", siteUrl);
        model.addAttribute("aid", aid);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxwristbandrecharge/list";
    }
}
