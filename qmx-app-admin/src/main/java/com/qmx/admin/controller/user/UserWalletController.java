package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.core.SysUserWalletRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.dto.SysWalletRecordDTO;
import com.qmx.coreservice.api.user.enumerate.AccountChargeTypeEnum;
import com.qmx.coreservice.api.user.enumerate.PayMethodEnum;
import com.qmx.coreservice.api.user.enumerate.RechargeSourceEnum;
import com.qmx.coreservice.api.user.enumerate.TradingTypeEnum;
import com.qmx.coreservice.api.user.query.SysWalletRecordVO;
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
 * @Description 用户钱包管理
 * @Date Created on 2018/1/20 16:05.
 * @Modified By
 */
@Controller
@RequestMapping("/userWallet")
public class UserWalletController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(UserWalletController.class);
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysUserWalletRemoteService sysUserWalletRemoteService;

    /**
     * 用户钱包消费记录
     *
     * @param request
     * @param sysWalletRecordVO
     * @return
     */
    @RequestMapping(value = "/depositList", method = RequestMethod.GET)
    public String depositList(HttpServletRequest request,
                              SysWalletRecordVO sysWalletRecordVO) {
        //sysWalletRecordVO.setTradingScene(TradingSceneEnum.WALLET_ACCOUNT);
        //sysFundsFlowVO.setTradingType(TradingTypeEnum.DEPOSIT_RECHARGE);
        if (sysWalletRecordVO.getStartDate() != null) {
            String date = DateUtil.format(sysWalletRecordVO.getStartDate(), "yyyy-MM-dd");
            sysWalletRecordVO.setStartDate(DateUtil.parseDateTime(date + " 00:00:00"));
        }
        if (sysWalletRecordVO.getEndDate() != null) {
            //要转换日期，默认是当天凌晨
            String date = DateUtil.format(sysWalletRecordVO.getEndDate(), "yyyy-MM-dd");
            sysWalletRecordVO.setEndDate(DateUtil.parseDateTime(date + " 23:59:59"));
        }

        RestResponse<PageDto<SysWalletRecordDTO>> restResponse = sysUserWalletRemoteService.findWalletRecordPage(getAccessToken(), sysWalletRecordVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("tradingTypes", TradingTypeEnum.values());
        //request.setAttribute("payPlats", PayPlatEnum.values());
        request.setAttribute("rechargeSources", RechargeSourceEnum.values());
        request.setAttribute("payMethods", PayMethodEnum.values());
        request.setAttribute("queryVo", sysWalletRecordVO);
        request.setAttribute("page", restResponse.getData());
        return "/user/user_wallet/deposit_list";
    }

    /**
     * 用户钱包信息
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/walletInfo", method = RequestMethod.GET)
    public String walletInfo(HttpServletRequest request) {
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.getCurrentUserDetail(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/user/user_wallet/user_wallet_info";
    }

    /**
     * 钱包用户列表
     *
     * @param request
     * @param userQueryVo
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request,
                       UserQueryVo userQueryVo) {
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserWalletRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("chargeRules", AccountChargeTypeEnum.values());
        request.setAttribute("userQueryVo", userQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/user/user_wallet/list";
    }

    /**
     * 用户钱包充值页面
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
        request.setAttribute("rechargeSources", RechargeSourceEnum.values());
        request.setAttribute("dto", restResponse.getData());
        return "/user/user_wallet/pre_recharge";
    }

    /**
     * 执行用户钱包充值
     *
     * @param userId
     * @param amount
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/doRecharge", method = RequestMethod.POST)
    public RestResponse doRecharge(Long userId, BigDecimal amount, RechargeSourceEnum rechargeSource, String remark) {
        if (userId == null) {
            return RestResponse.fail("userId不能为空");
        }
        if (amount == null) {
            return RestResponse.fail("充值金额不能为空");
        }
        if (rechargeSource == null) {
            return RestResponse.fail("充值来源不能为空");
        }
        RestResponse<Boolean> restResponse = sysUserWalletRemoteService.updateUserWallet(getAccessToken(), userId, amount, rechargeSource, remark);
        return restResponse;
    }
}
