package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.core.UserChargeInfoRemoteService;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.message.sms.enumerate.SmsSettleType;
import com.qmx.coreservice.api.user.dto.SysChargeTypeLogDTO;
import com.qmx.coreservice.api.user.dto.SysUserChargeInfoDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.AccountChargeTypeEnum;
import com.qmx.coreservice.api.user.query.SysChargeTypeLogVO;
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
import java.math.BigDecimal;
import java.util.Date;

/**
 * @Author liubin
 * @Description 用户费用管理
 * @Date Created on 2018/3/22 14:39.
 * @Modified By
 */
@Controller
@RequestMapping("/userCharge")
public class UserChargeInfoController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(UserChargeInfoController.class);
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private UserChargeInfoRemoteService userChargeInfoRemoteService;

    /**
     * 用户日志列表
     *
     * @param request
     * @param chargeTypeLogVO
     * @return
     */
    @RequestMapping(value = "/findChargeTypePage", method = RequestMethod.GET)
    public String findChargeTypePage(HttpServletRequest request, SysChargeTypeLogVO chargeTypeLogVO) {
        Assert.notNull(chargeTypeLogVO, "查询日志信息不能为空");
        Assert.notNull(chargeTypeLogVO.getMemberId(), "memberId不能为空");
        //Date date = new Date();
        String date = DateUtil.getDate();
        if (chargeTypeLogVO.getStartDate() == null) {
            chargeTypeLogVO.setStartDate(DateUtil.parseDateTime(date + " 00:00:00"));
        }
        if (chargeTypeLogVO.getEndDate() == null) {
            chargeTypeLogVO.setEndDate(DateUtil.parseDateTime(date + " 23:59:59"));
        } else {
            //要转换日期，默认是当天凌晨
            date = DateUtil.format(chargeTypeLogVO.getEndDate(), "yyyy-MM-dd");
            chargeTypeLogVO.setEndDate(DateUtil.parseDateTime(date + " 23:59:59"));
        }
        RestResponse<PageDto<SysChargeTypeLogDTO>> restResponse = userChargeInfoRemoteService.findUserChargeTypePage(getAccessToken(), chargeTypeLogVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", chargeTypeLogVO);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/user_charge_info/charge_type_log_list";
    }

    /**
     * 修改计费类型页面
     *
     * @param userId
     * @return
     */
    @RequestMapping(value = "/preUpdateChargeType", method = RequestMethod.GET)
    public String preUpdateChargeType(HttpServletRequest request, Long userId) {
        Assert.notNull(userId, "userId不能为空");
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.findById(userId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("accountChargeType", AccountChargeTypeEnum.values());
        request.setAttribute("dto", restResponse.getData());
        return "/sys_common/user_charge_info/pre_account_charge_type";
    }

    /**
     * 执行修改计费类型
     *
     * @param userId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/doUpdateChargeType", method = RequestMethod.POST)
    public RestResponse doUpdateChargeType(
            HttpServletRequest request, Long userId,
            AccountChargeTypeEnum accountChargeType, BigDecimal amount, String endDate, String remark) {
        if (userId == null) {
            return RestResponse.fail("userId不能为空");
        }
        if (accountChargeType == null) {
            return RestResponse.fail("计费类型不能为空");
        }
        if (amount == null) {
            return RestResponse.fail("金额不能为空");
        }
        Date endTime = null;
        if (accountChargeType == AccountChargeTypeEnum.DATE_RANGE) {
            if (!StringUtils.hasText(endDate)) {
                return RestResponse.fail("截止日期不能为空");
            }
            endTime = DateUtil.parse(endDate);
        }
        String ip = RequestUtils.getIpAddr(request);
        SysUserChargeInfoDTO userChargeInfoDTO = new SysUserChargeInfoDTO();
        userChargeInfoDTO.setUserId(userId);
        userChargeInfoDTO.setAccountChargesType(accountChargeType);
        userChargeInfoDTO.setAccountChargeAmount(amount);
        userChargeInfoDTO.setAccountCanUseEnd(endTime);
        userChargeInfoDTO.setClientIp(ip);
        userChargeInfoDTO.setRemark(remark);
        RestResponse<Boolean> restResponse = userChargeInfoRemoteService.updateUserChargeType(getAccessToken(), userChargeInfoDTO);
        return restResponse;
    }

    /**
     * 修改短信计费类型页面
     *
     * @param userId
     * @return
     */
    @RequestMapping(value = "/preUpdateSmsCharge", method = RequestMethod.GET)
    public String preUpdateSmsCharge(HttpServletRequest request, Long userId) {
        Assert.notNull(userId, "userId不能为空");
        //userChargeInfoRemoteService.findUserChargeInfo(getAccessToken(),userId);
        RestResponse<SysUserChargeInfoDTO> restResponse = userChargeInfoRemoteService.findUserChargeInfo(getAccessToken(), userId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserChargeInfoDTO dto = restResponse.getData();
        request.setAttribute("userSmsSettleType", SmsSettleType.values());
        request.setAttribute("dto", dto);
        request.setAttribute("userInfo", dto.getSysUser());
        return "/sys_common/user_charge_info/pre_update_sms_charge_type";
    }

    /**
     * 执行修改短信计费类型
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/doUpdateSmsChargeType", method = RequestMethod.POST)
    public RestResponse doUpdateSmsChargeType(HttpServletRequest request, SysUserChargeInfoDTO userChargeInfoDTO) {
        String ip = RequestUtils.getIpAddr(request);
        userChargeInfoDTO.setClientIp(ip);
        RestResponse<Boolean> restResponse = userChargeInfoRemoteService.updateSmsChargeInfo(getAccessToken(),userChargeInfoDTO);
        return restResponse;
    }


}
