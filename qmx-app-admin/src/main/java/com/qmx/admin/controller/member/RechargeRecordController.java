package com.qmx.admin.controller.member;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.member.ExchangeOrderRemoteService;
import com.qmx.admin.remoteapi.member.MemberRemoteService;
import com.qmx.admin.remoteapi.member.RechargeRecordRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.member.api.dto.*;
import com.qmx.member.api.facade.IExchangeOrderServiceFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/rechargerecord")
public class RechargeRecordController extends BaseController {
    @Autowired
    private RechargeRecordRemoteService rechargeRecordRemoteService;
    @Autowired
    private MemberRemoteService memberRemoteService;
    @Autowired
    private ExchangeOrderRemoteService exchangeOrderService ;

    @RequestMapping(value = "/list")
    public String list(MemberDto dto, ModelMap model) {
        RestResponse<PageDto<MemberDto>> restResponse = memberRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/member/rechargerecord/list";
    }

    /**
     * 获得用户金额记录
     * @param dto
     * @return
     */
    @RequestMapping(value = "/memberMoneyList")
    public String memberMoneyList(MemberMoneyDto dto,Model model) {
        RestResponse<PageDto<MemberMoneyDto>> restResponse = rechargeRecordRemoteService.memberMoneyList(dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto",dto);
        model.addAttribute("page",restResponse.getData());
        return "/member/rechargerecord/memberMoneyList";
    }

    /**
     * 获得用户积分记录
     * @param dto
     * @return
     */
    @RequestMapping(value = "/memberIntegeralList")
    public String memberIntegeralList(MemberIntegeralDto dto,Model model) {
        RestResponse<PageDto<MemberIntegeralDto>> restResponse = rechargeRecordRemoteService.memberIntegeralList(dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto",dto);
        model.addAttribute("page",restResponse.getData());
        return "/member/rechargerecord/memberIntegeralList";
    }
    /**
     * 获得用户兑换记录
     * @param dto
     * @return
     */
    @RequestMapping(value = "/exchangeOrderList")
    public String exchangeOrderList(ExchangeOrderDto dto,Model model) {
        RestResponse<PageDto<ExchangeOrderDto>> restResponse = exchangeOrderService.findList(dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto",dto);
        model.addAttribute("page",restResponse.getData());
        return "/member/rechargerecord/exchangeOrderList";
    }

    /**
     * 更新订单发货状态
     * @param dto
     * @return
     */
    @RequestMapping(value = "/exchangeOrderState")
    public String exchangeOrderState(ExchangeOrderDto dto) {
        RestResponse restResponse = exchangeOrderService.updateStateType(dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:exchangeOrderList?memberId="+dto.getMemberId();
    }
}