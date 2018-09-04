package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.DriverRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.travelagency.api.dto.DriverDto;
import com.qmx.travelagency.api.dto.TravelAgencyDto;
import com.qmx.travelagency.api.enumerate.DrivingLicenseLevel;
import com.qmx.travelagency.api.enumerate.Gender;
import com.qmx.travelagency.api.enumerate.Level;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("/taDriver")
@RequestMapping("/taDriver")
public class DriverController extends BaseController {
    @Autowired
    private DriverRemoteService driverRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;

    @RequestMapping(value = "/list")
    public String list(DriverDto dto, ModelMap model) {
        RestResponse<PageDto<DriverDto>> restResponse = driverRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("types", DrivingLicenseLevel.values());
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());

        return "/travelagency/driver/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        SysUserDto userDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (userDto.getUserType() != SysUserType.distributor) {
            model.addAttribute("user", userDto);
        }
        model.addAttribute("levels", Level.values());
        model.addAttribute("genders", Gender.values());
        model.addAttribute("types", DrivingLicenseLevel.values());
        return "/travelagency/driver/add";
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
        return "/travelagency/driver/userlist";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<DriverDto> restResponse = driverRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("levels", Level.values());
        model.addAttribute("genders", Gender.values());
        return "/travelagency/driver/edit";
    }

    @RequestMapping(value = "/save")
    public String save(DriverDto dto) {
        RestResponse<DriverDto> restResponse = driverRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(DriverDto dto) {
        RestResponse<DriverDto> restResponse = driverRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = driverRemoteService.deleteDto(getAccessToken(), id);
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
