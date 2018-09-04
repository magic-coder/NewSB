package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxAssistanceRecordRemoteService;
import com.qmx.admin.remoteapi.marketing.WxShareCouponRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.marketing.api.dto.WxAssistanceRecordDto;
import com.qmx.marketing.api.dto.WxShareCouponDto;
import com.qmx.marketing.api.enumerate.ShareCouponType;
import com.qmx.wxbasics.api.dto.WxUserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxAssistanceRecord")
public class WxAssistanceRecordController extends BaseController {

    @Autowired
    private WxAssistanceRecordRemoteService wxAssistanceRecordRemoteService;
    @Autowired
    private WxShareCouponRemoteService wxShareCouponRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    @RequestMapping(value = "/list")
    public String list(WxAssistanceRecordDto dto, ModelMap model) {
        RestResponse<PageDto<WxAssistanceRecordDto>> restResponse = wxAssistanceRecordRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "record");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/assistancerecord/list";
    }

    @RequestMapping(value = "/prizeList")
    public String prizeList(WxShareCouponDto dto, ModelMap model){
        dto.setActivityType(ShareCouponType.assistance);
        RestResponse<PageDto<WxShareCouponDto>> restResponse = wxShareCouponRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "prizes");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/assistancerecord/prizelist";
    }

}
