package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.GuideRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.travelagency.api.dto.GuideDto;
import com.qmx.travelagency.api.dto.TravelAgencyDto;
import com.qmx.travelagency.api.enumerate.Gender;
import com.qmx.travelagency.api.enumerate.GuideType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller("/taGuide")
@RequestMapping("/taGuide")
public class GuideController extends BaseController {
    @Autowired
    private GuideRemoteService guideRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;

    @RequestMapping(value = "/list")
    public String list(GuideDto dto, ModelMap model) {
        RestResponse<PageDto<GuideDto>> restResponse = guideRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("types", GuideType.values());
        return "/travelagency/guide/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        SysUserDto userDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (userDto.getUserType() != SysUserType.distributor) {
            model.addAttribute("user", userDto);
        }
        model.addAttribute("types", GuideType.values());
        model.addAttribute("genders", Gender.values());
        return "/travelagency/guide/add";
    }

    @RequestMapping(value = "/getUser")
    public String getUser(TravelAgencyDto dto, ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        if (SysUserType.employee.equals(userDto.getUserType())) {
            dto.setSupplierId(userDto.getSupplierId());
        } else if (SysUserType.supplier.equals(userDto.getUserType())) {
            dto.setSupplierId(userDto.getId());
        } else {
            dto.setSupplierId(userDto.getId());
        }
        RestResponse<PageDto<TravelAgencyDto>> restResponse = travelAgencyRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/guide/userlist";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<GuideDto> restResponse = guideRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("types", GuideType.values());
        model.addAttribute("genders", Gender.values());
        return "/travelagency/guide/edit";
    }

    @RequestMapping(value = "/save")
    public String save(GuideDto dto) {
        RestResponse<GuideDto> restResponse = guideRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(GuideDto dto) {
        RestResponse<GuideDto> restResponse = guideRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = guideRemoteService.deleteDto(getAccessToken(), id);
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
