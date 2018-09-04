package com.qmx.admin.controller.user;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.*;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.base.core.jcaptcha.JCaptchaUtil;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.message.sms.dto.SendSmsDto;
import com.qmx.coreservice.api.pay.dto.SysPayChannelDto;
import com.qmx.coreservice.api.pay.enumerate.PayPlatEnum;
import com.qmx.coreservice.api.user.dto.SysDictDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.dto.SysUserWalletDTO;
import com.qmx.coreservice.api.user.dto.SysUserWithdrawDTO;
import com.qmx.coreservice.api.user.enumerate.WithdrawStatusEnum;
import com.qmx.coreservice.api.user.enumerate.WithdrawTargetEnum;
import com.qmx.coreservice.api.user.query.SysUserWithdrawVO;
import com.qmx.wxbasics.api.dto.WxAuthorizationDto;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.*;
import java.util.*;

/**
 * @Author liubin
 * @Description 用户提现
 * @Date Created on 2018/1/23 9:49.
 * @Modified By
 */
@Controller
@RequestMapping("/userWithdraw")
public class UserWithdrawController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(UserWithdrawController.class);

    @Autowired
    private UserWithdrawRemoteService userWithdrawRemoteService;
    //@Autowired
    //private UserWithdrawInfoRemoteService userWithdrawInfoRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysUserWalletRemoteService sysUserWalletRemoteService;
    @Autowired
    private SysPayChannelRemoteService sysPayChannelRemoteService;
    @Autowired
    private SysDictRemoteService sysDictRemoteService;
    @Autowired
    private SmsRemoteService smsRemoteService;

    private static final String withdrawParamsName = "withdrawParamsName";
    private static final String verifyCodeName = UserWithdrawController.class.getName()+"verifyCodeName";

    /**
     * 提交提现
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/submitWithdraw")
    public RestResponse submitWithdraw(HttpServletRequest request) {
        SysUserWithdrawDTO userWithdraw = (SysUserWithdrawDTO) request.getSession().getAttribute(withdrawParamsName);
        Assert.notNull(userWithdraw, "提现异常，请从新申请提交。");
        RestResponse<SysUserWithdrawDTO> restResponse = userWithdrawRemoteService.applyWithdraw(getAccessToken(), userWithdraw);
        request.getSession().removeAttribute(withdrawParamsName);//提交成功后删除
        return restResponse;
    }

    /**
     * 提现预览
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/preWithdraw")
    public String preWithdraw(HttpServletRequest request) {
        SysUserWithdrawDTO userWithdraw = (SysUserWithdrawDTO) request.getSession().getAttribute(withdrawParamsName);
        Assert.notNull(userWithdraw, "提现异常，请从新申请提交。");
        request.setAttribute("userWithdraw", userWithdraw);
        request.setAttribute("userInfo", getCurrentUser());
        return "/user/user_withdraw/pre_withdraw";
    }

    /**
     * 保存提现预览
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/savePreWithdraw")
    public RestResponse<Boolean> savePreWithdraw(HttpServletRequest request, SysUserWithdrawDTO userWithdraw) {
        SysUserWithdrawDTO sysUserWithdraw = (SysUserWithdrawDTO) request.getSession().getAttribute(withdrawParamsName);
        Assert.notNull(userWithdraw, "提现异常，请从新申请提交。");
        Assert.notNull(sysUserWithdraw, "提现异常，请从新申请提交。");
        InstanceUtil.copyPropertiesIgnoreNull(userWithdraw, sysUserWithdraw);
        request.getSession().setAttribute(withdrawParamsName, sysUserWithdraw);
        return RestResponse.ok(Boolean.TRUE);
    }

    /**
     * 申请提现第二步，填写提现信息
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/applyWithdrawStep2")
    public String applyWithdrawStep2(SysUserWithdrawDTO userWithdraw,
                                     HttpServletRequest request) {
        Assert.notNull(userWithdraw, "提现信息不能为空");
        Assert.notNull(userWithdraw.getWithdrawTarget(), "提现方式不能为空");
        Assert.notNull(userWithdraw.getApplyAmount(), "申请金额不能为空");
        WithdrawTargetEnum withdrawTarget = userWithdraw.getWithdrawTarget();
        RestResponse<SysUserDto> userResponse = sysUserRemoteService.getCurrentUserDetail(getAccessToken());
        if (!userResponse.success()) {
            throw new BusinessException(userResponse.getErrorMsg());
        }
        SysUserDto sysUserDto = userResponse.getData();
        if (sysUserDto.getUserType() != SysUserType.distributor) {
            throw new ValidationException("只有分销商才有该功能");
        }
        if (sysUserDto != null) {
            SysUserWalletDTO userWallet = sysUserDto.getUserWallet();
            String withdrawType = userWallet.getWithdrawType();
            String[] withdrawTypes = null;
            if (withdrawType != null && withdrawType.length() > 0) {
                withdrawTypes = withdrawType.split(",");
            }
            if (withdrawTypes != null) {
                List<String> list = Arrays.asList(withdrawTypes);
                if (!list.contains(withdrawTarget.name())) {
                    throw new ValidationException("不支持该提现方式:" + withdrawTarget.getName());
                }
            }
        }

        //userWithdraw.setMemberId(sysUserDto.getId());
        request.setAttribute("bankInfo", getBankList(withdrawTarget));
        request.setAttribute("userInfo", sysUserDto);
        request.setAttribute("userWithdraw", userWithdraw);
        request.getSession().setAttribute(withdrawParamsName, userWithdraw);
        //model.addAllAttributes(RequestUtils.getQueryParams(request));
        return "/user/user_withdraw/apply_withdraw_step2";
    }


    /**
     * 修改提现方式页面
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(path = "/doUpdateWithdrawType")
    public RestResponse<Boolean> doUpdateWithdrawType(
            HttpServletRequest request, Long userId,
            @RequestParam(value = "withdrawTypes[]", required = false) String[] withdrawTypes,
            Boolean applyAll, BigDecimal withdrawStartAmount, Integer charge) {
        Assert.notNull(userId, "用户id不能为空");
        Assert.notNull(withdrawStartAmount, "最低提现金额不能为空");
        Assert.notNull(charge, "提现手续费不能为空");
        SysUserWalletDTO sysUserWalletDTO = new SysUserWalletDTO();
        sysUserWalletDTO.setUserId(userId);
        sysUserWalletDTO.setCharge(charge);
        sysUserWalletDTO.setWithdrawStartAmount(withdrawStartAmount);
        sysUserWalletDTO.setApplayAll(applyAll);
        String strs = "";
        Map<String, String[]> params = request.getParameterMap();
        if (withdrawTypes != null && withdrawTypes.length != 0) {
            strs = StringUtils.join(withdrawTypes, ",");
        }
        sysUserWalletDTO.setWithdrawType(strs);
        RestResponse<Boolean> userResponse = sysUserWalletRemoteService.updateUserWithdrawType(getAccessToken(), sysUserWalletDTO);
        return userResponse;
    }

    /**
     * 修改提现方式页面
     *
     * @param request
     * @return
     */
    @RequestMapping(path = "/updateWithdrawType")
    public String updateWithdrawType(HttpServletRequest request, Long userId) {
        Assert.notNull(userId, "用户id不能为空");
        //SysUserDto userDto = getCurrentMember();
        RestResponse<SysUserDto> userResponse = sysUserRemoteService.getUserDetailInfo(getAccessToken(), userId);
        if (!userResponse.success()) {
            throw new BusinessException(userResponse.getErrorMsg());
        }
        SysUserDto sysUserDto = userResponse.getData();
        if (sysUserDto.getUserType() != SysUserType.distributor && sysUserDto.getUserType() != SysUserType.distributor2) {
            throw new ValidationException("修改用户没有提现方式，只有分销商才有提现方式");
        }
        Long mchId = sysUserDto.getSupplierId();
        if (sysUserDto != null && sysUserDto.getUserWallet() != null) {
            SysUserWalletDTO userWallet = sysUserDto.getUserWallet();
            String withdrawType = userWallet.getWithdrawType();
            request.setAttribute("userWithdrawTypes", withdrawType);
        }

        //查询已配置支付信息
        RestResponse<List<SysPayChannelDto>> restResponse = sysPayChannelRemoteService.findMchPayChannel(getAccessToken(), mchId);
        List<SysPayChannelDto> payChannelDtoList = restResponse.getData();
        Set<WithdrawTargetEnum> withdrawTargets = new HashSet<>();
        withdrawTargets.add(WithdrawTargetEnum.CASH);
        //withdrawTargets.add(WithdrawTargetEnum.BANK_TRANSFER);
        for (SysPayChannelDto sysPayChannelDto : payChannelDtoList) {
            if (sysPayChannelDto.getPayPlat() == PayPlatEnum.ALIPAY) {
                //withdrawTargets.add(WithdrawTargetEnum.ALIPAY_BANK);
                withdrawTargets.add(WithdrawTargetEnum.ALIPAY_TRANSFER);
            } else if (sysPayChannelDto.getPayPlat() == PayPlatEnum.WXPAY) {
                //withdrawTargets.add(WithdrawTargetEnum.WXPAY_BANK);
                withdrawTargets.add(WithdrawTargetEnum.WXPAY_TRANSFER);
            }
        }
        request.setAttribute("allWithdrawTypes", withdrawTargets);
        request.setAttribute("userInfo", userResponse.getData());
        return "/user/user_withdraw/update_withdraw_type";
    }

    /**
     * 提现处理
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/withdraw")
    public String withdraw(HttpServletRequest request, SysUserWithdrawVO sysUserWithdrawVO) {
        sysUserWithdrawVO.setStatus(WithdrawStatusEnum.APPLY);
        RestResponse<PageDto<SysUserWithdrawDTO>> restResponse = userWithdrawRemoteService.findPage(getAccessToken(), sysUserWithdrawVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("withdrawTargets", WithdrawTargetEnum.values());
        request.setAttribute("queryDto", sysUserWithdrawVO);
        request.setAttribute("page", restResponse.getData());
        return "/user/user_withdraw/withdraw";
    }

    /**
     * 分页查询用户提现信息
     *
     * @param sysUserWithdrawVO
     * @return
     */
    @RequestMapping(value = "/list")
    public String findPage(HttpServletRequest request, SysUserWithdrawVO sysUserWithdrawVO) {
        //sysUserWithdrawVO.setStatus(WithdrawStatusEnum.);
        RestResponse<PageDto<SysUserWithdrawDTO>> restResponse = userWithdrawRemoteService.findPage(getAccessToken(), sysUserWithdrawVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("withdrawTargets", WithdrawTargetEnum.values());
        request.setAttribute("status", WithdrawStatusEnum.values());
        request.setAttribute("queryDto", sysUserWithdrawVO);
        request.setAttribute("page", restResponse.getData());
        return "/user/user_withdraw/list";
    }

    /**
     * 用户申请提现页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/applyWithdraw", method = RequestMethod.GET)
    public String applyWithdraw(HttpServletRequest request) {

        RestResponse<SysUserDto> userResponse = sysUserRemoteService.getCurrentUserDetail(getAccessToken());
        if (!userResponse.success()) {
            throw new BusinessException(userResponse.getErrorMsg());
        }
        SysUserDto sysUserDto = userResponse.getData();
        if (sysUserDto.getUserType() != SysUserType.distributor) {
            throw new ValidationException("只有分销商才有该功能");
        }

        request.setAttribute("userInfo", sysUserDto);
        if (sysUserDto != null) {
            SysUserWalletDTO userWallet = sysUserDto.getUserWallet();
            BigDecimal remainAmount = calcRemainAmount(userWallet);//可提现金额
            if (remainAmount.compareTo(userWallet.getWithdrawStartAmount()) < 0) {
                throw new ValidationException("最低提现金额为:" + userWallet.getWithdrawStartAmount() + ",可提现金额:" + remainAmount);
            }
            request.setAttribute("charge", calcUserCharge(userWallet));//初始手续费
            request.setAttribute("remainAmount", remainAmount);
            String withdrawType = userWallet.getWithdrawType();
            String[] withdrawTypes = null;
            if (withdrawType != null && withdrawType.length() > 0) {
                withdrawTypes = withdrawType.split(",");
            }
            if (withdrawTypes != null) {
                List<WithdrawTargetEnum> list = new ArrayList<>();
                try {
                    for (String str : withdrawTypes) {
                        list.add(WithdrawTargetEnum.valueOf(str));
                    }
                } catch (Exception e) {
                }
                request.setAttribute("userWithdrawTypes", list);
            }
        }
        return "/user/user_withdraw/apply_withdraw";
    }

    /**
     * 同意用户申请提现
     *
     * @param id
     * @param remark
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/doAgreeWithdraw", method = RequestMethod.POST)
    public RestResponse<Boolean> doAgreeWithdraw(HttpServletRequest request,Long id,String verifyCode, String remark) {
        if (id == null) {
            return RestResponse.fail("id不能为空");
        }
        RestResponse<SysUserWithdrawDTO> restResponse = userWithdrawRemoteService.findById(getAccessToken(), id);
        if (!restResponse.success()) {
            return RestResponse.fail(restResponse.getErrorMsg());
        }
        SysUserWithdrawDTO userWithdrawDTO = restResponse.getData();
        if(userWithdrawDTO.getWithdrawTarget() == WithdrawTargetEnum.CASH){
            if (!org.springframework.util.StringUtils.hasText(verifyCode)) {
                return RestResponse.fail("验证码不能为空");
            }
            String code = (String) request.getSession().getAttribute(verifyCodeName);
            if(!verifyCode.equals(code)){
                return RestResponse.fail("验证码错误或已过期");
            }
            request.getSession().removeAttribute(verifyCodeName);//删除验证码
        }
        RestResponse<Boolean> agreeResponse = userWithdrawRemoteService.agreeWithdraw(getAccessToken(), id, remark);
        if (!agreeResponse.success()) {
            throw new BusinessException(agreeResponse.getErrorMsg());
        }
        return agreeResponse;
    }

    /**
     * 发送短信验证码
     * @param request
     * @param captcha
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/sendWithdrawSmsVerifyCode")
    public RestResponse sendWithdrawSmsVerifyCode(HttpServletRequest request,String captcha,Long id){
        if (!org.springframework.util.StringUtils.hasText(captcha)) {
            return RestResponse.fail("验证码不能为空");
        }
        if (id == null) {
            return RestResponse.fail("id不能为空");
        }
        RestResponse<SysUserWithdrawDTO> restResponse = userWithdrawRemoteService.findById(getAccessToken(), id);
        if (!restResponse.success()) {
            return restResponse;
        }
        //不为空才验证
        //988625921598566402
        if (!JCaptchaUtil.validateResponse(request, captcha)) {
            return RestResponse.fail("验证码错误");
        }
        SysUserWithdrawDTO userWithdrawDTO = restResponse.getData();
        if(userWithdrawDTO.getWithdrawTarget() != WithdrawTargetEnum.CASH){
            return RestResponse.fail("只有现金提现才能发送短信");
        }
        String randomStr = RandomStringUtils.randomNumeric(6);
        request.getSession().setAttribute(verifyCodeName,randomStr);
        SendSmsDto sendSmsDto = new SendSmsDto();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code",randomStr);
        jsonObject.put("product","现金提现");
        sendSmsDto.setContent(jsonObject.toJSONString());
        sendSmsDto.setMemberId(userWithdrawDTO.getSupplierId());
        sendSmsDto.setName(userWithdrawDTO.getCashName());
        sendSmsDto.setPhone(userWithdrawDTO.getCashPhone());
        sendSmsDto.setTemplateId(988697251389943810L);
        sendSmsDto.setSupplierId(userWithdrawDTO.getSupplierId());
        return smsRemoteService.sendSms(getAccessToken(),sendSmsDto);

    }

    /**
     * 同意提现页面
     * @return
     */
    @RequestMapping(value = "/agreeWithdraw")
    public String agreeWithdraw(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysUserWithdrawDTO> restResponse = userWithdrawRemoteService.findById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("userWithdraw", restResponse.getData());
        return "/user/user_withdraw/agree_withdraw";
    }

    /**
     * 不同意用户申请提现
     *
     * @param id
     * @param remark
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/doDisagreeWithdraw", method = RequestMethod.POST)
    public RestResponse<Boolean> doDisagreeWithdraw(Long id, String remark) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = userWithdrawRemoteService.disagreeWithdraw(getAccessToken(), id, remark);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return restResponse;
    }

    /**
     * 不同意提现页面
     *
     * @return
     */
    @RequestMapping(value = "/disAgreeWithdraw")
    public String disAgreeWithdraw(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysUserWithdrawDTO> restResponse = userWithdrawRemoteService.findById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("userWithdraw", restResponse.getData());
        return "/user/user_withdraw/disagree_withdraw";
    }

    /**
     * 计算提现手续费
     *
     * @param userWallet
     * @return
     */
    private BigDecimal calcUserCharge(SysUserWalletDTO userWallet) {
        BigDecimal amount = userWallet.getWalletBalance();//全部提现
        String charge = "0";//字符串
        if (userWallet.getCharge() != null) {
            charge = userWallet.getCharge() + "";
        }
        BigDecimal bigDecimal = new BigDecimal("1000");
        BigDecimal bigDecimalCharge = amount.divide(bigDecimal).multiply(new BigDecimal(charge));
        if (bigDecimalCharge.compareTo(new BigDecimal("0.01")) < 0 && bigDecimalCharge.compareTo(new BigDecimal("0.00")) > 0) {
            bigDecimalCharge = new BigDecimal("0.01");
        }
        return bigDecimalCharge.setScale(2, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * 计算可提现金额
     *
     * @param userWallet
     * @return
     */
    private BigDecimal calcRemainAmount(SysUserWalletDTO userWallet) {
        String charge = "0";//字符串
        if (userWallet.getCharge() != null) {
            charge = userWallet.getCharge() + "";
        }
        BigDecimal amount = userWallet.getWalletBalance();
        BigDecimal bigDecimal = new BigDecimal("1000");
        BigDecimal chargeDecimal = amount.divide(bigDecimal).multiply(new BigDecimal(charge)).setScale(2, BigDecimal.ROUND_HALF_UP);
        BigDecimal remainAmount = amount.subtract(chargeDecimal);
        return remainAmount;
    }

    private List<Map<String, String>> getBankList(WithdrawTargetEnum withdrawTarget) {
        Assert.notNull(withdrawTarget, "withdrawTarget不能为空");
        List<Map<String, String>> result = new ArrayList<>();
        if (withdrawTarget == WithdrawTargetEnum.ALIPAY_BANK) {
            Map<String, String> params = new HashMap<>();
            params.put("code", "BOC");
            params.put("name", "中国银行");
            result.add(params);
        } else if (withdrawTarget == WithdrawTargetEnum.WXPAY_BANK) {
            Map<String, String> params = new HashMap<>();
            params.put("code", "BOC");
            params.put("name", "中国银行");
            result.add(params);
        } else if (withdrawTarget == WithdrawTargetEnum.BANK_TRANSFER) {
            RestResponse<List<SysDictDTO>> dictResponse = sysDictRemoteService.findListByType("bankType");
            if (!dictResponse.success()) {
                throw new BusinessException(dictResponse.getErrorMsg());
            }
            List<SysDictDTO> list = dictResponse.getData();
            if (list != null) {
                for (SysDictDTO dto : list) {
                    Map<String, String> params = new HashMap<>();
                    params.put("code", dto.getCode());
                    params.put("name", dto.getCodeText());
                    result.add(params);
                }
            }
        }
        return result;
    }

}
