package com.qmx.admin.controller.marketing;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxBargainActivityRemoteService;
import com.qmx.admin.remoteapi.marketing.WxBargainParticipateRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxBargainActivityDto;
import com.qmx.marketing.api.dto.WxBargainParticipateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/wxBargainParticipate")
public class WxBargainParticipateController extends BaseController {

    @Autowired
    private WxBargainParticipateRemoteService wxBargainParticipateRemoteService;
    @Autowired
    private WxBargainActivityRemoteService wxBargainActivityRemoteService;

    @RequestMapping(value = "/list")
    public String list(WxBargainParticipateDto dto, ModelMap model){
        RestResponse<PageDto<WxBargainParticipateDto>> restResponse = wxBargainParticipateRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxBargainActivityDto>> listRestResponse = wxBargainActivityRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "participate");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/bargainparticipate/list";
    }
}
