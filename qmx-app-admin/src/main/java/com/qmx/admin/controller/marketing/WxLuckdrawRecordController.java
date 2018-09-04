package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxLuckdrawRecordRemoteService;
import com.qmx.admin.remoteapi.marketing.WxLuckdrawRemoteService;
import com.qmx.admin.remoteapi.marketing.WxShareCouponRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxLuckdrawDto;
import com.qmx.marketing.api.dto.WxLuckdrawRecordDto;
import com.qmx.marketing.api.dto.WxShareCouponDto;
import com.qmx.marketing.api.enumerate.ShareCouponType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxLuckdrawRecord")
public class WxLuckdrawRecordController extends BaseController {

    @Autowired
    private WxLuckdrawRecordRemoteService wxLuckdrawRecordRemoteService;
    @Autowired
    private WxShareCouponRemoteService wxShareCouponRemoteService;
    @Autowired
    private WxLuckdrawRemoteService wxLuckdrawRemoteService;

    /**
     * 列表
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxLuckdrawRecordDto dto, ModelMap model){
        RestResponse<PageDto<WxLuckdrawRecordDto>> restResponse = wxLuckdrawRecordRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxLuckdrawDto>> listRestResponse = wxLuckdrawRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(listRestResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "record");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/luckdrawrecord/list";
    }

    @RequestMapping(value = "/prizeList")
    public String prizeList(WxShareCouponDto dto, ModelMap model){
        dto.setActivityType(ShareCouponType.luckdraw);
        RestResponse<PageDto<WxShareCouponDto>> restResponse = wxShareCouponRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "prizes");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/luckdrawrecord/prizelist";
    }

}
