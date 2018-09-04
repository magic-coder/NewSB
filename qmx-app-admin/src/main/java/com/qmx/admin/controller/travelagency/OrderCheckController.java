package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.travelagency.AgreementRemoteService;
import com.qmx.admin.remoteapi.travelagency.OrderRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.*;
import com.qmx.travelagency.api.enumerate.TaOrderStatus;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * 团单审核
 * Created by earnest on 2018/3/8 0008.
 */
@Controller("/taOrderCheck")
@RequestMapping("/taOrderCheck")
public class OrderCheckController extends BaseController {
    @Autowired
    private OrderRemoteService orderRemoteService;
    @Autowired
    private AgreementRemoteService agreementRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;

    @RequestMapping(value = "/list")
    public String list(OrderDto dto, ModelMap model) {
        Subject subject = SecurityUtils.getSubject();
        if (subject.isPermitted("admin:taViewOtherOrder")) {
            dto.setViewOtherOrder(Boolean.TRUE);
        }
        //设置默认显示为已接单列表
        dto.setOrderStatus(TaOrderStatus.haveOrder);
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/ordercheck/list";
    }

    /**
     * 落单
     *
     * @param id 订单id
     * @return
     */
    @ResponseBody
    @RequestMapping("/single")
    public JSONObject single(Long id) {
        JSONObject object = new JSONObject();
        try {
            RestResponse<OrderDto> restResponse = orderRemoteService.orderSingle(id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            object.put("flag", "落单成功");
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            object.put("flag", e.getMessage());
            return object;
        }
    }

    /**
     * 审核
     *
     * @param id 订单id
     * @return
     */
    @ResponseBody
    @RequestMapping("/check")
    public JSONObject check(Long id) {
        JSONObject object = new JSONObject();
        try {
            RestResponse<OrderDto> restResponse = orderRemoteService.orderCheck(id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            object.put("flag", "审核成功");
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            object.put("flag", e.getMessage());
            return object;
        }
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());

        AgreementDto agreementDto = agreementRemoteService.findById(restResponse.getData().getAgreementId()).getData();
        if (agreementDto == null) {
            throw new BusinessException("未和景区签署协议");
        }
        TravelAgencyDto travelAgencyDto = travelAgencyRemoteService.findByMenberId(agreementDto.getTravelagencyId()).getData();
        model.addAttribute("travelAgencyDto", travelAgencyDto);
        model.addAttribute("agreementDto", agreementDto);
        model.addAttribute("infos", agreementDto.getInfos());
        return "/travelagency/ordercheck/edit";
    }

    @RequestMapping(value = "/update")
    public String update(OrderDto dto, HttpServletRequest request) {

        //订单主产品信息
        String[] productIds = request.getParameterValues("productId");
        String[] prices = request.getParameterValues("price");
        String[] quantitys = request.getParameterValues("quantity");
        //订单增值产品信息
        String[] increaseProductIds = request.getParameterValues("increaseProductId");
        String[] inPrices = request.getParameterValues("inPrice");
        String[] inQuantitys = request.getParameterValues("inQuantity");
        List<OrderInfoDto> infoDtos = new ArrayList<>();
        List<OrderIncreaseInfoDto> increaseInfoDtos = new ArrayList<>();
        if (productIds != null && productIds.length > 0) {
            for (int i = 0; i < productIds.length; i++) {
                OrderInfoDto infoDto = new OrderInfoDto();
                infoDto.setProductId(Long.parseLong(productIds[i]));
                infoDto.setPrice(new BigDecimal(prices[i]));
                infoDto.setQuantity(Integer.parseInt(quantitys[i]));
                infoDtos.add(infoDto);
            }
        }
        dto.setInfoDtos(infoDtos);
        if (increaseProductIds != null && increaseProductIds.length > 0) {
            for (int i = 0; i < increaseProductIds.length; i++) {
                OrderIncreaseInfoDto increaseInfoDto = new OrderIncreaseInfoDto();
                increaseInfoDto.setProductId(Long.parseLong(increaseProductIds[i]));
                increaseInfoDto.setPrice(new BigDecimal(inPrices[i]));
                increaseInfoDto.setQuantity(Long.parseLong(inQuantitys[i]));
                increaseInfoDtos.add(increaseInfoDto);
            }
        }
        dto.setIncreaseInfoDtos(increaseInfoDtos);
        //订单导游、领队信息
        List<OrderGuideDto> guideDtos = new ArrayList();
        String[] guideIds = request.getParameterValues("guideId");
        if (guideIds != null) {
            for (int i = 0; i < guideIds.length; i++) {
                OrderGuideDto guideDto = new OrderGuideDto();
                guideDto.setGuideId(Long.parseLong(guideIds[i]));
                guideDtos.add(guideDto);
            }
        }
        dto.setGuideDtos(guideDtos);
        //订单车辆信息
        List<OrderCarDto> carDtos = new ArrayList();
        String[] carIds = request.getParameterValues("carId");
        if (carIds != null) {
            for (int i = 0; i < carIds.length; i++) {
                OrderCarDto carDto = new OrderCarDto();
                carDto.setCarId(Long.parseLong(carIds[i]));
                carDtos.add(carDto);
            }
        }
        dto.setCarDtos(carDtos);
        //订单司机信息
        List<OrderDriverDto> driverDtos = new ArrayList();
        String[] driverIds = request.getParameterValues("driverId");
        if (driverIds != null) {
            for (int i = 0; i < driverIds.length; i++) {
                OrderDriverDto driverDto = new OrderDriverDto();
                driverDto.setDriverId(Long.parseLong(driverIds[i]));
                driverDtos.add(driverDto);
            }
        }
        dto.setDriverDtos(driverDtos);
        RestResponse<OrderDto> restResponse = orderRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:/taOrder/list.jhtml";
    }
}
