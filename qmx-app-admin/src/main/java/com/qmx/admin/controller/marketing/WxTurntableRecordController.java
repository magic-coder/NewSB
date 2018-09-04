package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxShareCouponRemoteService;
import com.qmx.admin.remoteapi.marketing.WxTurntableRecordRemoteService;
import com.qmx.admin.remoteapi.marketing.WxTurntableRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxShareCouponDto;
import com.qmx.marketing.api.dto.WxTurntableDto;
import com.qmx.marketing.api.dto.WxTurntableRecordDto;
import com.qmx.marketing.api.enumerate.ShareCouponType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxTurntableRecord")
public class WxTurntableRecordController extends BaseController {

    @Autowired
    private WxTurntableRecordRemoteService wxTurntableRecordRemoteService;
    @Autowired
    private WxShareCouponRemoteService wxShareCouponRemoteService;
    @Autowired
    private WxTurntableRemoteService wxTurntableRemoteService;

    /**
     * 列表
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxTurntableRecordDto dto, ModelMap model){
        RestResponse<PageDto<WxTurntableRecordDto>> restResponse = wxTurntableRecordRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxTurntableDto>> listRestResponse = wxTurntableRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(listRestResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "record");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/turntablerecord/list";
    }

    @RequestMapping(value = "/prizeList")
    public String prizeList(WxShareCouponDto dto, ModelMap model){
        dto.setActivityType(ShareCouponType.turntable);
        RestResponse<PageDto<WxShareCouponDto>> restResponse = wxShareCouponRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "prizes");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/turntablerecord/prizelist";
    }

}
