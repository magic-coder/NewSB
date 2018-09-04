package com.qmx.admin.controller.wx;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxMembershipRuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxMembershipRuleDto;
import com.qmx.wxbasics.api.enumerate.MembershipRuleType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/wxMembershipRule")
public class WxMembershipRuleController extends BaseController {

    @Autowired
    private WxMembershipRuleRemoteService wxMembershipRuleRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxMembershipRuleDto dto, ModelMap model) {
        RestResponse<PageDto<WxMembershipRuleDto>> restResponse = wxMembershipRuleRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("type", "rule");
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxmembershiprule/list";
    }

    /**
     * 添加
     *
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/wx/wxmembershiprule/add";
    }

    /**
     * 编辑
     *
     * @param model
     * @param id
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(ModelMap model, Long id) {
        RestResponse<WxMembershipRuleDto> restResponse = wxMembershipRuleRemoteService.findId(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxmembershiprule/edit";
    }

    /**
     * 删除规则
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxMembershipRuleRemoteService.deleteMembershipRule(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 规则保存
     *
     * @param dto
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public JSONObject save(WxMembershipRuleDto dto, HttpServletRequest request) {
        if (dto.getType().equals(MembershipRuleType.integralConsumption)) {
            String jfNum = request.getParameter("xfNum");
            dto.setgNum(Double.valueOf(jfNum).doubleValue());
        }
        RestResponse<Object> object = wxMembershipRuleRemoteService.saveMembershipRule(getAccessToken(), dto);
        if (!object.success()) {
            throw new BusinessException(object.getErrorMsg());
        }
        JSONObject json = new JSONObject();
        if (object.getData() == null) {
            json.put("type", "1");
        } else {
            json.put("type", "2");
        }

        json.put("data", object.getData());
        return json;
    }

    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public JSONObject update(WxMembershipRuleDto dto, HttpServletRequest request) {
        if (dto.getType().equals(MembershipRuleType.integralConsumption)) {
            String jfNum = request.getParameter("xfNum");
            dto.setgNum(Double.valueOf(jfNum).doubleValue());
        }
        RestResponse<Object> object = wxMembershipRuleRemoteService.updateMembershipRule(getAccessToken(), dto);
        if (!object.success()) {
            throw new BusinessException(object.getErrorMsg());
        }
        JSONObject json = new JSONObject();
        if (object.getData() == null) {
            json.put("type", "1");
        } else {
            json.put("type", "2");
        }

        json.put("data", object.getData());
        return json;
    }

}
