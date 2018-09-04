package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.travelagency.*;
import com.qmx.admin.remoteapi.travelagency.AgreementRemoteService;
import com.qmx.admin.remoteapi.travelagency.IncreaseProductRemoteService;
import com.qmx.admin.remoteapi.travelagency.ProductRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.admin.remoteapi.core.SysPayChannelRemoteService;
import com.qmx.admin.utils.ExcelUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.*;
import com.qmx.travelagency.api.enumerate.*;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Controller("/taAgreement")
@RequestMapping("/taAgreement")
public class AgreementController extends BaseController {

    @Autowired
    private AgreementRemoteService agreementRemoteService;
    @Autowired
    private ProductRemoteService productRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;
    @Autowired
    private IncreaseProductRemoteService increaseProductRemoteService;
    @Autowired
    private OrderRemoteService orderRemoteService;
    @Autowired
    private SysPayChannelRemoteService sysPayChannelRemoteService;
    @Autowired
    private AccountingBillRemoteService accountingBillRemoteService;

    @RequestMapping(value = "/list")
    public String list(AgreementDto dto, ModelMap model) {
        RestResponse<PageDto<AgreementDto>> restResponse = agreementRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }


        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/agreement/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        model.addAttribute("infos", OrderInfoType.values());
        model.addAttribute("types", TaOnlinePayType.values());
        return "/travelagency/agreement/add";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<AgreementDto> restResponse = agreementRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        AgreementDto agreementDto = restResponse.getData();
        List<ProductPolicyDto> products = agreementRemoteService.getProductPolicys(id).getData();
        List<IncreaseProductPolicyDto> increaseProducts = agreementRemoteService.getIncreaseProducts(id).getData();
        for (ProductPolicyDto product : products) {
            List<ProductPolicyDto> policyDtos = agreementRemoteService.getProductPolicyLists(agreementDto.getId(), product.getProductId()).getData();
            product.setPolicyDtos(policyDtos);

            JSONArray array = new JSONArray();
            JSONArray qbArray = new JSONArray();
            for (ProductPolicyDto policyDto : policyDtos) {
                JSONObject object = new JSONObject();
                object.put("ppid", String.valueOf(policyDto.getId()));
                object.put("productId", String.valueOf(policyDto.getProductId()));
                object.put("minNumber", String.valueOf(policyDto.getMinNumber()));
                object.put("maxNumber", String.valueOf(policyDto.getMaxNumber()));
                object.put("price", String.valueOf(policyDto.getPrice()));
                array.add(object);
            }
            //查询量返政策

            ProductReturnPolicyDto returnPolicyDto = agreementRemoteService.getByMemberAndProductId(agreementDto.getId(), product.getProductId()).getData();
            JSONObject object = new JSONObject();
            if (returnPolicyDto != null) {
                product.setReturnPolicyDto(returnPolicyDto);
                object.put("ppid", String.valueOf(returnPolicyDto.getId()));
                object.put("productId", String.valueOf(returnPolicyDto.getProductId()));
                object.put("type", String.valueOf(returnPolicyDto.getType()));
                object.put("returnType", String.valueOf(returnPolicyDto.getReturnType()));
                object.put("number", String.valueOf(returnPolicyDto.getNumber()));
                object.put("returnNumber", String.valueOf(returnPolicyDto.getReturnNumber()));
                object.put("repeat", String.valueOf(returnPolicyDto.getRepeat()));
            }
            qbArray.add(object);
            product.setProductPolicyJson(array.toJSONString());
            product.setReturnPolicyJson(qbArray.toJSONString());
        }
        for (IncreaseProductPolicyDto increaseProduct : increaseProducts) {
            List<IncreaseProductPolicyDto> increaseDtos = agreementRemoteService.getIncreaseProductPolicyList(agreementDto.getTravelagencyId(), increaseProduct.getProductId()).getData();
            JSONArray array = new JSONArray();
            for (IncreaseProductPolicyDto increaseDto : increaseDtos) {
                JSONObject object = new JSONObject();
                object.put("ppid", String.valueOf(increaseDto.getId()));
                object.put("ipProductId", String.valueOf(increaseDto.getProductId()));
                object.put("ipPrice", String.valueOf(increaseDto.getPrice()));
                array.add(object);
            }
            increaseProduct.setIncreasePolicyJson(array.toJSONString());
        }
        model.addAttribute("products", products);
        model.addAttribute("dto", agreementDto);
        model.addAttribute("infos", OrderInfoType.values());
        model.addAttribute("increaseProducts", increaseProducts);
        model.addAttribute("types", TaOnlinePayType.values());

        return "/travelagency/agreement/edit";
    }


    @RequestMapping(value = "/save")
    public String save(AgreementDto dto, HttpServletRequest request) {
        String[] ppids = request.getParameterValues("ppid");
        String[] productIds = request.getParameterValues("productId");
        String[] minNumbers = request.getParameterValues("minNumber");
        String[] maxNumbers = request.getParameterValues("maxNumber");
        String[] prices = request.getParameterValues("price");
        String[] type = request.getParameterValues("type");
        String[] returnType = request.getParameterValues("returnType");
        String[] number = request.getParameterValues("number");
        String[] returnNumber = request.getParameterValues("returnNumber");
        String[] repeat = request.getParameterValues("repeat");
        String[] qbProductIds = request.getParameterValues("qbProductId");
        String[] ipPrice = request.getParameterValues("ipPrice");
        String[] ipProductIds = request.getParameterValues("ipProductId");
        List<ProductPolicyDto> productPolicyDtos = new ArrayList<>();
        List<ProductReturnPolicyDto> returnPolicyDtos = new ArrayList<>();
        List<IncreaseProductPolicyDto> increaseProductPolicyDtos = new ArrayList<>();
        if (productIds != null && productIds.length > 0) {
            for (int i = 0; i < productIds.length; i++) {
                ProductPolicyDto productDto = new ProductPolicyDto();
                if (StringUtils.isNotEmpty(ppids[i])) {
                    productDto.setId(Long.parseLong(ppids[i]));
                }
                productDto.setProductId(Long.parseLong(productIds[i]));
                productDto.setMinNumber(Integer.parseInt(minNumbers[i]));
                productDto.setMaxNumber(Integer.parseInt(maxNumbers[i]));
                productDto.setPrice(new BigDecimal(prices[i]));
                productPolicyDtos.add(productDto);
            }
        }
        if (qbProductIds != null && qbProductIds.length > 0) {
            for (int i = 0; i < qbProductIds.length; i++) {
                ProductReturnPolicyDto returnPolicyDto = new ProductReturnPolicyDto();
                returnPolicyDto.setProductId(Long.parseLong(qbProductIds[i]));
                returnPolicyDto.setNumber(new BigDecimal(number[i]));
                returnPolicyDto.setReturnNumber(new BigDecimal(returnNumber[i]));
                returnPolicyDto.setType(AmountMoney.valueOf(type[i]));
                returnPolicyDto.setReturnType(AmountMoney.valueOf(returnType[i]));
                returnPolicyDto.setRepeat(Boolean.parseBoolean(repeat[i]));
                returnPolicyDtos.add(returnPolicyDto);

            }
        }
        if (ipProductIds != null && ipProductIds.length > 0) {
            for (int i = 0; i < ipProductIds.length; i++) {
                IncreaseProductPolicyDto increaseProductPolicyDto = new IncreaseProductPolicyDto();
                increaseProductPolicyDto.setProductId(Long.parseLong(ipProductIds[i]));
                increaseProductPolicyDto.setPrice(new BigDecimal(ipPrice[i]));
                increaseProductPolicyDtos.add(increaseProductPolicyDto);

            }
        }
        dto.setProductPolicyDtos(productPolicyDtos);
        dto.setReturnPolicyDto(returnPolicyDtos);
        dto.setIncreaseProductPolicyDtos(increaseProductPolicyDtos);
        RestResponse<AgreementDto> restResponse = agreementRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(AgreementDto dto, HttpServletRequest request) {
        String[] ppids = request.getParameterValues("ppid");
        String[] productIds = request.getParameterValues("productId");
        String[] minNumbers = request.getParameterValues("minNumber");
        String[] maxNumbers = request.getParameterValues("maxNumber");
        String[] prices = request.getParameterValues("price");
        String[] type = request.getParameterValues("type");
        String[] returnType = request.getParameterValues("returnType");
        String[] number = request.getParameterValues("number");
        String[] returnNumber = request.getParameterValues("returnNumber");
        String[] repeat = request.getParameterValues("repeat");
        String[] qbProductIds = request.getParameterValues("qbProductId");
        String[] ipPrice = request.getParameterValues("ipPrice");
        String[] ipProductIds = request.getParameterValues("ipProductId");
        List<ProductPolicyDto> productPolicyDtos = new ArrayList<>();
        List<ProductReturnPolicyDto> returnPolicyDtos = new ArrayList<>();
        List<IncreaseProductPolicyDto> increaseProductPolicyDtos = new ArrayList<>();
        if (productIds != null && productIds.length > 0) {
            for (int i = 0; i < productIds.length; i++) {
                ProductPolicyDto productDto = new ProductPolicyDto();
                if (StringUtils.isNotEmpty(ppids[i])) {
                    productDto.setId(Long.parseLong(ppids[i]));
                }
                productDto.setProductId(Long.parseLong(productIds[i]));
                productDto.setMinNumber(Integer.parseInt(minNumbers[i]));
                productDto.setMaxNumber(Integer.parseInt(maxNumbers[i]));
                productDto.setPrice(new BigDecimal(prices[i]));
                productPolicyDtos.add(productDto);
            }
        }
        if (qbProductIds != null && qbProductIds.length > 0) {
            for (int i = 0; i < qbProductIds.length; i++) {
                ProductReturnPolicyDto returnPolicyDto = new ProductReturnPolicyDto();
                returnPolicyDto.setProductId(Long.parseLong(qbProductIds[i]));
                returnPolicyDto.setRepeat(Boolean.parseBoolean(repeat[i]));
                returnPolicyDto.setType(AmountMoney.valueOf(type[i]));
                returnPolicyDto.setReturnType(AmountMoney.valueOf(returnType[i]));
                returnPolicyDto.setNumber(new BigDecimal(number[i]));
                returnPolicyDto.setReturnNumber(new BigDecimal(returnNumber[i]));
                returnPolicyDtos.add(returnPolicyDto);

            }
        }
        if (ipProductIds != null && ipProductIds.length > 0) {
            for (int i = 0; i < ipProductIds.length; i++) {
                IncreaseProductPolicyDto increaseProductPolicyDto = new IncreaseProductPolicyDto();
                increaseProductPolicyDto.setProductId(Long.parseLong(ipProductIds[i]));
                increaseProductPolicyDto.setPrice(new BigDecimal(ipPrice[i]));
                increaseProductPolicyDtos.add(increaseProductPolicyDto);

            }
        }
        dto.setProductPolicyDtos(productPolicyDtos);
        dto.setReturnPolicyDto(returnPolicyDtos);
        dto.setIncreaseProductPolicyDtos(increaseProductPolicyDtos);
        RestResponse<AgreementDto> restResponse = agreementRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = agreementRemoteService.deleteDto(getAccessToken(), id);
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
    @RequestMapping(value = "/deleteProductPolicy")
    public JSONObject deleteProductPolicy(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = agreementRemoteService.deleteProductPolicyDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    /**
     * 获取主产品列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/getProducts")
    public String getProducts(ProductDto dto, ModelMap model) {
        RestResponse<PageDto<ProductDto>> restResponse = productRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/agreement/productlist";
    }

    /**
     * 获取增值产品列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/getIncreaseProducts")
    public String getIncreaseProducts(IncreaseProductDto dto, ModelMap model) {
        RestResponse<PageDto<IncreaseProductDto>> restResponse = increaseProductRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/agreement/increaseproductlist";
    }

    /**
     * 设置梯度价格
     *
     * @param memberId
     * @param productId
     * @param model
     * @return
     */
    @RequestMapping(value = "/getProductPolicyList")
    public String getProductPolicyList(Long memberId, Long productId, ModelMap model) {
        model.addAttribute("memberId", memberId);
        model.addAttribute("productId", productId);
        return "/travelagency/agreement/productpolicylist";
    }

    /**
     * 设置量返政策
     *
     * @param memberId
     * @param productId
     * @param model
     * @return
     */
    @RequestMapping(value = "/getProductReturnPolicy")
    public String getProductReturnPolicy(Long memberId, Long productId, ModelMap model) {
        model.addAttribute("memberId", memberId);
        model.addAttribute("productId", productId);
        model.addAttribute("type", AmountMoney.values());
        return "/travelagency/agreement/productreturnpolicylist";
    }

    /**
     * 设置增值产品协议
     *
     * @param memberId
     * @param productId
     * @param model
     * @return
     */
    @RequestMapping(value = "/getIncreasePrice")
    public String getIncreasePrice(Long memberId, Long productId, ModelMap model) {
        model.addAttribute("memberId", memberId);
        model.addAttribute("productId", productId);
        return "/travelagency/agreement/increaseprice";
    }

    @RequestMapping(value = "/gettravelagency")
    public String gettravelagency(TravelAgencyDto dto, ModelMap model) {
        RestResponse<PageDto<TravelAgencyDto>> restResponse = travelAgencyRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("dto", dto);
        return "/travelagency/agreement/travelagencylist";
    }

    /**
     * 获取清帐的订单
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/closeout")
    public String closeout(OrderDto dto, ModelMap model) {
        dto.setTaPaymentStatus(TaPaymentStatus.buyer);
        dto.setTicketStatus(Boolean.TRUE);
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/agreement/closeout";
    }

    /**
     * 创建清帐账单
     *
     * @param model
     * @return
     */
    @RequestMapping("/createBill")
    public String createBill(Long[] ids, AccountingBillDto dto, ModelMap model) {
        // String[] ids = request.getParameterValues("ids");
        RestResponse<AccountingBillDto> restResponse = accountingBillRemoteService.returnBill(getAccessToken(), dto, ids);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        String str = StringUtils.join(ids, ",");
        model.addAttribute("ids", str);
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/travelagency/agreement/createbill";
    }

    /**
     * 结算绩效,保存账单
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/settlement")
    public JSONObject settlement(AccountingBillDto dto, HttpServletRequest request) {
        String strings = request.getParameter("ids");
        String[] ids = strings.split(",");
        JSONObject object = new JSONObject();
        RestResponse<AccountingBillDto> restResponse = accountingBillRemoteService.createDto(getAccessToken(), dto, ids);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "清帐失败" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "清帐成功");
        }
        return object;
    }


    /**
     * 账单列表
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/billList")
    public String billList(AccountingBillDto dto, ModelMap model) {
        RestResponse<PageDto<AccountingBillDto>> restResponse = accountingBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/travelagency/agreement/billlist";
    }

    @RequestMapping(value = "/viewBill")
    public String viewBill(OrderDto dto, ModelMap model) {
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<AccountingBillDto> response = accountingBillRemoteService.findBySn(dto.getAccountingBillSn());
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("bill", response.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/travelagency/agreement/viewbill";
    }

    /**
     * 导出清帐账单
     *
     * @param response
     * @param dto
     */
    @ResponseBody
    @RequestMapping(value = "/exportBill")
    public void exportBill(HttpServletResponse response, AccountingBillDto dto) {
        RestResponse<PageDto<AccountingBillDto>> restResponse = accountingBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<AccountingBillDto> billDtos = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("旅行社清帐账单", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (AccountingBillDto accountingBillDto : billDtos) {
                String channelNo = null;
                if (!StringUtils.isEmpty(accountingBillDto.getChannelNo())) {
                    channelNo = TaOfflinePayType.valueOf(accountingBillDto.getChannelNo()).getTitle();
                }

                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(accountingBillDto.getCreateTime());
                Object[] objects = new Object[6];
                objects[0] = accountingBillDto.getSn();
                objects[1] = channelNo;
                objects[2] = accountingBillDto.getAmount();
                objects[3] = date;
                objects[4] = accountingBillDto.getCreateName();
                objects[5] = accountingBillDto.getRemark();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "旅行社清帐账单", new String[]{"编号", "支出方式", "支出金额",
                            "结算时间", "操作人", "备注"},
                    new int[]{0, 1, 2, 3, 4, 5}, billDtos.size(), out);
            out.flush();
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 导出清帐账单明细
     *
     * @param response
     */
    @ResponseBody
    @RequestMapping(value = "/export")
    public void export(HttpServletResponse response, OrderDto dto) {
        RestResponse<PageDto<OrderDto>> restResponse = orderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<AccountingBillDto> billResponse = accountingBillRemoteService.findBySn(dto.getAccountingBillSn());
        if (!billResponse.success()) {
            throw new BusinessException(billResponse.getErrorMsg());
        }
        List<OrderDto> orderDtoList = restResponse.getData().getRecords();
        AccountingBillDto billDto = billResponse.getData();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("旅行社清帐账单明细", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (OrderDto orderDto : orderDtoList) {
                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(orderDto.getCreateTime());
                Object[] objects = new Object[6];
                objects[0] = orderDto.getMemberName();
                objects[1] = orderDto.getSn();
                objects[2] = date;
                objects[3] = date;
                objects[4] = orderDto.getTotalAmount();
                objects[5] = TaOfflinePayType.valueOf(billDto.getChannelNo()).getTitle();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "旅行社清帐账单明细", new String[]{"旅行社", "订单编号",
                            "下单时间", "消费时间", "清帐金额", "清帐方式"},
                    new int[]{0, 1, 2, 3, 4, 5}, orderDtoList.size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 查看协议
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/view")
    public String view(Long id, ModelMap model) {
        RestResponse<AgreementDto> restResponse = agreementRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        AgreementDto agreementDto = restResponse.getData();
        List<ProductPolicyDto> products = agreementRemoteService.getProductPolicys(id).getData();
        List<IncreaseProductPolicyDto> increaseProducts = agreementRemoteService.getIncreaseProducts(id).getData();
        for (ProductPolicyDto product : products) {
            List<ProductPolicyDto> policyDtos = agreementRemoteService.getProductPolicyLists(agreementDto.getId(), product.getProductId()).getData();
            product.setPolicyDtos(policyDtos);

            JSONArray array = new JSONArray();
            JSONArray qbArray = new JSONArray();
            for (ProductPolicyDto policyDto : policyDtos) {
                JSONObject object = new JSONObject();
                object.put("ppid", String.valueOf(policyDto.getId()));
                object.put("productId", String.valueOf(policyDto.getProductId()));
                object.put("minNumber", String.valueOf(policyDto.getMinNumber()));
                object.put("maxNumber", String.valueOf(policyDto.getMaxNumber()));
                object.put("price", String.valueOf(policyDto.getPrice()));
                array.add(object);
            }
            //查询量返政策

            ProductReturnPolicyDto returnPolicyDto = agreementRemoteService.getByMemberAndProductId(agreementDto.getId(), product.getProductId()).getData();
            JSONObject object = new JSONObject();
            if (returnPolicyDto != null) {
                product.setReturnPolicyDto(returnPolicyDto);
                object.put("ppid", String.valueOf(returnPolicyDto.getId()));
                object.put("productId", String.valueOf(returnPolicyDto.getProductId()));
                object.put("type", String.valueOf(returnPolicyDto.getType()));
                object.put("returnType", String.valueOf(returnPolicyDto.getReturnType()));
                object.put("number", String.valueOf(returnPolicyDto.getNumber()));
                object.put("returnNumber", String.valueOf(returnPolicyDto.getReturnNumber()));
                object.put("repeat", String.valueOf(returnPolicyDto.getRepeat()));
            }
            qbArray.add(object);
            product.setProductPolicyJson(array.toJSONString());
            product.setReturnPolicyJson(qbArray.toJSONString());
        }
        for (IncreaseProductPolicyDto increaseProduct : increaseProducts) {
            List<IncreaseProductPolicyDto> increaseDtos = agreementRemoteService.getIncreaseProductPolicyList(agreementDto.getTravelagencyId(), increaseProduct.getProductId()).getData();
            JSONArray array = new JSONArray();
            for (IncreaseProductPolicyDto increaseDto : increaseDtos) {
                JSONObject object = new JSONObject();
                object.put("ppid", String.valueOf(increaseDto.getId()));
                object.put("ipProductId", String.valueOf(increaseDto.getProductId()));
                object.put("ipPrice", String.valueOf(increaseDto.getPrice()));
                array.add(object);
            }
            increaseProduct.setIncreasePolicyJson(array.toJSONString());
        }
        model.addAttribute("products", products);
        model.addAttribute("dto", agreementDto);
        model.addAttribute("infos", OrderInfoType.values());
        model.addAttribute("increaseProducts", increaseProducts);
        model.addAttribute("types", TaOnlinePayType.values());
        return "/travelagency/agreement/view";
    }

    /**
     * 协议量返列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping("/orderReturnList")
    public String orderReturnList(OrderReturnInfoDto dto, ModelMap model) {
        RestResponse<PageDto<OrderReturnInfoDto>> restResponse = agreementRemoteService.findOrderReturnList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/agreement/orderreturnlist";
    }

    /**
     * 获取该月量返的总量
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/returnCount")
    public JSONObject returnCount(String date, Long memberId) {
        JSONObject object = new JSONObject();
        //查询该月量返金额的信息集合
        RestResponse<List<OrderReturnInfoDto>> restResponse = agreementRemoteService.findReturnInfos(getAccessToken(), date, memberId, AmountMoney.money.name());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<OrderReturnInfoDto> moneyList = restResponse.getData();
        //List<Long> mids = new ArrayList<>();
        BigDecimal moneySum = new BigDecimal(0);
        if (!moneyList.isEmpty()) {
            for (OrderReturnInfoDto orderReturnInfoDto : moneyList) {
                //mids.add(orderReturnInfoDto.getId());
                moneySum = moneySum.add(orderReturnInfoDto.getReturnPrice()).setScale(2);
            }
        }
        //查询该月量返数量的信息集合
        RestResponse<List<OrderReturnInfoDto>> response = agreementRemoteService.findReturnInfos(getAccessToken(), date, memberId, AmountMoney.amount.name());
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        List<OrderReturnInfoDto> amountList = response.getData();
        BigDecimal amountSum = new BigDecimal(0);
        if (!amountList.isEmpty()) {
            for (OrderReturnInfoDto orderReturnInfoDto : amountList) {
                amountSum = amountSum.add(orderReturnInfoDto.getReturnPrice()).setScale(2);
            }
        }
        object.put("moneySum", moneySum);
        object.put("amountSum", amountSum);
        return object;
    }

    /**
     * 返回量返数量总数，金额总数
     *
     * @param moneySum
     * @param amountSum
     * @return
     */
    @RequestMapping("/returnInfo")
    public String returnInfo(String moneySum, String amountSum, String date, Long memberId, ModelMap model) {
        model.addAttribute("moneySum", moneySum);
        model.addAttribute("amountSum", amountSum);
        model.addAttribute("date", date);
        model.addAttribute("memberId", memberId);
        return "/travelagency/agreement/returninfo";
    }

    /**
     * 执行量返操作
     *
     * @param date
     * @param memberId
     * @return
     */
    @ResponseBody
    @RequestMapping("/executeReturn")
    public JSONObject executeReturn(String date, Long memberId) {
        JSONObject object = new JSONObject();
        RestResponse<Boolean> restResponse = agreementRemoteService.updateStatus(date, memberId);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "操作失败" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "操作成功");
        }
        return object;
    }

}
