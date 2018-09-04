package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SysSmsLogDto;
import com.qmx.coreservice.api.message.sms.query.SmsLogQueryVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * @Author liubin
 * @Description 门票短信日志
 * @Date Created on 2017/12/27 16:44.
 * @Modified By
 */
@Controller
@RequestMapping("/smsLog")
public class SmsLogController extends BaseController {

    @Autowired
    private SmsRemoteService smsRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, SmsLogQueryVo smsLogQueryVo) {
        //Long currentId = getCurrentModuleId(request);
        //Assert.notNull(currentId, "获取模块信息失败，请刷新重试");
        //smsLogQueryVo.setModuleId(currentId);
        RestResponse<PageDto<SysSmsLogDto>> restResponse = smsRemoteService.findSmsLogPage(getAccessToken(), smsLogQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", smsLogQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/sms_log/list";
    }
}
