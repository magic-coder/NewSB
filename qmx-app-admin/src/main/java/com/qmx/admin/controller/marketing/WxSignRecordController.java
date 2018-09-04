package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxShareCouponRemoteService;
import com.qmx.admin.remoteapi.marketing.WxSignActivityRemoteService;
import com.qmx.admin.remoteapi.marketing.WxSignRecordRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxShareCouponDto;
import com.qmx.marketing.api.dto.WxSignActivityDto;
import com.qmx.marketing.api.dto.WxSignRecordDto;
import com.qmx.marketing.api.enumerate.ShareCouponType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxSignRecord")
public class WxSignRecordController extends BaseController {

    @Autowired
    private WxSignRecordRemoteService wxSignRecordRemoteService;
    @Autowired
    private WxShareCouponRemoteService wxShareCouponRemoteService;
    @Autowired
    private WxSignActivityRemoteService wxSignActivityRemoteService;

    /**
     * 列表
     */
    @RequestMapping(value = "/list")
    public String list(WxSignRecordDto dto, ModelMap model) {
        RestResponse<PageDto<WxSignRecordDto>> restResponse = wxSignRecordRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxSignActivityDto>> listRestResponse = wxSignActivityRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(listRestResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "record");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/signrecord/list";
    }

    @RequestMapping(value = "/prizeList")
    public String prizeList(WxShareCouponDto dto, ModelMap model){
        dto.setActivityType(ShareCouponType.sign);
        RestResponse<PageDto<WxShareCouponDto>> restResponse = wxShareCouponRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "prizes");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/signrecord/prizelist";
    }

}
