package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxScratchCardRecordRemoteService;
import com.qmx.admin.remoteapi.marketing.WxScratchCardRemoteService;
import com.qmx.admin.remoteapi.marketing.WxShareCouponRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxScratchCardDto;
import com.qmx.marketing.api.dto.WxScratchCardRecordDto;
import com.qmx.marketing.api.dto.WxShareCouponDto;
import com.qmx.marketing.api.enumerate.ShareCouponType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxScratchCardRecord")
public class WxScratchCardRecordController extends BaseController {

    @Autowired
    private WxScratchCardRecordRemoteService wxScratchCardRecordRemoteService;
    @Autowired
    private WxShareCouponRemoteService wxShareCouponRemoteService;
    @Autowired
    private WxScratchCardRemoteService wxScratchCardRemoteService;

    /**
     * 列表
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxScratchCardRecordDto dto, ModelMap model){
        RestResponse<PageDto<WxScratchCardRecordDto>> restResponse = wxScratchCardRecordRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxScratchCardDto>> listRestResponse = wxScratchCardRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(listRestResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "record");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/scratchcardrecord/list";
    }

    @RequestMapping(value = "/prizeList")
    public String prizeList(WxShareCouponDto dto, ModelMap model){
        dto.setActivityType(ShareCouponType.scratchCard);
        RestResponse<PageDto<WxShareCouponDto>> restResponse = wxShareCouponRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "prizes");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/scratchcardrecord/prizelist";
    }

}
