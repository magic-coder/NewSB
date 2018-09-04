package com.qmx.admin.controller.member;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.member.MemberLevelRemoteService;
import com.qmx.admin.remoteapi.member.MemberRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.member.api.dto.MemberDto;
import com.qmx.member.api.dto.MemberLevelDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/member")
public class MemberController extends BaseController {
    @Autowired
    private MemberRemoteService memberRemoteService;
    @Autowired
    private MemberLevelRemoteService memberLevelRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping(value = "/list")
    public String list(MemberDto dto, ModelMap model) {
        RestResponse<PageDto<MemberDto>> restResponse = memberRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/member/member/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        RestResponse<List<MemberLevelDto>> restResponse = memberLevelRemoteService.findAll();
        model.addAttribute("listL", restResponse.getData());
        return "/member/member/add";
    }

    @RequestMapping(value = "adduser")
    public String addUser(HttpServletRequest request,UserQueryVo userQueryVo){
        userQueryVo.setUserType(SysUserType.employee);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(),userQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("userQueryVo",userQueryVo);
        request.setAttribute("page",restResponse.getData());
        return "/member/member/userlist";
    }

    @RequestMapping(value = "/save")
    public String save(MemberDto dto, HttpServletRequest request) {
        RestResponse<MemberDto> restResponse = memberRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<MemberDto> restResponse = memberRemoteService.findById(id);
        RestResponse<List<MemberLevelDto>> listL = memberLevelRemoteService.findAll();
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        MemberDto dto = restResponse.getData();
        model.addAttribute("dto", dto);
        model.addAttribute("listL", listL.getData());
        return "/member/member/edit";
    }

    @RequestMapping(value = "/update")
    public String update(MemberDto dto, HttpServletRequest request) {
        RestResponse<MemberDto> restResponse = memberRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = memberRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
