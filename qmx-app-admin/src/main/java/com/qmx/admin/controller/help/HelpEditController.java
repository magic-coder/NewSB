package com.qmx.admin.controller.help;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.helpcenter.HelpDetailsService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.helpcenter.api.dto.HelpDetailsDto;
import com.qmx.helpcenter.api.dto.HelpExplainDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

/**
 * @Description 使用说明
 */
@Controller
@RequestMapping("/helpmanage")
public class HelpEditController extends BaseController {

    @Autowired
    private HelpDetailsService helpDetailsService;

    /**
     * 管理员登录跳转编辑使用说明列表页面
     */
    @RequestMapping("/editlist")
    public String list(HelpExplainDto dto, Model model) {
        RestResponse<PageDto<HelpExplainDto>> restResponse = helpDetailsService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/instructions/editlist";
    }

    /**
     * 跳转到添加页面
     */
    @RequestMapping("/add")
    public String addHelp() {
        return "/instructions/add";
    }

    /**
     * 跳转到修改页面
     */

    @RequestMapping("/editor")
    public String editor(HelpExplainDto dto, Model model) {
        RestResponse<Object> data = helpDetailsService.geteditorDetails(getAccessToken(), dto);
        if (!data.success()) {
            throw new BusinessException(data.getErrorMsg());
        }
        model.addAttribute("data", data.getData());
        model.addAttribute("dto", dto);
        return "/instructions/editor";

    }

    /**
     * 获得详细说明
     */
    @RequestMapping("/getdetails")
    public String getDetails(@RequestParam("detailsId") Long detailsId, Model model) {
        Assert.notNull(detailsId, "无效的id");
        String accessToken = getAccessToken();
        if (accessToken != null && !accessToken.equals("")) {
            RestResponse<HelpDetailsDto> details = helpDetailsService.getDetails(accessToken, detailsId);
            HelpDetailsDto data = details.getData();
            model.addAttribute("data", data);
        }
        return "/instructions/details";
    }

    /***
     * 保存编辑更新
     */
    @RequestMapping(value = "/editorupdate", method = RequestMethod.POST)
    public String saveEditor(HelpExplainDto explainDto, HelpDetailsDto detailsDto, String[] type) {
        if (detailsDto.getDetails() == null) {
            detailsDto.setDetails("");
        }
        String details = detailsDto.getDetails();
        RestResponse restResponse = helpDetailsService.saveEditor(getAccessToken(), explainDto, details, type);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:/helpmanage/editlist";
    }

    /**
     * 删除说明(逻辑删除)
     */
    @RequestMapping(value = "/delete")
    public Object deldetails(Long id) {
            RestResponse deldetails = helpDetailsService.deldetails(getAccessToken(), id);
            if(!deldetails.success()){
                throw new BusinessException(deldetails.getErrorMsg());
            }
            return "redirect:/helpmanage/editlist";
    }

    /**
     * 保存说明
     */
    @RequestMapping("/save")
    public String save(HelpExplainDto dto, String[] type, @RequestParam(value = "details", defaultValue = "") String details) {
        RestResponse restResponse = helpDetailsService.save(getAccessToken(), dto, type, details);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:/helpmanage/editlist";
    }
}
