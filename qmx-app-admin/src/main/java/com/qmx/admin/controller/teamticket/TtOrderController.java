package com.qmx.admin.controller.teamticket;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.*;
import com.qmx.admin.remoteapi.teamticket.*;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.pay.constant.PayConstant;
import com.qmx.coreservice.api.pay.dto.SysPayChannelDto;
import com.qmx.coreservice.api.pay.dto.SysPayOrderDto;
import com.qmx.coreservice.api.pay.dto.request.SysPayRequestDTO;
import com.qmx.coreservice.api.pay.enumerate.PayOrderStatusEnum;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.TradingTypeEnum;
import com.qmx.teamticket.api.dto.*;
import com.qmx.teamticket.api.enumerate.SaleChannelEnum;
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

@Controller
@RequestMapping("/ttorder")
public class TtOrderController extends BaseController {
    @Autowired
    private TtOrderRemoteService ttOrderRemoteService;
    @Autowired
    private TtProductRemoteService ttProductRemoteService;
    @Autowired
    private TtCustomerRemoteService ttCustomerRemoteService;
    @Autowired
    private TtCustomerProductRemoteService ttCustomerProductRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysPayOrderRemoteService sysPayOrderRemoteService;

    @Autowired
    private SysPayChannelRemoteService sysPayChannelRemoteService;
    @Autowired
    private QueryPayOrderRemoteService queryPayOrderRemoteService;
    @Autowired
    private TtProductAuthorizaRemoteService ttProductAuthorizaRemoteService;

    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;
    @Autowired
    private TtOrderRefundRemoteService ttOrderRefundRemoteService;

    @RequestMapping(value = "/list")
    public String list(TtOrderDto dto, ModelMap model) {
        RestResponse<PageDto<TtOrderDto>> restResponse = ttOrderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttorder/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        RestResponse<List<TtProductDto>> products = ttProductRemoteService.getProducts(getAccessToken());
        model.addAttribute("products", products.getData());

        SmsTemplateQueryVo smsTemplateQueryVo = new SmsTemplateQueryVo();
        smsTemplateQueryVo.setPageSize(100);
        smsTemplateQueryVo.setModuleId(913236857851006978L);
        RestResponse<PageDto<SmsTemplateDto>> restResponse = smsTemplateRemoteService.findSupplierAuthPage(getAccessToken(), smsTemplateQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("smsTemplates", restResponse.getData().getRecords());

        return "/teamticket/ttorder/add";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/teamticket/ttorder/edit";
    }

    @RequestMapping(value = "/save")
    public String save(TtOrderDto dto, HttpServletRequest request) {
        List<TtOrderInfoDto> infos = new ArrayList<>();
        String[] productids = request.getParameterValues("productId");
        for (String productid : productids) {
            String quantity = request.getParameter("quantity_" + productid);
            String price = request.getParameter("price_" + productid);
            TtOrderInfoDto infoDto = new TtOrderInfoDto();
            infoDto.setProductId(Long.parseLong(productid));
            infoDto.setQuantity(Long.parseLong(quantity));
            infoDto.setPrice(new BigDecimal(price));
            infos.add(infoDto);
        }
        dto.setInfos(infos);
        RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.createTtOrder(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(TtOrderDto dto, HttpServletRequest request) {
        List<TtOrderInfoDto> infos = new ArrayList<>();
        String[] productids = request.getParameterValues("productId");
        for (String productid : productids) {
            String infoId = request.getParameter("infoId_" + productid);
            String quantity = request.getParameter("quantity_" + productid);
            String price = request.getParameter("price_" + productid);
            TtOrderInfoDto infoDto = new TtOrderInfoDto();
            if (infoId != null) {
                infoDto.setId(Long.parseLong(infoId));
            }
            infoDto.setProductId(Long.parseLong(productid));
            infoDto.setQuantity(Long.parseLong(quantity));
            infoDto.setPrice(new BigDecimal(price));
            infos.add(infoDto);
        }
        dto.setInfos(infos);
        RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.updateTtOrder(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = ttOrderRemoteService.deleteTtOrder(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    @ResponseBody
    @RequestMapping(value = "/deleteOrderInfo")
    public Boolean deleteOrderInfo(Long id) {
        try {
            RestResponse restResponse = ttOrderRemoteService.deleteTtOrderInfo(getAccessToken(), id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            return Boolean.TRUE;
        } catch (Exception e) {
            return Boolean.FALSE;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/getCustomer", method = RequestMethod.POST)
    public Object getProduct(Integer page, String q) {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();

        TtCustomerDto dto = new TtCustomerDto();
        dto.setPageIndex(page);
        dto.setEnterpriseName(q);

        RestResponse<PageDto<TtCustomerDto>> restResponse = ttCustomerRemoteService.findList(getAccessToken(), dto);
        for (TtCustomerDto customerDto : restResponse.getData().getRecords()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", customerDto.getId().toString());
            map.put("enterpriseName", customerDto.getEnterpriseName());
            rows.add(map);
        }
        result.put("total", restResponse.getData().getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    @RequestMapping(value = "/view")
    public String view(Long id, ModelMap model) {
        RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        TtOrderDto dto = restResponse.getData();
        RestResponse<SysUserDto> operator = sysUserRemoteService.findById(dto.getMemberId());
        if (operator.getData() != null) {
            dto.setOperatorName(operator.getData().getAccount());
        }
        model.addAttribute("dto", dto);
        return "/teamticket/ttorder/view";
    }

    @RequestMapping(value = "/payment")
    public String payment(Long id, ModelMap model) {
        RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //系统支付配置
        RestResponse<List<SysPayChannelDto>> sysPayChannelDtos = sysPayChannelRemoteService.findMchPayChannel(getAccessToken(), 1L);
        if (!sysPayChannelDtos.success()) {
            throw new BusinessException(sysPayChannelDtos.getErrorMsg());
        }
        List<SysPayChannelDto> payChannelDtoList = sysPayChannelDtos.getData();
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
        model.addAttribute("paytypes", newList);
        model.addAttribute("dto", restResponse.getData());
        return "/teamticket/ttorder/payment";
    }

    @RequestMapping(value = "/payorder")
    public String payorder(Long id, String paytype, String remark, String payChannelNo, ModelMap model) {
        if ("xianxia".equals(paytype)) {
            ttOrderRemoteService.orderOfflinePay(getAccessToken(), id, remark);
            return "redirect:list.jhtml";
        } else {
            RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.findById(id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            TtOrderDto orderDto = restResponse.getData();
            SysPayRequestDTO payDTO = new SysPayRequestDTO();
            payDTO.setAmount(orderDto.getTotalAmount().subtract(orderDto.getAmountPaid()).setScale(2));
            payDTO.setProductId(payChannelNo + orderDto.getSn());
            payDTO.setBody("团单[" + orderDto.getSn() + "]支付");
            payDTO.setMchId(orderDto.getSupplierId());
            payDTO.setMchOrderId(String.valueOf(orderDto.getId()));
            payDTO.setChannelNo(payChannelNo);
            payDTO.setSubject("团单[" + orderDto.getSn() + "]支付");
            payDTO.setTradingType(TradingTypeEnum.ORDER_PAYMENT);
            payDTO.setTradingScene(SaleChannelEnum.TT_ORDER_PAY.getTitle());
            payDTO.setNotifyUrl("http://team-ticket/TtOrder/orderPayNotify");
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
            return "/teamticket/ttorder/payorder";
        }
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
        if (restResponse.success()) {
            SysPayOrderDto orderDto = restResponse.getData();
            if (orderDto.getPayStatus() == PayOrderStatusEnum.SUCCESS ||
                    orderDto.getPayStatus() == PayOrderStatusEnum.FINISH) {
                return Boolean.TRUE;
            }
        }
        return Boolean.FALSE;
    }

    @ResponseBody
    @RequestMapping(value = "/agree")
    public JSONObject agree(Long id) {
        JSONObject object = new JSONObject();
        RestResponse restResponse = ttOrderRemoteService.agreeTtOrder(getAccessToken(), id);
        if (restResponse.success()) {
            object.put("state", "success");
            object.put("msg", "操作成功");
            return object;
        } else {
            object.put("state", "fail");
            object.put("msg", restResponse.getErrorMsg());
            return object;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/disagree")
    public JSONObject disagree(Long id) {
        JSONObject object = new JSONObject();
        RestResponse restResponse = ttOrderRemoteService.disagreeTtOrder(getAccessToken(), id);
        if (restResponse.success()) {
            object.put("state", "success");
            object.put("msg", "操作成功");
            return object;
        } else {
            object.put("state", "fail");
            object.put("msg", restResponse.getErrorMsg());
            return object;
        }
    }

    @RequestMapping(value = "/getCustomers", method = {RequestMethod.GET, RequestMethod.POST})
    public String getCustomers(TtCustomerDto dto, ModelMap model) {
        RestResponse<PageDto<TtCustomerDto>> restResponse = ttCustomerRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttorder/customerlist";
    }

    @RequestMapping(value = "/getProducts")
    public String getProducts(Long customerId, TtProductDto dto, ModelMap model) {
        Long userId = null;
        List<TtCustomerProductDto> productDtoList = null;
        if (customerId != null) {
            TtCustomerDto customerDto = ttCustomerRemoteService.findById(customerId).getData();
            productDtoList = customerDto.getProducts();
            userId = customerDto.getMemberId();
        } else {
            SysUserDto userDto = getCurrentMember();
            userId = userDto.getId();
        }
        List<TtProductDto> newdto = new ArrayList<>();

        TtProductAuthorizaDto PAdto1 = ttProductAuthorizaRemoteService.findByUserId(userId).getData();
        if (PAdto1 != null) {
            //该员工授权的产品
            List<TtProductAuthorizaProductDto> productAuthorizaList = PAdto1.getProducts();

            if (productAuthorizaList != null && productAuthorizaList.size() > 0) {
                for (TtProductAuthorizaProductDto productADto : productAuthorizaList) {
                    boolean is = true;
                    TtProductDto newProduct = ttProductRemoteService.findById(productADto.getProductId()).getData();
                    if (productDtoList != null && productDtoList.size() > 0) {
                        for (TtCustomerProductDto productDto : productDtoList) {
                            if (productADto.getProductId().equals(productDto.getProductId())) {
                                newProduct.setMarketPrice(productDto.getPrice());
                                newProduct.setSales(productADto.getSize());
                                is = false;
                                continue;
                            }
                        }
                    }
                    if (is) {
                        newProduct.setMarketPrice(productADto.getPrice());
                        newProduct.setSales(productADto.getSize());
                    }
                    newdto.add(newProduct);
                }
            }
        }

        //保存当前页码
        Integer pageIndex = dto.getPageIndex();

        dto.setPageIndex(1);
        dto.setPageSize(999);
        dto.setMarketable(Boolean.TRUE);

        RestResponse<PageDto<TtProductDto>> restResponse = ttProductRemoteService.findList(getAccessToken(), dto);
        PageDto<TtProductDto> page = restResponse.getData();
        List<TtProductDto> records = page.getRecords();
        //保存新数据
        List<TtProductDto> newrecords = new ArrayList<>();
        if (records != null && records.size() > 0) {
            for (TtProductDto productDto : records) {
                boolean ok = false;
                if (newdto != null && newdto.size() > 0) {
                    TtProductDto papDto1 = null;
                    for (TtProductDto papDto : newdto) {
                        if (productDto.getId().equals(papDto.getId())) {
                            ok = true;
                            papDto1 = papDto;
                            continue;
                        }
                    }
                    if (ok) {
                        newrecords.add(papDto1);
                    }
                }
            }
            page.getRecords().clear();
            page.setPages(newrecords.size() / 10);
            page.setPageSize(10);
            page.setHasNext(true);
            page.setHasPrevious(true);
            page.setTotal(newrecords.size());
            page.setPageIndex(pageIndex);
            if (newrecords.size() > 0) {
                if ((10 * (pageIndex - 1)) > page.getTotal()) {
                    pageIndex = 1;
                    page.setPageIndex(pageIndex);
                }
                if (10 * pageIndex > page.getTotal()) {
                    page.setRecords(newrecords.subList(10 * (pageIndex - 1), page.getTotal()));
                } else {
                    page.setRecords(newrecords.subList(10 * (pageIndex - 1), 10 * pageIndex));
                }
            }
        }


        model.addAttribute("customerId", customerId);
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttorder/productlist";
    }

    @ResponseBody
    @RequestMapping(value = "/getByCustomerId")
    public JSONArray getByCustomerId(Long customerId) {
        JSONArray array = new JSONArray();
        RestResponse<List<TtCustomerProductDto>> restResponse = ttCustomerProductRemoteService.getByCustomerId(customerId);
        if (!restResponse.success()) {
            return array;
        }
        List<TtCustomerProductDto> productDtos = restResponse.getData();
        for (TtCustomerProductDto productDto : productDtos) {
            JSONObject object = new JSONObject();
            TtProductDto ttProductDto = ttProductRemoteService.findById(productDto.getProductId()).getData();
            object.put("id", productDto.getProductId() + "");
            object.put("name", ttProductDto.getName());
            array.add(object);
        }
        return array;
    }

    @ResponseBody
    @RequestMapping(value = "/getByCustomerIdAndProductId")
    public JSONObject getByCustomerIdAndProductId(Long customerId, Long productId) {
        JSONObject json = new JSONObject();
        RestResponse<TtCustomerProductDto> restResponse = ttCustomerProductRemoteService.getByCustomerIdAndProductId(customerId, productId);
        if (!restResponse.success()) {
            return json;
        }
        TtCustomerProductDto dto = restResponse.getData();
        if (dto == null) {
            json.put("price", "");
            json.put("size", "");
        } else {
            json.put("price", dto.getPrice());
            json.put("size", dto.getSize());
        }
        return json;
    }

    /**
     * 发送短信
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/sendMessages")
    public JSONObject sendMessages(Long id) {
        JSONObject object = new JSONObject();
        try {
            RestResponse<TtOrderDto> restResponse = ttOrderRemoteService.findById(id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            ttOrderRemoteService.sendTextMessages(getAccessToken(), restResponse.getData());
            object.put("state", "success");
            object.put("msg", "发送成功");
            return object;
        } catch (BusinessException e) {
            e.printStackTrace();
            object.put("state", "error");
            object.put("msg", "发送失败");
            return object;
        }
    }

    /**
     * 订单退款
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/refundOrder", method = RequestMethod.POST)
    public JSONObject refundOrder(Long id) {
        JSONObject object = new JSONObject();
        try {
            TtOrderDto ttOrderDto = ttOrderRemoteService.findById(id).getData();
            TtOrderRefundDto refundDto = new TtOrderRefundDto();
            refundDto.setOrderId(ttOrderDto.getId());
            refundDto.setSn(ttOrderDto.getSn());
            refundDto.setAmount(ttOrderDto.getAmountPaid());
            RestResponse<TtOrderRefundDto> restResponse = ttOrderRefundRemoteService.createDto(getAccessToken(), refundDto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            object.put("state", "success");
            object.put("msg", "申请退款成功");
            return object;
        } catch (Exception e) {
            e.printStackTrace();
            object.put("state", "error");
            object.put("msg", "申请退款失败");
            return object;
        }
    }

}
