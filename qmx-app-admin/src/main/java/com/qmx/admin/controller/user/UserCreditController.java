package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserCreditRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.user.dto.SysCreditRecordDTO;
import com.qmx.coreservice.api.user.dto.SysDepositRecordDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.*;
import com.qmx.coreservice.api.user.query.SysCreditRecordVO;
import com.qmx.coreservice.api.user.query.SysDepositRecordVO;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

/**
 * @Author liubin
 * @Description 用户授信管理
 * @Date Created on 2018/3/28 15:25.
 * @Modified By
 */
@Controller
@RequestMapping("/userCredit")
public class UserCreditController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(UserCreditController.class);
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysUserCreditRemoteService sysUserCreditRemoteService;

    /**
     * 预存款充值记录
     *
     * @param request
     * @param sysCreditRecordVO
     * @return
     */
    @RequestMapping(value = "/rechargeList", method = RequestMethod.GET)
    public String rechargeList(HttpServletRequest request,
                               SysCreditRecordVO sysCreditRecordVO) {
        //sysFundsFlowVO.setTradingType(TradingTypeEnum.DEPOSIT_RECHARGE);
        if (sysCreditRecordVO.getStartDate() != null) {
            String date = DateUtil.format(sysCreditRecordVO.getStartDate(), "yyyy-MM-dd");
            sysCreditRecordVO.setStartDate(DateUtil.parseDateTime(date + " 00:00:00"));
        }
        if (sysCreditRecordVO.getEndDate() != null) {
            //要转换日期，默认是当天凌晨
            String date = DateUtil.format(sysCreditRecordVO.getEndDate(), "yyyy-MM-dd");
            sysCreditRecordVO.setEndDate(DateUtil.parseDateTime(date + " 23:59:59"));
        }

        sysCreditRecordVO.setTradingType(TradingTypeEnum.CREDIT_RECHARGE);
        RestResponse<PageDto<SysCreditRecordDTO>> restResponse = sysUserCreditRemoteService.findCreditRecordPage(getAccessToken(), sysCreditRecordVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //request.setAttribute("tradingTypes",TradingTypeEnum.values());
        //request.setAttribute("payPlats", PayPlatEnum.values());
        request.setAttribute("rechargeSources", RechargeSourceEnum.values());
        request.setAttribute("payMethods", PayMethodEnum.values());
        request.setAttribute("queryVo", sysCreditRecordVO);
        request.setAttribute("page", restResponse.getData());
        return "/user/user_credit/recharge_list";
    }

    /**
     * 预存款消费记录
     *
     * @param request
     * @param sysCreditRecordVO
     * @return
     */
    @RequestMapping(value = "/depositList", method = RequestMethod.GET)
    public String depositList(HttpServletRequest request,
                              SysCreditRecordVO sysCreditRecordVO) {
        //sysDepositRecordVO.setTradingScene(TradingSceneEnum.DEPOSIT_ACCOUNT);
        //sysFundsFlowVO.setTradingType(TradingTypeEnum.DEPOSIT_RECHARGE);
        if (sysCreditRecordVO.getStartDate() != null) {
            String date = DateUtil.format(sysCreditRecordVO.getStartDate(), "yyyy-MM-dd");
            sysCreditRecordVO.setStartDate(DateUtil.parseDateTime(date + " 00:00:00"));
        }
        if (sysCreditRecordVO.getEndDate() != null) {
            //要转换日期，默认是当天凌晨
            String date = DateUtil.format(sysCreditRecordVO.getEndDate(), "yyyy-MM-dd");
            sysCreditRecordVO.setEndDate(DateUtil.parseDateTime(date + " 23:59:59"));
        }

        RestResponse<PageDto<SysCreditRecordDTO>> restResponse = sysUserCreditRemoteService.findCreditRecordPage(getAccessToken(), sysCreditRecordVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //request.setAttribute("tradingScenes",TradingSceneEnum.values());
        /*request.setAttribute("tradingTypes", TradingTypeEnum.values());*/
        //request.setAttribute("payPlats", PayPlatEnum.values());
        /*request.setAttribute("rechargeSources", RechargeSourceEnum.values());*/
        /*request.setAttribute("payMethods", PayMethodEnum.values());*/
        request.setAttribute("queryVo", sysCreditRecordVO);
        request.setAttribute("page", restResponse.getData());
        return "/user/user_credit/credit_list";
    }

    /**
     * 预存款信息
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/userCreditInfo", method = RequestMethod.GET)
    public String userDepositInfo(HttpServletRequest request) {
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.getCurrentUserDetail(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/user/user_credit/user_credit_info";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request,
                       UserQueryVo userQueryVo) {
        if (userQueryVo.getUserType() == null) {
            userQueryVo.setUserType(SysUserType.distributor);
        }
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserCreditRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        /*request.setAttribute("chargeRules", AccountChargeTypeEnum.values());*/
        request.setAttribute("userQueryVo", userQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/user/user_credit/list";
    }

    /**
     * 预存款充值页面
     *
     * @param userId
     * @return
     */
    @RequestMapping(value = "/preRecharge", method = RequestMethod.GET)
    public String preRecharge(HttpServletRequest request, Long userId) {
        Assert.notNull(userId, "userId不能为空");
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.findById(userId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        /*request.setAttribute("rechargeSources", RechargeSourceEnum.values());*/
        request.setAttribute("dto", restResponse.getData());
        return "/user/user_credit/pre_recharge";
    }

    /**
     * 执行预存款充值
     *
     * @param userId
     * @param amount
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/doRecharge", method = RequestMethod.POST)
    public RestResponse doRecharge(Long userId, BigDecimal amount, String remark) {
        if (userId == null) {
            return RestResponse.fail("userId不能为空");
        }
        if (amount == null) {
            return RestResponse.fail("充值金额不能为空");
        }
        /*if (rechargeSource == null) {
            return RestResponse.fail("充值来源不能为空");
        }*/
        RestResponse<Boolean> restResponse = sysUserCreditRemoteService.updateUserCredit(getAccessToken(), userId, amount, remark);
        return restResponse;
    }
}
