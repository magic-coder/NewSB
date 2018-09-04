package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsBillRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SysSmsBillDTO;
import com.qmx.coreservice.api.message.sms.query.SysSmsBillVO;
import com.qmx.coreservice.api.user.enumerate.TradingTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author liubin
 * @Description 短信账单
 * @Date Created on 2018/3/22 14:07.
 * @Modified By
 */
@Controller
@RequestMapping("/smsBill")
public class SmsBillController extends BaseController {

    @Autowired
    private SmsBillRemoteService smsBillRemoteService;

    /**
     * 账单列表
     * @param request
     * @param sysSmsBillVO
     * @return
     */
    @RequestMapping("/list")
    public String list(HttpServletRequest request, SysSmsBillVO sysSmsBillVO) {
        RestResponse<PageDto<SysSmsBillDTO>> restResponse = smsBillRemoteService.findPage(getAccessToken(), sysSmsBillVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<TradingTypeEnum> list = new ArrayList<>();
        list.add(TradingTypeEnum.SMS_NOTIFY_CHARGE);
        list.add(TradingTypeEnum.SMS_PROMOTION_CHARGE);
        list.add(TradingTypeEnum.ORDER_SMS_CHARGE);
        request.setAttribute("billTypes", list);
        request.setAttribute("queryDto", sysSmsBillVO);
        request.setAttribute("page", restResponse.getData());
        return "/sys_common/sms_bill/list";
    }

    /**
     * 账单结算
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/settleSmsBill")
    public String settleSmsBill(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = smsBillRemoteService.settleSmsBill(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
