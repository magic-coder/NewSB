package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxScratchCardParticipateRemoteService;
import com.qmx.admin.remoteapi.marketing.WxScratchCardRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxScratchCardDto;
import com.qmx.marketing.api.dto.WxScratchCardParticipateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxScratchCardParticipate")
public class WxScratchCardParticipateController extends BaseController {

    @Autowired
    private WxScratchCardParticipateRemoteService wxScratchCardParticipateRemoteService;
    @Autowired
    private WxScratchCardRemoteService wxScratchCardRemoteService;

    /**
     * 列表
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxScratchCardParticipateDto dto, ModelMap model){
        RestResponse<PageDto<WxScratchCardParticipateDto>> restResponse = wxScratchCardParticipateRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxScratchCardDto>> listRestResponse = wxScratchCardRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "participate");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/scratchcardparticipate/list";
    }

}
