package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxOpenConfigRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.wxbasics.api.dto.WxAuthorizationDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/wxAuthorization")
public class WxAuthorizationController extends BaseController {
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxOpenConfigRemoteService wxOpenConfigRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping(value = "/shouquan")
    public String xuanze(ModelMap model) {
        SysUserDto sysUserDto = getCurrentUser();
        RestResponse<WxAuthorizationDto> restResponse = wxAuthorizationRemoteService.findByMId(sysUserDto.getId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        /*if (restResponse != null && restResponse.getData() != null) {
            throw new BusinessException("当前账号已绑定微信公众号");
        }*/
        WxAuthorizationDto authorizationDto = restResponse.getData();
        Long platformId = authorizationDto.getPlatformId() == null ? 1L : authorizationDto.getPlatformId();
        String componentloginpage = wxAuthorizationRemoteService.componentloginpage(platformId).getData();
        if (componentloginpage == null) {
            throw new BusinessException("获取授权URL失败,稍后再试");
        }
        model.addAttribute("componentloginpage", componentloginpage);
        return "/wx/wxauthorization/shouquan";
    }

    @RequestMapping(value = "/shouquansuccess")
    public String shouquansuccess(HttpServletRequest request, ModelMap model) {
        return "/wx/wxauthorization/shouquansuccess";
    }

    @RequestMapping(value = "/list")
    public String list(WxAuthorizationDto dto, ModelMap model) {
        RestResponse<PageDto<WxAuthorizationDto>> restResponse = wxAuthorizationRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxauthorization/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        return "/wx/wxauthorization/add";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(WxAuthorizationDto dto) {
        RestResponse restResponse = wxAuthorizationRemoteService.createAuthorization(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/edit")
    public String edit(ModelMap model, Long id) {
        RestResponse<WxAuthorizationDto> restResponse = wxAuthorizationRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxauthorization/edit";
    }

    @RequestMapping(value = "/update")
    public String update(WxAuthorizationDto dto) {
        RestResponse restResponse = wxAuthorizationRemoteService.updateAuthorization(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxAuthorizationRemoteService.deleteAuthorization(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/getUser")
    public String getUser(UserQueryVo dto, ModelMap model) {
        dto.setUserType(SysUserType.supplier);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxauthorization/userlist";
    }

}
