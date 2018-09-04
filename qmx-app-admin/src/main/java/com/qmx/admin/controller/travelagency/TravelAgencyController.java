package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.travelagency.api.dto.TravelAgencyDto;
import com.qmx.travelagency.api.enumerate.Level;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("/taTravelAgency")
@RequestMapping("/taTravelAgency")
public class TravelAgencyController extends BaseController {
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;

    @RequestMapping(value = "/list")
    public String list(TravelAgencyDto dto, ModelMap model) {
        RestResponse<PageDto<TravelAgencyDto>> restResponse = travelAgencyRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/travelagency/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        SysUserDto userDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (userDto.getUserType() == SysUserType.employee) {
            model.addAttribute("manager", userDto);
        }
        model.addAttribute("levels", Level.values());
        return "/travelagency/travelagency/add";
    }

    @RequestMapping(value = "/getUser")
    public String getUser(UserQueryVo dto, String type, ModelMap model) {
        if ("1".equals(type)) {
            dto.setUserType(SysUserType.distributor);
        } else if ("2".equals(type)) {
            dto.setUserType(SysUserType.employee);
        }
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("type", type);
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/travelagency/userlist";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<TravelAgencyDto> restResponse = travelAgencyRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        TravelAgencyDto dto = restResponse.getData();

        RestResponse<SysUserDto> userRestResponse = sysUserRemoteService.findById(dto.getUserId());
        if (!userRestResponse.success()) {
            throw new BusinessException(userRestResponse.getErrorMsg());
        }
        dto.setUserName(userRestResponse.getData().getUsername());
        RestResponse<SysUserDto> managerRestResponse = sysUserRemoteService.findById(dto.getManager());
        if (!managerRestResponse.success()) {
            throw new BusinessException(managerRestResponse.getErrorMsg());
        }
        dto.setManagerName(managerRestResponse.getData().getUsername());

        model.addAttribute("dto", dto);
        model.addAttribute("levels", Level.values());
        return "/travelagency/travelagency/edit";
    }

    @RequestMapping(value = "/save")
    public String save(TravelAgencyDto dto) {
        RestResponse<TravelAgencyDto> restResponse = travelAgencyRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(TravelAgencyDto dto) {
        RestResponse<TravelAgencyDto> restResponse = travelAgencyRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = travelAgencyRemoteService.deleteDto(getAccessToken(), id);
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
