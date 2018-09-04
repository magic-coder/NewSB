package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxTurntableParticipateRemoteService;
import com.qmx.admin.remoteapi.marketing.WxTurntableRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxTurntableDto;
import com.qmx.marketing.api.dto.WxTurntableParticipateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxTurntableParticipate")
public class WxTurntableParticipateController extends BaseController {

    @Autowired
    private WxTurntableParticipateRemoteService wxTurntableParticipateRemoteService;
    @Autowired
    private WxTurntableRemoteService wxTurntableRemoteService;

    /**
     * 列表
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxTurntableParticipateDto dto, ModelMap model){
        RestResponse<PageDto<WxTurntableParticipateDto>> restResponse = wxTurntableParticipateRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxTurntableDto>> listRestResponse = wxTurntableRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(listRestResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "participate");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/turntableparticipate/list";
    }
}
