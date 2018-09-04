package com.qmx.admin.controller.teamticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysPayRefundRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtOrderRefundRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtOrderRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.pay.dto.SysPayRefundDTO;
import com.qmx.coreservice.api.pay.dto.request.SysRefundRequestDTO;
import com.qmx.teamticket.api.dto.TtOrderDto;
import com.qmx.teamticket.api.dto.TtOrderRefundDto;
import com.qmx.teamticket.api.enumerate.RefundStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/ttorderrefund")
public class TtOrderRefundController extends BaseController {
    @Autowired
    private TtOrderRemoteService ttOrderRemoteService;
    @Autowired
    private TtOrderRefundRemoteService ttOrderRefundRemoteService;
    @Autowired
    private SysPayRefundRemoteService sysPayRefundRemoteService;

    @RequestMapping(value = "/list")
    public String list(TtOrderRefundDto dto, ModelMap model) {
        RestResponse<PageDto<TtOrderRefundDto>> restResponse = ttOrderRefundRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttrefund/list";
    }

    /**
     * 同意退款
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/agreeRefund")
    public JSONObject agreeRefund(Long id, ModelMap model) {
        JSONObject object = new JSONObject();
        try {
            TtOrderRefundDto refundDto = ttOrderRefundRemoteService.findById(id).getData();
            TtOrderDto orderDto = ttOrderRemoteService.findById(refundDto.getOrderId()).getData();
            SysRefundRequestDTO refundDTO = new SysRefundRequestDTO();
            refundDTO.setRefundDesc("");
            refundDTO.setPayOrderId(orderDto.getPayOrderId());
            refundDTO.setMchRefundSn(String.valueOf(refundDto.getId()));
            refundDTO.setRefundFee(refundDto.getAmount());
            RestResponse<SysPayRefundDTO> restResponse = sysPayRefundRemoteService.refundOrder(getAccessToken(), refundDTO);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }

            refundDto.setStatus(RefundStatus.agreeRefund);
            RestResponse<TtOrderRefundDto> refundResponse = ttOrderRefundRemoteService.updateDto(getAccessToken(), refundDto);
            if (!refundResponse.success()) {
                throw new BusinessException(refundResponse.getErrorMsg());
            }

            object.put("state", "success");
            object.put("msg", "操作成功");
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            object.put("state", "error");
            object.put("msg", "操作失败." + e.getMessage());
            return object;
        }
    }

    /**
     * 拒绝退款
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/refuseRefund")
    public JSONObject refuseRefund(Long id, ModelMap model) {
        JSONObject object = new JSONObject();
        try {
            TtOrderRefundDto refundDto = ttOrderRefundRemoteService.findById(id).getData();

            refundDto.setStatus(RefundStatus.refuseRefund);
            RestResponse<TtOrderRefundDto> refundResponse = ttOrderRefundRemoteService.updateDto(getAccessToken(), refundDto);
            if (!refundResponse.success()) {
                throw new BusinessException(refundResponse.getErrorMsg());
            }

            object.put("state", "success");
            object.put("msg", "操作成功");
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            object.put("state", "error");
            object.put("msg", "操作失败");
            return object;
        }
    }

}
