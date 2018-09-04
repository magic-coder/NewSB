package com.qmx.member.controller;

import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.api.support.UserTokenInfo;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.service.UserTokenService;
import com.qmx.base.core.utils.DataUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.remoteapi.SysUserRemoteService;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;

/**
 * @Author liubin
 * @Description
 * @Date Created on 2017/10/12 11:27.
 * @Modified By
 */
public class BaseController {

    @Autowired
    private UserTokenService userTokenService;
    @Autowired
    protected SysUserRemoteService sysUserRemoteService;

    protected Long getCurrentId(HttpServletRequest request) {
        String access_token = request.getParameter("access_token");
        if (DataUtil.isEmpty(access_token)) {
            return null;
        }
        return getCurrentId(access_token);
    }

    /**
     * 获取当前用户id
     *
     * @param access_token
     * @return
     */
    protected Long getCurrentId(String access_token) {
        UserTokenInfo userTokenInfo = userTokenService.parseAccessToken(access_token);
        if (userTokenInfo != null) {
            return userTokenInfo.getUid();
        }
        return null;
    }

    /**
     * 获取当前用户信息
     *
     * @param access_token
     * @return
     */
    protected SysUserDto getCurrentUser(String access_token) {
        if (access_token != null) {
            RestResponse<SysUserDto> restResponse = sysUserRemoteService.getCurrentTokenUser(access_token);
            if (restResponse.success()) {
                return restResponse.getData();
            }
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return null;
    }

    /**
     * 获取用户所属人(针对员工和普通管理员)
     * 返回的用户只能是:供应商，分销商，管理员(如果是普通管理员就返回超级管理员信息)
     *
     * @param userId
     * @return
     */
    protected SysUserDto getCurrentMember(Long userId) {
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.findById(userId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto sysUser = restResponse.getData();
        //如果是员工
        if (SysUserType.employee == sysUser.getUserType()) {
            RestResponse<SysUserDto> restResponse2 = sysUserRemoteService.findById(sysUser.getMemberId());
            if (!restResponse2.success()) {
                throw new BusinessException(restResponse2.getErrorMsg());
            }
            sysUser = restResponse.getData();
        } else if (SysUserType.member == sysUser.getUserType()) {
            //sysUser = userService.find(sysUser.getMemberId());
        }
        return sysUser;
    }

    protected SysUserDto getCurrentSupplier(Long userId) {
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.findById(userId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto sysUser = restResponse.getData();
        //如果是员工
        if (SysUserType.admin == sysUser.getUserType()) {
            return sysUser;
        } else {
            RestResponse<SysUserDto> restResponse2 = sysUserRemoteService.findById(sysUser.getSupplierId());
            if (!restResponse2.success()) {
                throw new BusinessException(restResponse2.getErrorMsg());
            }
            sysUser = restResponse.getData();
        }
        return sysUser;
    }

    /**
     * 获取用户所属人ID(针对员工和普通管理员)
     * 返回的用户只能是:供应商，分销商，管理员(如果是普通管理员就返回超级管理员信息)
     *
     * @param userId
     * @return
     */
    protected Long getCurrentMemberId(String access_token, Long userId) {
        SysUserDto sysUser = getCurrentMember(userId);
        return sysUser.getId();
    }
}
