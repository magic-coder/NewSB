package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.interceptor.MessageNotifyInterceptor;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysMessageRemoteService;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.AccountValidatorUtil;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.enumerate.SmsTemplateType;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysMessageDTO;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import com.qmx.coreservice.api.user.enumerate.MsgReciveTypeEnum;
import com.qmx.coreservice.api.user.query.SysMessageVO;
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
 * @Description 消息管理
 * @Date Created on 2018/3/26 18:15.
 * @Modified By
 */
@Controller
@RequestMapping("/sysMessage")
public class SysMessageController extends BaseController {

    @Autowired
    private SysMessageRemoteService sysMessageRemoteService;


    /**
     * 发送消息列表
     * @param request
     * @param sysMessageVO
     * @return
     */
    @RequestMapping("/list")
    public String list(HttpServletRequest request, SysMessageVO sysMessageVO) {
        RestResponse<PageDto<SysMessageDTO>> restResponse = sysMessageRemoteService.findPage(getAccessToken(),sysMessageVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysMessageVO);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/sys_message/list";
    }

    /**
     * 我的消息列表
     * @param request
     * @param sysMessageVO
     * @return
     */
    @RequestMapping("/myList")
    public String myList(HttpServletRequest request, SysMessageVO sysMessageVO) {
        RestResponse<PageDto<SysMessageDTO>> restResponse = sysMessageRemoteService.findMessagePage(getAccessToken(),sysMessageVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysMessageVO);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/sys_message/my_list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request) {
        request.setAttribute("reciveTypes", MsgReciveTypeEnum.values());
        return "/sys_common/sys_message/add";
    }


    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public RestResponse<Boolean> save(SysMessageDTO sysMessageDTO) {
        Assert.notNull(sysMessageDTO, "发送消息内容不能为空");
        Assert.notNull(sysMessageDTO.getContent(), "发送内容不能为空");
        Assert.notNull(sysMessageDTO.getTitle(), "消息标题不能为空");
        Assert.notNull(sysMessageDTO.getReciveUserType(), "用户接收类型不能为空");
        RestResponse<Boolean> restResponse = sysMessageRemoteService.sendMessage(getAccessToken(),sysMessageDTO);
        return restResponse;
    }

    /**
     * 标记消息已读
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/readMessage", method = RequestMethod.POST)
    public RestResponse<Boolean> readMessage(Long id) {
        if(id != null){
            sysMessageRemoteService.readMessage(getAccessToken(),id);
        }
        return RestResponse.ok(Boolean.TRUE);
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = sysMessageRemoteService.delete(getAccessToken(),id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
