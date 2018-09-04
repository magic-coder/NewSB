package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxMembershipRecordRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxMembershipRecordDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxMembershipRecord")
public class WxMembershipRecordController extends BaseController {

    @Autowired
    private WxMembershipRecordRemoteService wxMembershipRecordRemmoteService;

    @RequestMapping(value = "/list")
    public String list(WxMembershipRecordDto dto, ModelMap model) {
        RestResponse<PageDto<WxMembershipRecordDto>> restResponse = wxMembershipRecordRemmoteService.findList(getAccessToken(), dto);

        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("type", "record");
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxmembershiprecord/list";
    }
}
