package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxSignActivityRemoteService;
import com.qmx.admin.remoteapi.marketing.WxSignParticipateRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxSignActivityDto;
import com.qmx.marketing.api.dto.WxSignParticipateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxSignParticipate")
public class WxSignParticipateController extends BaseController {


    @Autowired
    private WxSignParticipateRemoteService wxSignParticipateRemoteService;
    @Autowired
    private WxSignActivityRemoteService wxSignActivityRemoteService;

    /**
     * 列表
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxSignParticipateDto dto, ModelMap model){
        RestResponse<PageDto<WxSignParticipateDto>> restResponse = wxSignParticipateRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxSignActivityDto>> listRestResponse = wxSignActivityRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(listRestResponse.getErrorMsg());
        }

        model.addAttribute("dto", dto);
        model.addAttribute("type", "participate");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/signparticipate/list";
    }
}
