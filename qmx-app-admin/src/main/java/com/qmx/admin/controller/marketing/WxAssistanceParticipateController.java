package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxAssistanceActivityRemoteService;
import com.qmx.admin.remoteapi.marketing.WxAssistanceParticipateRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxAssistanceActivityDto;
import com.qmx.marketing.api.dto.WxAssistanceParticipateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/wxAssistanceParticipate")
public class WxAssistanceParticipateController extends BaseController {

    @Autowired
    private WxAssistanceParticipateRemoteService wxAssistanceParticipateRemoteService;
    @Autowired
    private WxAssistanceActivityRemoteService wxAssistanceActivityRemoteService;
    @RequestMapping(value = "/list")
    public String list(WxAssistanceParticipateDto dto, ModelMap model) {
        RestResponse<PageDto<WxAssistanceParticipateDto>> restResponse = wxAssistanceParticipateRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxAssistanceActivityDto>> listRestResponse = wxAssistanceActivityRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "participate");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/assistanceparticipate/list";
    }
}
