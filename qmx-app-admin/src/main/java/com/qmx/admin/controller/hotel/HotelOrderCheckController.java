package com.qmx.admin.controller.hotel;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.hotel.HotelOrderCheckRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.hotel.api.dto.HotelOrderCheckDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 酒店订单审核控制器
 * Created by zcl on 2017/10/31.
 */
@Controller
@RequestMapping("/hotel/hotelOrderCheck")
public class HotelOrderCheckController extends BaseController {
    @Autowired
    private HotelOrderCheckRemoteService hotelOrderCheckRemoteService;

    /**
     * 审核列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(HotelOrderCheckDto dto, Model model) {
        RestResponse<PageDto<HotelOrderCheckDto>> restResponse = hotelOrderCheckRemoteService.checkList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/hotel/hotelordercheck/list";
    }

    /**
     * 审核订单
     *
     * @param dto
     * @return 返回到审核列表
     */
    @RequestMapping(value = "/check")
    public String check(HotelOrderCheckDto dto, RedirectAttributes model) {
        Assert.notNull(dto.getOrderId(), "订单id不能为空");
        RestResponse<Boolean> restResponse = hotelOrderCheckRemoteService.checkOrder(getAccessToken(), dto);
        if (!restResponse.getData()) {
            throw new BusinessException("系统错误");
        }
        model.addFlashAttribute("msg", "操作成功");
        return "redirect:list";
    }
}
