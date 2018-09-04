package com.qmx.admin.controller.shop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.commodity.RefundRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.shop.api.dto.commodity.OrderDto;
import com.qmx.shop.api.dto.commodity.RefundDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Created by zcl on 2018/1/6.
 */
@Controller("/commodity/refund")
@RequestMapping("/commodity/refund")
public class RefundController extends BaseController {
    private static final Logger logger = LoggerFactory.getLogger(RefundController.class);
    @Autowired
    private RefundRemoteService refundRemoteService;

    /**
     * 退款列表
     *
     * @param refundDto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/list")
    public String findList(RefundDto refundDto, ModelMap modelMap) {
        RestResponse<PageDto<RefundDto>> restResponse = refundRemoteService.findList(getAccessToken(), refundDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("commodityRefundDto", refundDto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/shop/commodity/refund/list";
    }

    /**
     * 订单退款申请
     *
     * @param commodityOrderDto
     * @param model
     * @return
     */
    @RequestMapping(value = "/refundsOrder")
    public String refundsOrder(OrderDto commodityOrderDto, RedirectAttributes model) {
        RestResponse<OrderDto> restResponse = refundRemoteService.orderRefund(getAccessToken(), commodityOrderDto);
        if (!restResponse.success()) {
            model.addFlashAttribute("msg", restResponse.getErrorMsg());
        }else {
            model.addFlashAttribute("msg", "操作成功");
        }
        return "redirect:/commodity/order/list";
    }

    /**
     * 退款审核
     *
     * @param dto
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.GET)
    public JSONObject update(RefundDto dto) {
        Assert.notNull(dto.getId(), "退款信息id不能为空");
        JSONObject jsonObject=new JSONObject();
        //更新退款状态
        RestResponse<Boolean> response = refundRemoteService.refundCheck(getAccessToken(), dto);
        if (!response.success()) {
            logger.debug(response.getErrorMsg());
            jsonObject.put("msg","操作失败");
        } else {
            jsonObject.put("msg","操作成功");
        }
        return jsonObject;
    }

    /**
     * 删除
     *
     * @param ids
     */
    @ResponseBody
    @RequestMapping("/delete")
    public String deleteOrder(String ids) {
        Assert.notNull(ids, "订单id不能为空");
        RestResponse<Boolean> restResponse=refundRemoteService.delete(ids,getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "1";
    }
}
