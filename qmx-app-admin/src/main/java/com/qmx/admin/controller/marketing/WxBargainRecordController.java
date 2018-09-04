package com.qmx.admin.controller.marketing;


import com.qmx.admin.remoteapi.marketing.WxBargainActivityRemoteService;
import com.qmx.admin.remoteapi.marketing.WxBargainRecordRemoteService;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxBargainActivityDto;
import com.qmx.marketing.api.dto.WxBargainRecordDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/wxBargainRecord")
public class WxBargainRecordController extends BaseController {

    @Autowired
    private WxBargainRecordRemoteService wxBargainRecordRemoteService;

    @RequestMapping(value = "/list")
    public String list(WxBargainRecordDto dto, ModelMap model){
        RestResponse<PageDto<WxBargainRecordDto>> restResponse = wxBargainRecordRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "record");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/bargainrecord/list";
    }
}
