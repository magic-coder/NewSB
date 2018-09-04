package com.qmx.admin.controller.help;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.helpcenter.HelpDetailsService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.helpcenter.api.dto.HelpDetailsDto;
import com.qmx.helpcenter.api.dto.HelpExplainDto;
import com.qmx.member.api.dto.MemberDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * @Description 使用说明
 */
@Controller
@RequestMapping("/help")
public class HelpInstructionsController extends BaseController {

    @Autowired
    private HelpDetailsService helpDetailsService;

    /***
     * 普通用户跳转说明列表页面
     */
    @RequestMapping("/list")
    public String list(HelpExplainDto dto,Model model) {
        RestResponse<PageDto<HelpExplainDto>> restResponse = helpDetailsService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/instructions/list";
    }

    /**
     * 获得详细说明
     */
    @RequestMapping("/getdetails")
    public String getDetails(@RequestParam("id") Long id, Model model) {
        Assert.notNull(id, "无效的id");
        String accessToken = getAccessToken();
        if (accessToken != null && !accessToken.equals("")) {
            RestResponse<HelpDetailsDto> details = helpDetailsService.getDetails(accessToken, id);
            HelpDetailsDto data = details.getData();
            model.addAttribute("data", data);
        }
        return "/instructions/details";
    }

}
