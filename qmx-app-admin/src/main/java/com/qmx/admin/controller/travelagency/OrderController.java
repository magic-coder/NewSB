package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.*;
import com.qmx.admin.remoteapi.travelagency.*;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import com.qmx.coreservice.api.pay.constant.PayConstant;
import com.qmx.coreservice.api.pay.dto.SysPayChannelDto;
import com.qmx.coreservice.api.pay.dto.SysPayOrderDto;
import com.qmx.coreservice.api.pay.dto.request.SysPayRequestDTO;
import com.qmx.coreservice.api.pay.enumerate.PayOrderStatusEnum;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.dto.UserFundsDTO;
import com.qmx.coreservice.api.user.enumerate.PayMethodEnum;
import com.qmx.coreservice.api.user.enumerate.TradingTypeEnum;
import com.qmx.travelagency.api.dto.*;
import com.qmx.travelagency.api.enumerate.*;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller("/taOrder")
@RequestMapping("/taOrder")
public class OrderController extends BaseController {
    private static final Logger logger = LoggerFactory.getLogger(OrderController.class);

    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private OrderRemoteService orderRemoteService;
    @Autowired
    private AgreementRemoteService agreementRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;
    @Autowired
    private ProductRemoteService productRemoteService;
    @Autowired
    private CarRemoteService carRemoteService;
    @Autowired
    private DriverRemoteService driverRemoteService;
    @Autowired
    private GuideRemoteService guideRemoteService;
    @Autowired
    private SysPayOrderRemoteService sysPayOrderRemoteService;
    @Autowired
    private SysPayChannelRemoteService sysPayChannelRemoteService;
    @Autowired
    private QueryPayOrderRemoteService queryPayOrderRemoteService;
    @Autowired
    private IncreaseProductRemoteService increaseProductRemoteService;
    @Autowired
    private OrderPayRemoteService orderPayRemoteService;
    @Autowired
    private SysUserDepositRemoteService sysUserDepositRemoteService;


    @RequestMapping(value = "/list")
    public String list(OrderDto dto, ModelMap model) {
        Subject subject = SecurityUtils.getSubject();
        if (subject.isPermitted("admin:taViewOtherOrder")) {
            dto.setViewOtherOrder(Boolean.TRUE);
        }

        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }

        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("payStatus", TaPaymentStatus.values());
        model.addAttribute("notStatus", TaNoteSendStatus.values());
        model.addAttribute("orderStatus", TaOrderStatus.values());
        model.addAttribute("checkStatus", TaCheckStatus.values());
        model.addAttribute("refundStatus", RefundStatus.values());
        return "/travelagency/order/list";
    }

    @ResponseBody
    @RequestMapping(value = "/lists")
    public JSONObject lists(OrderDto dto) {
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONObject object = new JSONObject();
        object.put("data", restResponse.getData().getRecords());
        return object;
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model, HttpServletRequest request) {
        SysUserDto currentUser = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (currentUser != null) {
            if (currentUser.getUserType() == SysUserType.distributor) {
                AgreementDto agreementDto = agreementRemoteService.findByMenberId(currentUser.getId()).getData();
                if (agreementDto == null) {
                    throw new BusinessException("未和景区签署协议");
                }
                TravelAgencyDto travelAgencyDto = travelAgencyRemoteService.findByMenberId(currentUser.getId()).getData();
                model.addAttribute("travelAgencyDto", travelAgencyDto);
                model.addAttribute("agreementDto", agreementDto);
                model.addAttribute("infos", agreementDto.getInfos());
            } else {
                String travelAgencyId = request.getParameter("travelAgencyId");
                if (StringUtils.isEmpty(travelAgencyId)) {
                    return "/travelagency/order/choice";
                } else {
                    // AgreementDto agreementDto = agreementRemoteService.findByMenberId(Long.parseLong(distributorId)).getData();
                    TravelAgencyDto travelAgencyDto = travelAgencyRemoteService.findById(Long.parseLong(travelAgencyId)).getData();
                    AgreementDto agreementDto = agreementRemoteService.findByMenberId(travelAgencyDto.getUserId()).getData();
                    if (agreementDto == null) {
                        throw new BusinessException("未和景区签署协议");
                    }
                    model.addAttribute("travelAgencyDto", travelAgencyDto);
                    model.addAttribute("agreementDto", agreementDto);
                    model.addAttribute("infos", agreementDto.getInfos());
                    //model.addAttribute("travelAgencyId", travelAgencyId);
                }
            }
        }
        return "/travelagency/order/add";
    }

    /**
     * 获取分销商
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getDistributors", method = RequestMethod.POST)
    public Object getDistributors(Integer page, String q) {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        /*UserQueryVo userQueryVo = new UserQueryVo();
        userQueryVo.setUserType(SysUserType.distributor);
        userQueryVo.setPageIndex(page);
        userQueryVo.setUsername(q);*/
        //查询旅行社列表
        TravelAgencyDto travelAgencyDto = new TravelAgencyDto();
        RestResponse<PageDto<TravelAgencyDto>> restResponse = travelAgencyRemoteService.findList(getAccessToken(), travelAgencyDto);
        for (TravelAgencyDto dto : restResponse.getData().getRecords()) {
            //根据分销商id查询所属旅行社
            // TravelAgencyDto dto = travelAgencyRemoteService.findByMenberId(dto.getId()).getData();

            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", String.valueOf(dto.getId()));
            // map.put("account", sysUserDto.getAccount());
            map.put("tName", dto.getName());
            rows.add(map);

        }
        result.put("total", restResponse.getData().getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    /**
     * 获取该协议主产品
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/getProducts")
    public String getProducts(ProductDto dto, ModelMap model) {
        RestResponse<PageDto<ProductDto>> restResponse = productRemoteService.findPolicyList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto currentUser = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (currentUser.getUserType() == SysUserType.distributor) {
            model.addAttribute("userType", SysUserType.distributor.name());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/order/productlist";
    }

    /**
     * 获取该协议增值产品
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/getIncreaseProducts")
    public String getIncreaseProducts(IncreaseProductDto dto, ModelMap model) {
        RestResponse<PageDto<IncreaseProductDto>> restResponse = increaseProductRemoteService.findPolicyList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto currentUser = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (currentUser.getUserType() == SysUserType.distributor) {
            model.addAttribute("userType", SysUserType.distributor.name());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/order/increaseproductlist";
    }

    /**
     * 获取主产品协议价格
     *
     * @param productId
     * @param quantity
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getProductPolicyList")
    public JSONArray getProductPolicyList(Long productId, Long agreementId, Integer quantity) {
        SysUserDto currentUser = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        //根据产品id查询该产品剩余库存
        ProductDto dto = productRemoteService.findById(productId).getData();
        Long memberId = null;
        if (currentUser.getUserType() == SysUserType.distributor) {
            memberId = currentUser.getId();
        } else {
            memberId = agreementRemoteService.findById(agreementId).getData().getTravelagencyId();
        }
        RestResponse<List<ProductPolicyDto>> restResponse = agreementRemoteService.getProductPolicyList(memberId, productId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONArray array = new JSONArray();
        if (quantity != null && quantity > 0) {
            List<ProductPolicyDto> policyDtos = restResponse.getData();
            for (ProductPolicyDto policyDto : policyDtos) {
                if (policyDto.getMinNumber() <= quantity && policyDto.getMaxNumber() >= quantity) {
                    JSONObject object = new JSONObject();
                    object.put("minNumber", policyDto.getMinNumber());
                    object.put("maxNumber", policyDto.getMaxNumber());
                    object.put("price", policyDto.getPrice());
                    object.put("agreementId", agreementId);
                    object.put("surplusTotalStock", dto.getSurplusTotalStock());
                    array.add(object);
                }
            }
        } else {
            List<ProductPolicyDto> policyDtos = restResponse.getData();
            for (ProductPolicyDto policyDto : policyDtos) {
                JSONObject object = new JSONObject();
                object.put("minNumber", policyDto.getMinNumber());
                object.put("maxNumber", policyDto.getMaxNumber());
                object.put("price", policyDto.getPrice());
                object.put("agreementId", agreementId);
                object.put("surplusTotalStock", dto.getSurplusTotalStock());
                array.add(object);
            }
        }
        return array;
    }

    /**
     * 获取增值产品协议结算价
     *
     * @param increaseProductId
     * @param inQuantity
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getIncreaseProductPolicyList")
    public JSONArray getIncreaseProductPolicyList(Long increaseProductId, Long agreementId, Integer inQuantity) {
        SysUserDto currentUser = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        Long memberId = null;
        if (currentUser.getUserType() == SysUserType.distributor) {
            memberId = currentUser.getId();
        } else {
            memberId = agreementRemoteService.findById(agreementId).getData().getTravelagencyId();
        }
        RestResponse<List<IncreaseProductPolicyDto>> restResponse = agreementRemoteService.getIncreaseProductPolicyList(memberId, increaseProductId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONArray array = new JSONArray();
        if (inQuantity != null && inQuantity > 0) {
            List<IncreaseProductPolicyDto> policyDtos = restResponse.getData();
            for (IncreaseProductPolicyDto policyDto : policyDtos) {
                JSONObject object = new JSONObject();
                object.put("inPrice", policyDto.getPrice());
                object.put("agreementId", agreementId);
                array.add(object);
            }
        } else {
            List<IncreaseProductPolicyDto> policyDtos = restResponse.getData();
            for (IncreaseProductPolicyDto policyDto : policyDtos) {
                JSONObject object = new JSONObject();
                object.put("inPrice", policyDto.getPrice());
                object.put("agreementId", agreementId);
                array.add(object);
            }
        }
        return array;
    }

    @RequestMapping(value = "/getCar")
    public String getCar(CarDto dto, ModelMap model) {
        RestResponse<PageDto<CarDto>> restResponse = carRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/order/carlist";
    }

    @RequestMapping(value = "/getGuide")
    public String getGuide(GuideDto dto, ModelMap model) {
        RestResponse<PageDto<GuideDto>> restResponse = guideRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/order/guidelist";
    }

    @RequestMapping(value = "/getDriver")
    public String getDriver(DriverDto dto, ModelMap model) {
        RestResponse<PageDto<DriverDto>> restResponse = driverRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/order/driverlist";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        OrderDto dto = restResponse.getData();
        if (dto.getOrderStatus() == TaOrderStatus.haveOrder) {
            if (dto.getUpdateCount() <= 0) {
                throw new BusinessException("该订单已达修改次数上限,不能进行修改!");
            }
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
        /*model.addAttribute("type", getCurrentUser().getUserType());*/
        return "/travelagency/order/edit";
    }


    @RequestMapping(value = "/save")
    public String save(OrderDto dto, HttpServletRequest request) {
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

        RestResponse<OrderDto> restResponse = orderRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
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
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = orderRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    @RequestMapping(value = "/payment")
    public String payment(Long id, String type, ModelMap model) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        OrderDto orderDto = restResponse.getData();
        RestResponse<AgreementDto> response = agreementRemoteService.findById(orderDto.getAgreementId());
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        //系统支付配置
        RestResponse<List<SysPayChannelDto>> sysPayChannelDtos = sysPayChannelRemoteService.findMchPayChannel(getAccessToken(), orderDto.getSupplierId());
        if (!sysPayChannelDtos.success()) {
            throw new BusinessException(sysPayChannelDtos.getErrorMsg());
        }
        String payWay = response.getData().getPayWay();
        List<SysPayChannelDto> payChannelDtoList = sysPayChannelDtos.getData();
        List<SysPayChannelDto> newList = new ArrayList<>();
        for (SysPayChannelDto dto : payChannelDtoList) {
            if (!dto.getEnable()) {
                continue;
            }
            //支付宝扫码支付、和微信扫码支付
            /*if (payWay.contains(PayConstant.PAY_CHANNEL_ALIPAY_QR) || payWay.contains(PayConstant.PAY_CHANNEL_WX_NATIVE)) {
                if (PayConstant.PAY_CHANNEL_ALIPAY_QR.equals(dto.getChannelNo()) ||
                        PayConstant.PAY_CHANNEL_WX_NATIVE.equals(dto.getChannelNo())) {

                    newList.add(dto);
                }
            }*/
            if (PayConstant.PAY_CHANNEL_ALIPAY_QR.equals(dto.getChannelNo()) &&
                    payWay.contains(PayConstant.PAY_CHANNEL_ALIPAY_QR)) {
                newList.add(dto);
            }
            if (PayConstant.PAY_CHANNEL_WX_NATIVE.equals(dto.getChannelNo()) &&
                    payWay.contains(PayConstant.PAY_CHANNEL_WX_NATIVE)) {
                newList.add(dto);
            }

        }
        //预存款支付
        if (payWay.contains("DEPOSIT")) {
            SysPayChannelDto channelDto = new SysPayChannelDto();
            channelDto.setChannelNo("DEPOSIT");
            channelDto.setChannelName("预存款支付");
            newList.add(channelDto);
        }
        SysUserDto userDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        model.addAttribute("paytypes", newList);
        model.addAttribute("dto", orderDto);
        model.addAttribute("type", type);
        model.addAttribute("user", userDto.getUserType());
        return "/travelagency/order/payment";
    }

    /**
     * 线下支付
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/getOfflinePayType")
    public JSONArray getOfflinePayType(Long id) {
        JSONArray array = new JSONArray();
        // object.put("types", TaOfflinePayType.values());
        for (TaOfflinePayType taOfflinePayType : TaOfflinePayType.values()) {
            JSONObject object = new JSONObject();
            object.put("name", taOfflinePayType.name());
            object.put("title", taOfflinePayType.getTitle());
            array.add(object);
        }
        return array;
    }

    /**
     * 在线支付
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/getOnlinePayType")
    public JSONArray getOnlinePayType(Long id) {
        JSONArray array = new JSONArray();
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<AgreementDto> response = agreementRemoteService.findById(restResponse.getData().getAgreementId());
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        //系统支付配置
        RestResponse<List<SysPayChannelDto>> sysPayChannelDtos = sysPayChannelRemoteService.findMchPayChannel(getAccessToken(), 1L);
        if (!sysPayChannelDtos.success()) {
            throw new BusinessException(sysPayChannelDtos.getErrorMsg());
        }
        String payWay = response.getData().getPayWay();
        List<SysPayChannelDto> payChannelDtoList = sysPayChannelDtos.getData();
        //List<SysPayChannelDto> newList = new ArrayList<>();
        for (SysPayChannelDto dto : payChannelDtoList) {
            JSONObject object = new JSONObject();
            if (!dto.getEnable()) {
                continue;
            }
            if (PayConstant.PAY_CHANNEL_ALIPAY_QR.equals(dto.getChannelNo()) &&
                    payWay.contains(PayConstant.PAY_CHANNEL_ALIPAY_QR)) {
                object.put("name", "支付宝支付");
                object.put("type", PayConstant.PAY_CHANNEL_ALIPAY_QR);
                array.add(object);
            }
            if (PayConstant.PAY_CHANNEL_WX_NATIVE.equals(dto.getChannelNo()) &&
                    payWay.contains(PayConstant.PAY_CHANNEL_WX_NATIVE)) {
                object.put("name", "微信支付");
                object.put("type", PayConstant.PAY_CHANNEL_WX_NATIVE);
                array.add(object);
            }
        }
        if (payWay.contains("DEPOSIT")) {
            JSONObject object = new JSONObject();
            object.put("name", "预存款支付");
            object.put("type", "DEPOSIT");
            array.add(object);
        }
        return array;
    }

    @RequestMapping(value = "/payorder")
    public String payorder(Long id, String payChannelNo, String type, ModelMap model) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        OrderDto orderDto = restResponse.getData();

        SysPayRequestDTO payDTO = new SysPayRequestDTO();
        OrderPayDto orderPayDto = new OrderPayDto();
        if (type.equals("deposit")) {
            payDTO.setAmount(orderDto.getDeposit().subtract(orderDto.getAmountPaid()).setScale(2));
            //payDTO.setTradingScene("旅行社订单定金支付");
            orderPayDto.setType(PayType.depositpaid);
        }
        if (type.equals("finalPay")) {
            payDTO.setAmount(orderDto.getTotalAmount().subtract(orderDto.getAmountPaid()).setScale(2));
            // payDTO.setTradingScene("旅行社订单尾款支付");
            orderPayDto.setType(PayType.finalpaid);
        }
        //如果是预存款支付
        if (payChannelNo.equals("DEPOSIT")) {
            /*List<UserFundsDTO> list = new ArrayList<>();
            sysUserDepositRemoteService.batchUpdateUserDeposit(getAccessToken(), list);*/
            //查询该旅行社的预存款信息
            RestResponse<SysUserDto> response = sysUserRemoteService.getUserDetailInfo(getAccessToken(), orderDto.getDistributorId());
            if (!response.success()) {
                throw new BusinessException(response.getErrorMsg());
            }
            //支付金额
            //BigDecimal amount = orderDto.getDeposit().subtract(orderDto.getAmountPaid()).setScale(2);
            model.addAttribute("dto", response.getData());
            model.addAttribute("amount", payDTO.getAmount());
            model.addAttribute("type", type);
            model.addAttribute("order", orderDto);
            return "/travelagency/order/depositpay";
        }
        orderPayDto.setAmount(payDTO.getAmount());
        orderPayDto.setOrderId(orderDto.getId());
        orderPayDto.setSn(orderDto.getSn());
        orderPayDto.setState(Boolean.FALSE);
        orderPayDto.setChannelNo(payChannelNo);

        RestResponse<OrderPayDto> orderPayRest = orderPayRemoteService.createDto(getAccessToken(), orderPayDto);
        if (!orderPayRest.success()) {
            throw new BusinessException("创建支付流水单失败" + orderPayRest.getErrorMsg());
        }
        orderPayDto = orderPayRest.getData();

        payDTO.setProductId(payChannelNo + orderDto.getSn());
        payDTO.setBody("旅行社[" + orderDto.getSn() + "]支付");
        payDTO.setMchId(orderDto.getSupplierId());
        payDTO.setChannelNo(payChannelNo);
        payDTO.setSubject("旅行社[" + orderDto.getSn() + "]支付");
        payDTO.setTradingType(TradingTypeEnum.ORDER_PAYMENT);
        payDTO.setTradingScene(SaleChannelEnum.TA_ORDER_PAY.getTitle());
        payDTO.setMchOrderId(String.valueOf(orderPayDto.getId()));
        payDTO.setNotifyUrl("http://travel-agency/order/orderPayNotify");
        RestResponse<SysPayOrderDto> sysPayOrderDtoRestResponse = sysPayOrderRemoteService.payOrder(payDTO);
        if (!sysPayOrderDtoRestResponse.success()) {
            throw new BusinessException(sysPayOrderDtoRestResponse.getErrorMsg());
        }
        SysPayOrderDto sysPayOrderDto = sysPayOrderDtoRestResponse.getData();
        Map<String, Object> result = sysPayOrderDto.getPayResult();
        if (result != null) {
            String codeUrl = (String) result.get("codeUrl");
            if (codeUrl != null) {
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                QRCodeUtil.encode(codeUrl, 220, 220, out);
                byte[] tempbyte = out.toByteArray();
                String base64Url = Base64Util.encodeToString(tempbyte);
                model.addAttribute("codeUrl", "data:image/png;base64," + base64Url);
            }
        }
        model.addAttribute("payOrder", sysPayOrderDto);
        model.addAttribute("type", type);
        model.addAttribute("id", id);
        return "/travelagency/order/payorder";
    }

    /**
     * 预存款支付
     *
     * @param id
     * @param amount
     * @return
     */
    @ResponseBody
    @RequestMapping("/depositPay")
    public JSONObject depositPay(Long id, BigDecimal amount, String type) {
        JSONObject object = new JSONObject();
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        OrderDto orderDto = restResponse.getData();
        // SysPayRequestDTO payDTO = new SysPayRequestDTO();
        OrderPayDto orderPayDto = new OrderPayDto();
        // payDTO.setAmount(amount);
        if (type.equals("deposit")) {
            orderPayDto.setType(PayType.depositpaid);
        }
        if (type.equals("finalPay")) {
            orderPayDto.setType(PayType.finalpaid);
        }
        orderPayDto.setAmount(amount);
        orderPayDto.setOrderId(orderDto.getId());
        orderPayDto.setSn(orderDto.getSn());
        orderPayDto.setState(Boolean.FALSE);
        orderPayDto.setChannelNo("DEPOSIT");
        RestResponse<OrderPayDto> orderPayRest = orderPayRemoteService.createDto(getAccessToken(), orderPayDto);
        if (!orderPayRest.success()) {
            throw new BusinessException("创建支付流水单失败" + orderPayRest.getErrorMsg());
        }
        orderPayDto = orderPayRest.getData();
        List<UserFundsDTO> list = new ArrayList<>();
        UserFundsDTO fundsDTO = new UserFundsDTO();
        fundsDTO.setOrderId(orderDto.getId());
        fundsDTO.setUserId(orderDto.getDistributorId());
        fundsDTO.setAmount(amount.negate());
        fundsDTO.setBody("旅行社[" + orderDto.getSn() + "]支付");
        fundsDTO.setPayMethod(PayMethodEnum.DEPOSIT);
        fundsDTO.setTradingType(TradingTypeEnum.ORDER_PAYMENT);
        list.add(fundsDTO);
        //订单支付
        RestResponse<Boolean> response = sysUserDepositRemoteService.batchUpdateUserDeposit(getAccessToken(), list);
        if (!response.success()) {
            object.put("state", "error");
            object.put("msg", "支付失败" + response.getErrorMsg());
        } else {
            //修改订单支付状态
            RestResponse<Boolean> payResponse = orderRemoteService.depositPay(getAccessToken(), orderDto.getId(), orderPayDto);
            if (!payResponse.success()) {
                throw new BusinessException(payResponse.getErrorMsg());
            }
            object.put("state", "success");
            object.put("msg", "支付成功");
        }
        return object;
    }

    /**
     * 线下支付
     *
     * @param id
     * @param type
     * @param remark
     * @param payChannelNo
     * @return
     */
    @ResponseBody
    @RequestMapping("/offlinePayOrder")
    public JSONObject offlinePayOrder(Long id, String type, String remark, String payChannelNo) {
        if (StringUtils.isEmpty(remark)) {
            remark = "";
        }
        RestResponse<OrderDto> response = orderRemoteService.updatePayment(getAccessToken(), type, id, remark, payChannelNo);
        JSONObject object = new JSONObject();
        if (!response.success()) {
            object.put("state", "error");
            object.put("msg", "支付失败" + response.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "支付成功");
        }
        /*object.put("state", "success");
        object.put("msg", "支付成功");*/
        return object;
    }

    /**
     * 查询充值结果（充值成功返回true）
     *
     * @param orderId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/queryRechargeStatus", method = RequestMethod.POST)
    public Boolean queryRechargeStatus(Long orderId, String type, Long id) {
        if (orderId == null) {
            return Boolean.FALSE;
        }
        RestResponse<SysPayOrderDto> restResponse = queryPayOrderRemoteService.queryUpdatePayOrderStatus(null, orderId, null);
        if (restResponse.success()) {
            SysPayOrderDto orderDto = restResponse.getData();
            if (orderDto.getPayStatus() == PayOrderStatusEnum.SUCCESS ||
                    orderDto.getPayStatus() == PayOrderStatusEnum.FINISH) {
                // orderRemoteService.updatePayment(getAccessToken(), type, id);
                return Boolean.TRUE;
            }
        }
        return Boolean.FALSE;
    }

    @RequestMapping(value = "/view")
    public String view(Long id, ModelMap model) {
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());

        OrderDto dto = restResponse.getData();
        AgreementDto agreementDto = new AgreementDto();
        TravelAgencyDto travelAgencyDto = new TravelAgencyDto();
        if (dto.getAgreementId() != null) {
            agreementDto = agreementRemoteService.findById(dto.getAgreementId()).getData();
        }
        if (agreementDto.getTravelagencyId() != null) {
            travelAgencyDto = travelAgencyRemoteService.findByMenberId(agreementDto.getTravelagencyId()).getData();
        }
        model.addAttribute("travelAgencyDto", travelAgencyDto);
        model.addAttribute("agreementDto", agreementDto);
        model.addAttribute("infos", agreementDto.getInfos());
        model.addAttribute("types", TaOfflinePayType.values());
        model.addAttribute("lineTypes", TaOnlinePayType.values());
        /*model.addAttribute("type", currentUser.getUserType());*/
        return "/travelagency/order/view";
    }

    /**
     * 发送短信通知客户经理
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/sendMessages")
    public JSONObject sendMessages(Long id) {
        JSONObject object = new JSONObject();
        RestResponse<OrderDto> restResponse = orderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<Boolean> response = orderRemoteService.sendManger(getAccessToken(), restResponse.getData());
        if (!response.success()) {
            object.put("state", "error");
            object.put("msg", "发送失败" + response.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "发送成功");
        }
        RestResponse<OrderDto> dtoRestResponse = orderRemoteService.updateSendStatus(id);
        if (!dtoRestResponse.success()) {
            throw new BusinessException(dtoRestResponse.getErrorMsg());
        }
        return object;
    }


    /**
     * 退款
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/orderRefund")
    public JSONObject orderRefund(Long id) {
        JSONObject object = new JSONObject();
        RestResponse<OrderDto> restResponse = orderRemoteService.updateRefundStatus(getAccessToken(), id);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "退款失败" + restResponse.getErrorMsg());
        } else {
            OrderDto dto = restResponse.getData();
            //如果是已接单
            if (dto.getOrderStatus() == TaOrderStatus.haveOrder) {
                object.put("state", "success");
                object.put("msg", "退款申请成功，订单审核中!");
            } else {
                object.put("state", "success");
                object.put("msg", "退款成功");
            }
        }
        return object;
    }


    /*public JSONObject doPayRefund(Long orderId, BigDecimal amount) {
        JSONObject object = new JSONObject();
        Assert.notNull(orderId, "订单号不能为空");
        Assert.notNull(amount, "退款金额不能为空");
        String refundSn = System.currentTimeMillis() + "";
        SysRefundRequestDTO refundDTO = new SysRefundRequestDTO();
        //refundDTO.setRefundDesc(desc);
        // refundDTO.setPayOrderId(orderId);
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

    /**
     * 接单
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/orderReceiving")
    public JSONObject orderReceiving(Long id) {
        RestResponse<OrderDto> restResponse = orderRemoteService.updateOrderStatus(getAccessToken(), id);
        JSONObject object = new JSONObject();
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "接单失败！" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "接单成功！");
        }
        return object;
    }

    /**
     * 通知订单同步
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/noticeSync", method = RequestMethod.GET)
    public JSONObject noticeSync(Long id) {
        RestResponse<Boolean> restResponse = orderRemoteService.noticeSync(getAccessToken(), id);
        JSONObject object = new JSONObject();
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "通知失败！" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "通知成功！");
        }
        return object;
    }

    /**
     * 订单消费
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/orderConsume")
    public JSONObject orderConsume(Long id) {
        RestResponse<Boolean> restResponse = orderRemoteService.consume(getAccessToken(), id);
        JSONObject object = new JSONObject();
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "操作失败！" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "操作成功！");
        }
        return object;
    }

    /**
     * 消费统计
     *
     * @return
     */
    @RequestMapping(value = "/consumeCount")
    public String consumeCount(ModelMap model) {
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), new OrderDto());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/order/consumecount";
    }
}
