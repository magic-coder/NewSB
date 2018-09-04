package com.qmx.admin.controller.member;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.member.MemberLevelRemoteService;
import com.qmx.admin.remoteapi.member.RechargeRuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.member.api.dto.MemberLevelDto;
import com.qmx.member.api.dto.RechargeRuleDto;
import com.qmx.member.api.enumerate.RechargeType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/rechargerule")
public class RechargeRuleController extends BaseController {
    @Autowired
    private RechargeRuleRemoteService rechargeRuleRemoteService;
    @Autowired
    private MemberLevelRemoteService memberLevelRemoteService;

    @RequestMapping(value = "/list")
    public String list(RechargeRuleDto dto, String levelName, ModelMap model) {
        RestResponse<List<MemberLevelDto>> levellist = memberLevelRemoteService.findAll();
        model.addAttribute("dto", dto);
        model.addAttribute("levelName", levelName);
        model.addAttribute("lList", levellist.getData());
        if (levelName != null) {
            MemberLevelDto data = memberLevelRemoteService.findByName(levelName).getData();
            if(data != null){
            dto.setLevelId(data.getId());
            }else {
                model.addAttribute("page", new PageDto<RechargeRuleDto>());
                return "/member/rechargerule/list";
            }
        }
        RestResponse<PageDto<RechargeRuleDto>> restResponse = rechargeRuleRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("page", restResponse.getData());
        return "/member/rechargerule/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        RestResponse<List<MemberLevelDto>> levellist = memberLevelRemoteService.findAll();
        model.addAttribute("lList", levellist.getData());
//        model.addAttribute("typeList", RechargeType.values());
        return "/member/rechargerule/add";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(RechargeRuleDto dto, HttpServletRequest request) {

        RestResponse<RechargeRuleDto> restResponse = rechargeRuleRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }


        return "redirect:list";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<RechargeRuleDto> restResponse = rechargeRuleRemoteService.findById(id);
        RestResponse<List<MemberLevelDto>> levellist = memberLevelRemoteService.findAll();

        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RechargeRuleDto dto = restResponse.getData();
        model.addAttribute("dto", dto);
        model.addAttribute("lList", levellist.getData());
//        model.addAttribute("typeList", RechargeType.values());
        return "/member/rechargerule/edit";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(RechargeRuleDto dto, HttpServletRequest request) {
        RestResponse<RechargeRuleDto> restResponse = rechargeRuleRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = rechargeRuleRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
