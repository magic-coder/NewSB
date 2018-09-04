package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.CarRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.travelagency.api.dto.CarDto;
import com.qmx.travelagency.api.dto.TravelAgencyDto;
import com.qmx.travelagency.api.enumerate.Level;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("/taCar")
@RequestMapping("/taCar")
public class CarController extends BaseController {
    @Autowired
    private CarRemoteService carRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;

    @RequestMapping(value = "/list")
    public String list(CarDto dto, ModelMap model) {
        RestResponse<PageDto<CarDto>> restResponse = carRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/car/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        SysUserDto userDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (userDto.getUserType() != SysUserType.distributor) {
            model.addAttribute("user", userDto);
        }
        model.addAttribute("levels", Level.values());
        return "/travelagency/car/add";
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
        return "/travelagency/car/userlist";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<CarDto> restResponse = carRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("levels", Level.values());
        return "/travelagency/car/edit";
    }

    @RequestMapping(value = "/save")
    public String save(CarDto dto) {
        RestResponse<CarDto> restResponse = carRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(CarDto dto) {
        RestResponse<CarDto> restResponse = carRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = carRemoteService.deleteDto(getAccessToken(), id);
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
