package com.qmx.admin.controller.marketing;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxSignActivityRemoteService;
import com.qmx.admin.remoteapi.marketing.WxSignPrizeRemoteService;
import com.qmx.admin.remoteapi.marketing.WxSignRuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxSignActivityDto;
import com.qmx.marketing.api.dto.WxSignPrizeDto;
import com.qmx.marketing.api.dto.WxSignRuleDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/WxSignRule")
public class WxSignRuleController extends BaseController {

    @Autowired
    private WxSignRuleRemoteService wxSignRuleRemoteService;
    @Autowired
    private WxSignActivityRemoteService wxSignActivityRemoteService;
    @Autowired
    private WxSignPrizeRemoteService wxSignPrizeRemoteService;

    /**
     * 列表
     */
    @RequestMapping(value = "/list")
    public String list(WxSignRuleDto dto, ModelMap model) {
        RestResponse<PageDto<WxSignRuleDto>> restResponse = wxSignRuleRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "rule");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/signrule/list";
    }

    /**
     * 添加
     *
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/marketing/signrule/add";
    }

    /**
     * 编辑
     */
    @RequestMapping("/edit")
    public String edit(Long id, ModelMap model){
        RestResponse<WxSignRuleDto> restResponse = wxSignRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/marketing/signrule/edit";
    }

    /**
     * 活动列表
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/signActivityList")
    public String signActivityList(WxSignActivityDto dto, ModelMap model){
        RestResponse<PageDto<WxSignActivityDto>> restResponse = wxSignActivityRemoteService.findList(getAccessToken(),dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/marketing/signrule/activitylist";
    }

    /**
     * 奖品列表
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/prizeList")
    public String prizeList(WxSignPrizeDto dto, ModelMap model){
        RestResponse<PageDto<WxSignPrizeDto>> restResponse = wxSignPrizeRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/marketing/signrule/prizelist";
    }
    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public JSONObject save(WxSignRuleDto dto, HttpServletRequest request){
        JSONObject json = new JSONObject();
        RestResponse<WxSignRuleDto> restResponse = wxSignRuleRemoteService.createDto(getAccessToken(),dto);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "保存失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "保存成功！");
        }
        return json;
    }

    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public JSONObject update(WxSignRuleDto dto, HttpServletRequest request){
        JSONObject json = new JSONObject();
        RestResponse<WxSignRuleDto> restResponse = wxSignRuleRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "保存失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "保存成功！");
        }
        return json;
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = wxSignRuleRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

}
