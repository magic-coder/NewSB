package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsConfigRemoteService;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.coreservice.api.message.sms.dto.SmsConfigDto;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.enumerate.SmsTemplateType;
import com.qmx.coreservice.api.message.sms.query.SmsConfigQueryVo;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * @Author liubin
 * @Description 短信模板管理
 * @Date Created on 2017/11/30 14:57.
 * @Modified By
 */
@Controller
@RequestMapping("/smsTemplate")
public class SmsTemplateController extends BaseController {

    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;
    @Autowired
    private SmsConfigRemoteService smsConfigRemoteService;
    @Autowired
    private SysModuleRemoteService sysModuleRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, SmsTemplateQueryVo smsTemplateQueryVo) {
        //Long currentId = getCurrentModuleId(request);
        //Assert.notNull(currentId, "获取模块信息失败，请刷新重试");
        //smsTemplateQueryVo.setModuleId(currentId);
        RestResponse<PageDto<SmsTemplateDto>> restResponse = smsTemplateRemoteService.findPage(getAccessToken(), smsTemplateQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", smsTemplateQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/sms_template/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("types", SmsTemplateType.values());
        List<SysModuleDto> sysModuleDtos = getUserModuleList(request);
        //获取当前模块
        //Long currentId = getCurrentModuleId(request);
        SmsConfigQueryVo smsConfigQueryVo = new SmsConfigQueryVo();
        smsConfigQueryVo.setPageSize(20);//暂定20
        RestResponse<PageDto<SmsConfigDto>> restResponse = smsConfigRemoteService.findPage(getAccessToken(),smsConfigQueryVo);
        if(!restResponse.success()){
            throw new ValidationException(restResponse.getErrorMsg());
        }
        PageDto<SmsConfigDto> smsConfigDtoPageDto = restResponse.getData();
        List<SmsConfigDto> configDtoList = smsConfigDtoPageDto.getRecords();
        request.setAttribute("configDtoList", configDtoList);
        request.setAttribute("moduleList", sysModuleDtos);
        //request.setAttribute("moduleId", currentId);
        return "/sys_common/sms_template/add";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, HttpServletResponse response, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SmsTemplateDto> restResponse = smsTemplateRemoteService.queryTemplateById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<SysModuleDto> sysModuleDtos = getUserModuleList(request);
        request.setAttribute("types", SmsTemplateType.values());
        //获取当前模块
        //Long currentId = getCurrentModuleId(request);
        //request.setAttribute("moduleId", currentId);
        request.setAttribute("moduleList", sysModuleDtos);
        request.setAttribute("dto", restResponse.getData());
        return "/sys_common/sms_template/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(HttpServletRequest request, SmsTemplateDto smsTemplateDto) {
        Assert.notNull(smsTemplateDto, "模板信息不能为空");
        Assert.notNull(smsTemplateDto.getContent(), "模板内容不能为空");
        Assert.notNull(smsTemplateDto.getName(), "模板名称不能为空");
        Assert.notNull(smsTemplateDto.getSignName(), "模板签名不能为空");
        Assert.notNull(smsTemplateDto.getTemplateCode(), "模板code不能为空");
        Assert.notNull(smsTemplateDto.getTemplateType(), "模板类型不能为空");
        Assert.notNull(smsTemplateDto.getModuleId(), "所属模块id不能为空");
        Assert.notNull(smsTemplateDto.getSmsConfigId(),"短信配置id不能为空");
        RestResponse<SmsTemplateDto> restResponse = smsTemplateRemoteService.createTemplate(getAccessToken(), smsTemplateDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(HttpServletRequest request, SmsTemplateDto smsTemplateDto) {
        Assert.notNull(smsTemplateDto, "模板信息不能为空");
        Assert.notNull(smsTemplateDto.getId(), "模板id不能为空");
        Assert.hasText(smsTemplateDto.getContent(), "模板内容不能为空");
        Assert.hasText(smsTemplateDto.getName(), "模板名称不能为空");
        Assert.hasText(smsTemplateDto.getSignName(), "模板签名不能为空");
        Assert.hasText(smsTemplateDto.getTemplateCode(), "模板code不能为空");
        Assert.notNull(smsTemplateDto.getTemplateType(), "模板类型不能为空");
        Assert.notNull(smsTemplateDto.getModuleId(), "所属模块id不能为空");
        RestResponse<SmsTemplateDto> restResponse = smsTemplateRemoteService.updateTemplate(getAccessToken(), smsTemplateDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = smsTemplateRemoteService.deleteTemplate(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
