package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.*;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.coreservice.api.pay.constant.PayConstant;
import com.qmx.coreservice.api.pay.dto.SysPayChannelDto;
import com.qmx.coreservice.api.pay.dto.SysPayOrderDto;
import com.qmx.coreservice.api.pay.dto.request.SysPayRequestDTO;
import com.qmx.coreservice.api.pay.enumerate.PayOrderStatusEnum;
import com.qmx.coreservice.api.pay.enumerate.PayPlatEnum;
import com.qmx.coreservice.api.user.dto.SysBalanceRecordDTO;
import com.qmx.coreservice.api.user.dto.SysChargeTypeLogDTO;
import com.qmx.coreservice.api.user.dto.SysUserChargeInfoDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.*;
import com.qmx.coreservice.api.user.query.SysBalanceRecordVO;
import com.qmx.coreservice.api.user.query.SysChargeTypeLogVO;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.util.*;

/**
 * @Author liubin
 * @Description 系统钱包管理
 * @Date Created on 2018/1/13 10:51.
 * @Modified By
 */
@Controller
@RequestMapping("/sysBalance")
public class SysBalanceController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(SysBalanceController.class);
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysPayChannelRemoteService sysPayChannelRemoteService;
    @Autowired
    private SysPayOrderRemoteService sysPayOrderRemoteService;
    @Autowired
    private QueryPayOrderRemoteService queryPayOrderRemoteService;
    @Autowired
    private SysUserBalanceRemoteService sysUserBalanceRemoteService;


    /**
     * 系统钱包消费/充值记录
     *
     * @param request
     * @param sysBalanceRecordVO
     * @return
     */
    @RequestMapping(value = "/depositList", method = RequestMethod.GET)
    public String list(HttpServletRequest request,
                       SysBalanceRecordVO sysBalanceRecordVO) {
        //sysBalanceRecordVO.setTradingScene(TradingSceneEnum.SYS_ACCOUNT);
        if (sysBalanceRecordVO.getStartDate() != null) {
            String date = DateUtil.format(sysBalanceRecordVO.getStartDate(), "yyyy-MM-dd");
            sysBalanceRecordVO.setStartDate(DateUtil.parseDateTime(date + " 00:00:00"));
        }
        if (sysBalanceRecordVO.getEndDate() != null) {
            //要转换日期，默认是当天凌晨
            String date = DateUtil.format(sysBalanceRecordVO.getEndDate(), "yyyy-MM-dd");
            sysBalanceRecordVO.setEndDate(DateUtil.parseDateTime(date + " 23:59:59"));
        }

        RestResponse<PageDto<SysBalanceRecordDTO>> restResponse = sysUserBalanceRemoteService.findBalanceRecordPage(getAccessToken(), sysBalanceRecordVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("tradingTypes", TradingTypeEnum.values());
        request.setAttribute("payPlats", PayPlatEnum.values());
        request.setAttribute("rechargeSources", RechargeSourceEnum.values());
        request.setAttribute("payMethods", PayMethodEnum.values());
        request.setAttribute("queryVo", sysBalanceRecordVO);
        request.setAttribute("page", restResponse.getData());
        return "/user/sys_balance/sys_balance_deposit_list";
    }

    /**
     * 查询充值结果（充值成功返回true）
     *
     * @param orderId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/queryRechargeStatus", method = RequestMethod.POST)
    public Boolean queryRechargeStatus(Long orderId) {
        if (orderId == null) {
            return Boolean.FALSE;
        }
        RestResponse<SysPayOrderDto> restResponse = queryPayOrderRemoteService.queryUpdatePayOrderStatus(null, orderId, null);
        logger.info("查询充值结果：" + JSONUtil.toJson(restResponse));
        if (restResponse.success()) {
            SysPayOrderDto orderDto = restResponse.getData();
            if (orderDto.getPayStatus() == PayOrderStatusEnum.SUCCESS ||
                    orderDto.getPayStatus() == PayOrderStatusEnum.FINISH) {
                return Boolean.TRUE;
            }
        }
        return Boolean.FALSE;
    }

    /**
     * 系统充值
     *
     * @param request
     * @param amount
     * @param payChannelNo
     * @return
     */
    @RequestMapping(value = "/onLineRechargePay", method = RequestMethod.GET)
    public String onLineRechargePay(HttpServletRequest request, BigDecimal amount, String payChannelNo) {
        Assert.notNull(amount, "充值金额不能为空");
        Assert.notNull(payChannelNo, "支付方式不能为空");
        String logPrefix = "【系统账户充值】";
        SysUserDto sysUserDto = getCurrentMember();

        SysPayRequestDTO payDTO = new SysPayRequestDTO();
        payDTO.setAmount(amount);
        payDTO.setProductId(payChannelNo + sysUserDto.getId());
        payDTO.setBody(sysUserDto.getAccount() + "系统充值" + amount);
        payDTO.setMchId(1L);
        payDTO.setUserId(sysUserDto.getId());//充值人id
        payDTO.setMchOrderId(UUID.randomUUID().toString());
        payDTO.setChannelNo(payChannelNo);
        //payDTO.setNotifyUrl("http://gds.qmx028.com/notify/alipay");
        payDTO.setSubject(sysUserDto.getAccount() + "系统充值" + amount);
        payDTO.setTradingType(TradingTypeEnum.SYS_RECHARGE);
        payDTO.setTradingScene("系统充值");
        logger.info("{}请求参数：{}", logPrefix, JSONUtil.toJson(payDTO));
        RestResponse<SysPayOrderDto> restResponse = sysPayOrderRemoteService.payOrder(payDTO);
        logger.info("{}返回参数：{}", logPrefix, JSONUtil.toJson(restResponse));
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysPayOrderDto sysPayOrderDto = restResponse.getData();
        Map<String, Object> result = sysPayOrderDto.getPayResult();
        if (result != null) {
            String codeUrl = (String) result.get("codeUrl");
            if (codeUrl != null) {
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                QRCodeUtil.encode(codeUrl, 220, 220, out);
                byte[] tempbyte = out.toByteArray();
                String base64Url = Base64Util.encodeToString(tempbyte);
                request.setAttribute("codeUrl", "data:image/png;base64," + base64Url);
            }
        }
        request.setAttribute("userInfo", sysUserDto);
        request.setAttribute("payOrder", sysPayOrderDto);
        return "/user/sys_balance/online_recharge_pay";
    }

    /**
     * 系统钱包在线充值
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/onLineRecharge", method = RequestMethod.GET)
    public String onLineRecharge(HttpServletRequest request) {
        SysUserDto sysUserDto = getCurrentMember();
        //系统支付配置
        RestResponse<List<SysPayChannelDto>> restResponse = sysPayChannelRemoteService.findMchPayChannel(getAccessToken(), 1L);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<SysPayChannelDto> payChannelDtoList = restResponse.getData();
        List<SysPayChannelDto> newList = new ArrayList<>();
        for (SysPayChannelDto dto : payChannelDtoList) {
            if (!dto.getEnable()) {
                continue;
            }
            //支付宝扫码支付、和微信扫码支付
            if (PayConstant.PAY_CHANNEL_ALIPAY_QR.equals(dto.getChannelNo()) ||
                    PayConstant.PAY_CHANNEL_WX_NATIVE.equals(dto.getChannelNo())) {
                newList.add(dto);
            }
        }
        request.setAttribute("payChannelList", newList);
        request.setAttribute("dto", sysUserDto);
        return "/user/sys_balance/online_recharge";
    }

    /**
     * 系统钱包信息
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/sysBalanceInfo", method = RequestMethod.GET)
    public String sysBalanceInfo(HttpServletRequest request) {
        //SysUserDto sysUserDto  = getCurrentMember();
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.getCurrentUserDetail(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/user/sys_balance/sys_balance_info";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request,
                       UserQueryVo userQueryVo) {
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserBalanceRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("chargeRules", AccountChargeTypeEnum.values());
        request.setAttribute("userQueryVo", userQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/user/sys_balance/list";
    }

    /**
     * 系统余额充值页面
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
        return "/user/sys_balance/pre_recharge";
    }

    /**
     * 执行系统余额充值
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
        RestResponse<Boolean> restResponse = sysUserBalanceRemoteService.updateUserSysBalance(getAccessToken(), userId, amount, rechargeSource, remark);
        return restResponse;
    }
}
