package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.enumerate.SmsPlatType;
import com.qmx.coreservice.api.message.sms.enumerate.SmsTemplateType;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

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
@RequestMapping("/supplierSmsTemplate")
public class SupplierSmsTemplateController extends BaseController {

    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;
    @Autowired
    private SysUserRemoteService userRemoteService;

    /**
     * 供应商列表
     * @param request
     * @param userQueryVo
     * @return
     */
    @RequestMapping("/supplierList")
    public String supplierList(HttpServletRequest request, UserQueryVo userQueryVo) {
        userQueryVo.setUserType(SysUserType.supplier);
        RestResponse<PageDto<SysUserDto>> restResponse = userRemoteService.findPage(getAccessToken(),userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", userQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/supplier_sms_template/supplier_list";
    }

    /**
     * 获取系统短信模板分页
     * @param request
     * @param smsTemplateQueryVo
     * @return
     */
    @RequestMapping(value = "/templateList")
    public String templateList(HttpServletRequest request, SmsTemplateQueryVo smsTemplateQueryVo) {
        smsTemplateQueryVo.setSys(Boolean.TRUE);
        RestResponse<PageDto<SmsTemplateDto>> restResponse = smsTemplateRemoteService.findPage(getAccessToken(),smsTemplateQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("smsPlatTypes", SmsPlatType.values());
        request.setAttribute("queryDto", smsTemplateQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/supplier_sms_template/template_list";
    }


    @RequestMapping("/list")
    public String list(HttpServletRequest request, SmsTemplateQueryVo smsTemplateQueryVo) {
        RestResponse<PageDto<SmsTemplateDto>> restResponse = smsTemplateRemoteService.findSupplierAuthPage(getAccessToken(),smsTemplateQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", smsTemplateQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/supplier_sms_template/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request) {
        return "/sys_common/supplier_sms_template/add";
    }


    /**
     * 保存短信授权
     * @param memberId
     * @param templateIds
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public RestResponse<Boolean> save(Long memberId,Long[] templateIds) {
        Assert.notNull(templateIds, "模板Ids不能为空");
        Assert.notNull(memberId, "模板所属人不能为空");
        RestResponse<Boolean> restResponse = smsTemplateRemoteService.addTemplateAuthInfo(getAccessToken(), templateIds,memberId);
        return restResponse;
    }


    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = smsTemplateRemoteService.deleteTemplateAuthInfo(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
