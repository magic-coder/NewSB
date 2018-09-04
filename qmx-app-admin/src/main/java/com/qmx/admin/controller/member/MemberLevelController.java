package com.qmx.admin.controller.member;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.member.MemberLevelRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.member.api.dto.MemberLevelDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/memberLevel")
public class MemberLevelController extends BaseController {
    @Autowired
    private MemberLevelRemoteService memberLevelRemoteService;

    @RequestMapping(value = "/list")
    public String list(MemberLevelDto dto, ModelMap model) {
        RestResponse<PageDto<MemberLevelDto>> restResponse = memberLevelRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/member/memberLevel/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        RestResponse<List<MemberLevelDto>> levellist = memberLevelRemoteService.findAll();
        model.addAttribute("lList", levellist.getData());
        return "/member/memberLevel/add";
    }

    @RequestMapping(value = "/save")
    public String save(MemberLevelDto dto, HttpServletRequest request) {
        RestResponse<MemberLevelDto> restResponse = memberLevelRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<MemberLevelDto> restResponse = memberLevelRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<MemberLevelDto>> levellist = memberLevelRemoteService.findAll();
//        if(restResponse.getData().getUpgradeId() != null){
            for(MemberLevelDto memberLevelDto : levellist.getData()){
                if (memberLevelDto.getId().equals(restResponse.getData().getId())){
                    levellist.getData().remove(memberLevelDto);
                    break;
                }
            }
//        }
        model.addAttribute("lList", levellist.getData());
        MemberLevelDto dto = restResponse.getData();
        model.addAttribute("dto", dto);
        return "/member/memberLevel/edit";
    }

    @RequestMapping(value = "/update")
    public String update(MemberLevelDto dto, HttpServletRequest request) {
        RestResponse<MemberLevelDto> restResponse = memberLevelRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = memberLevelRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
