package com.qmx.admin.controller.marketing;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxLuckdrawParticipateRemoteService;
import com.qmx.admin.remoteapi.marketing.WxLuckdrawRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxLuckdrawDto;
import com.qmx.marketing.api.dto.WxLuckdrawParticipateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/WxLuckdrawParticipate")
public class WxLuckdrawParticipateController extends BaseController {

    @Autowired
    private WxLuckdrawParticipateRemoteService wxLuckdrawParticipateRemoteService;
    @Autowired
    private WxLuckdrawRemoteService wxLuckdrawRemoteService;

    /**
     * 列表
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxLuckdrawParticipateDto dto, ModelMap model){
        RestResponse<PageDto<WxLuckdrawParticipateDto>> restResponse = wxLuckdrawParticipateRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<WxLuckdrawDto>> listRestResponse = wxLuckdrawRemoteService.findAll(getAccessToken());
        if (!listRestResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "participate");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("activitys", listRestResponse.getData());
        return "/marketing/luckdrawparticipate/list";
    }

}
