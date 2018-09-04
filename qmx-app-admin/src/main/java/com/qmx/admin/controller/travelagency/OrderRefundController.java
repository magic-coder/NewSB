package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysPayRefundRemoteService;
import com.qmx.admin.remoteapi.travelagency.OrderRefundRemoteService;
import com.qmx.admin.remoteapi.travelagency.OrderRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.OrderRefundDto;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by earnest on 2018/4/10 0010.
 */
@Controller("/taOrderRefund")
@RequestMapping("/taOrderRefund")
public class OrderRefundController extends BaseController {
    @Autowired
    private OrderRefundRemoteService orderRefundRemoteService;
    @Autowired
    private SysPayRefundRemoteService sysPayRefundRemoteService;
    @Autowired
    private OrderRemoteService orderRemoteService;

    @RequestMapping(value = "/list")
    public String list(OrderRefundDto dto, ModelMap model) {
        Subject subject = SecurityUtils.getSubject();
        if (subject.isPermitted("admin:taViewOtherOrder")) {
            dto.setViewOtherOrder(Boolean.TRUE);
        }

        RestResponse<PageDto<OrderRefundDto>> restResponse = orderRefundRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }

        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/orderrefund/list";
    }

    /**
     * 退款申请审核(客户经理使用)
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/refundCheck")
    public JSONObject refundCheck(Long id, String type) {
        JSONObject object = new JSONObject();
        RestResponse restResponse = orderRefundRemoteService.checkRefund(getAccessToken(), id, type);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "操作失败" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "操作成功");
        }
        return object;
    }

    /**
     * 最终退款审核(景区更高权限审核)
     *
     * @param id
     * @param type
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/resultCheck")
    public JSONObject resultCheck(Long id, String type) {
        JSONObject object = new JSONObject();
        RestResponse<OrderRefundDto> restResponse = orderRefundRemoteService.checkResult(getAccessToken(), id, type);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "操作失败" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "操作成功");
        }
        /*OrderRefundDto refundDto = restResponse.getData();
        OrderDto dto = orderRemoteService.findById(refundDto.getOrderId()).getData();
        //计算退款金额
        BigDecimal amount = dto.getAmountPaid().subtract(refundDto.getTotalNumber()).setScale(2, BigDecimal.ROUND_HALF_UP);
        //执行退款操作
        object = doPayRefund(refundDto.getOrderId(), amount);*/
        return object;
    }

    /**
     * 退款
     *
     * @param orderId
     * @param amount
     * @return
     */

    // @RequestMapping(value = "/doPayRefund", method = RequestMethod.POST)
   /* public JSONObject doPayRefund(Long orderId, BigDecimal amount) {
        JSONObject object = new JSONObject();
        Assert.notNull(orderId, "订单号不能为空");
        Assert.notNull(amount, "退款金额不能为空");
        String refundSn = System.currentTimeMillis() + "";
        SysRefundRequestDTO refundDTO = new SysRefundRequestDTO();
        //refundDTO.setRefundDesc(desc);
        refundDTO.setMchOrderId(orderId + "");
        refundDTO.setMchRefundSn(refundSn);
        refundDTO.setRefundFee(amount);
        RestResponse<SysPayRefundDTO> restResponse = sysPayRefundRemoteService.refundOrder(getAccessToken(), refundDTO);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "退款失败" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "退款成功");
        }
        return object;
    }*/

}
