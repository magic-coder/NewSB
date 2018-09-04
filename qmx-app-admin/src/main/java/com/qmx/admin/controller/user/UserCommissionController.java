package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.admin.remoteapi.core.UserCommissionRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.enumerate.SmsTemplateType;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import com.qmx.coreservice.api.user.dto.SysUserCommissionDTO;
import com.qmx.coreservice.api.user.enumerate.CommissionStatusEnum;
import com.qmx.coreservice.api.user.enumerate.CommissionWithdrawStatusEnum;
import com.qmx.coreservice.api.user.query.SysUserCommissionVO;
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
 * @Description 佣金记录
 * @Date Created on 2018/3/24 16:53.
 * @Modified By
 */
@Controller
@RequestMapping("/userCommission")
public class UserCommissionController extends BaseController {

    @Autowired
    private UserCommissionRemoteService userCommissionRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, SysUserCommissionVO userCommissionVO) {
        RestResponse<PageDto<SysUserCommissionDTO>> restResponse = userCommissionRemoteService.findPage(getAccessToken(), userCommissionVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", userCommissionVO);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/user_commission/list";
    }

    @RequestMapping("/findUnWithDrawComissionList")
    public String findUnWithDrawComissionList(HttpServletRequest request, SysUserCommissionVO userCommissionVO){
        userCommissionVO.setCommissionStatus(CommissionStatusEnum.COMMISSIONED);
        userCommissionVO.setWithdrawStatus(CommissionWithdrawStatusEnum.UN_WITHDRAW);
        RestResponse<PageDto<SysUserCommissionDTO>> restResponse = userCommissionRemoteService.findPage(getAccessToken(), userCommissionVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", userCommissionVO);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/user_commission/withdraw_commission_list";
    }

}
