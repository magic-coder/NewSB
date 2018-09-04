package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsConfigRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsConfigDto;
import com.qmx.coreservice.api.message.sms.enumerate.SmsPlatType;
import com.qmx.coreservice.api.message.sms.query.SmsConfigQueryVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Author liubin
 * @Description 短信配置
 * @Date Created on 2017/12/25 18:16.
 * @Modified By
 */
@Controller
@RequestMapping("/smsConfig")
public class SmsConfigController extends BaseController {

    @Autowired
    private SmsConfigRemoteService smsConfigRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, HttpServletResponse response, SmsConfigQueryVo smsConfigQueryVo) {
        RestResponse<PageDto<SmsConfigDto>> restResponse = smsConfigRemoteService.findPage(getAccessToken(), smsConfigQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryVo", smsConfigQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/sms_config/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("types", SmsPlatType.values());
        return "/sys_common/sms_config/add";
    }


    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, HttpServletResponse response, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SmsConfigDto> restResponse = smsConfigRemoteService.querySmsConfigById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("types", SmsPlatType.values());
        request.setAttribute("dto", restResponse.getData());
        return "/sys_common/sms_config/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(HttpServletRequest request, SmsConfigDto smsConfigDto) {
        Assert.notNull(smsConfigDto, "短信配置信息不能为空");
        //Assert.notNull(smsConfigDto.getRegionId(), "短信配置RegionId不能为空");
        Assert.notNull(smsConfigDto.getSmsPlatAccount(), "短信配置PlatAccount不能为空");
        Assert.notNull(smsConfigDto.getSmsPlatPassword(), "短信配置PlatPassword不能为空");
        Assert.notNull(smsConfigDto.getSmsPlatType(), "短信配置SmsPlatType不能为空");
        //Assert.notNull(smsConfigDto.getSmsPlatUrl(), "短信配置SmsPlatUrl不能为空");
        Assert.notNull(smsConfigDto.getConfigName(), "短信配置名称不能为空");
        //Assert.notNull(smsConfigDto.getSys(),"短信配置信息不能为空");
        RestResponse<SmsConfigDto> restResponse = smsConfigRemoteService.createSmsConfig(getAccessToken(), smsConfigDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(HttpServletRequest request, SmsConfigDto smsConfigDto) {
        Assert.notNull(smsConfigDto, "短信配置信息不能为空");
        Assert.notNull(smsConfigDto.getId(), "短信配置id不能为空");
        //Assert.notNull(smsConfigDto.getRegionId(), "短信配置RegionId不能为空");
        Assert.notNull(smsConfigDto.getSmsPlatAccount(), "短信配置PlatAccount不能为空");
        Assert.notNull(smsConfigDto.getSmsPlatPassword(), "短信配置PlatPassword不能为空");
        Assert.notNull(smsConfigDto.getSmsPlatType(), "短信配置SmsPlatType不能为空");
        //Assert.notNull(smsConfigDto.getSmsPlatUrl(), "短信配置SmsPlatUrl不能为空");
        Assert.notNull(smsConfigDto.getConfigName(), "短信配置名称不能为空");
        //Assert.notNull(smsConfigDto.getSys(),"短信配置信息不能为空");
        RestResponse<SmsConfigDto> restResponse = smsConfigRemoteService.updateSmsConfig(getAccessToken(), smsConfigDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /*@RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response,
                         Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<Boolean> restResponse = smsConfigRemoteService.deleteSmsConfig(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }*/


    /**
     * 编辑当前用户配置
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/editCurrentCfg", method = RequestMethod.GET)
    public String editCurrentCfg(HttpServletRequest request, HttpServletResponse response) {
        RestResponse<SmsConfigDto> restResponse = smsConfigRemoteService.getCurrentUserSmsConfig(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("types", SmsPlatType.values());
        request.setAttribute("dto", restResponse.getData() == null ? new SmsConfigDto() : restResponse.getData());
        return "/sys_common/sms_config/edit_current_cfg";
    }

    @RequestMapping(value = "/saveCurrentSmsCfg", method = RequestMethod.POST)
    public String saveCurrentSmsCfg(HttpServletRequest request, SmsConfigDto smsConfigDto) {
        RestResponse<SmsConfigDto> restResponse = smsConfigRemoteService.updateCurrentSmsConfig(getAccessToken(), smsConfigDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:editCurrentCfg";
    }
}
