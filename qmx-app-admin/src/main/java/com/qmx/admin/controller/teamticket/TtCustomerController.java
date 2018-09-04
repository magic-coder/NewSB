package com.qmx.admin.controller.teamticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.teamticket.*;
import com.qmx.admin.utils.AreaUtils;
import com.qmx.admin.utils.ExcelUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.teamticket.api.dto.*;
import com.qmx.teamticket.api.enumerate.CustomerType;
import com.qmx.teamticket.api.enumerate.OrderStatus;
import com.qmx.teamticket.api.enumerate.PaymentStatus;
import com.qmx.travelagency.api.dto.AccountingBillDto;
import com.qmx.travelagency.api.dto.OrderDto;
import com.qmx.travelagency.api.enumerate.TaOfflinePayType;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

@Controller
@RequestMapping("/ttcustomer")
public class TtCustomerController extends BaseController {
    @Autowired
    private TtCustomerRemoteService ttCustomerRemoteService;
    @Autowired
    private TtCustomerProductRemoteService ttCustomerProductRemoteService;
    @Autowired
    private TtProductRemoteService ttProductRemoteService;
    @Autowired
    private TtOrderRemoteService ttOrderRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TtProductAuthorizaRemoteService ttProductAuthorizaRemoteService;
    @Autowired
    private TtAccountingBillRemoteService ttAccountingBillRemoteService;

    @RequestMapping(value = "/list")
    public String list(TtCustomerDto dto, ModelMap model) {
        RestResponse<PageDto<TtCustomerDto>> restResponse = ttCustomerRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttcustomer/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        if (userDto.getUserType() == SysUserType.supplier) {
            UserQueryVo dto = new UserQueryVo();
            dto.setUserType(SysUserType.employee);
            dto.setPageSize(100);
            RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), dto);
            model.addAttribute("users", restResponse.getData().getRecords());
        }
        model.addAttribute("types", CustomerType.values());
        return "/teamticket/ttcustomer/add";
    }

    @RequestMapping(value = "/save")
    public String save(TtCustomerDto dto, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        String[] productIds = request.getParameterValues("productId");
        String[] prices = request.getParameterValues("price");
        String[] sizes = request.getParameterValues("size");
        List<TtCustomerProductDto> productDtos = new ArrayList<>();
        if (productIds != null) {
            for (int i = 0; i < productIds.length; i++) {
                TtCustomerProductDto productDto = new TtCustomerProductDto();
                productDto.setProductId(Long.parseLong(productIds[i]));
                productDto.setPrice(new BigDecimal(prices[i]));
                productDto.setSize(0);
                productDtos.add(productDto);
            }
        }
        dto.setArea(AreaUtils.getArea(request));
        dto.setProducts(productDtos);
        RestResponse<TtCustomerDto> restResponse = ttCustomerRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("noticeMsg", "操作成功");
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        if (userDto.getUserType() == SysUserType.supplier) {
            UserQueryVo dto = new UserQueryVo();
            dto.setUserType(SysUserType.employee);
            dto.setPageSize(100);
            RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), dto);
            model.addAttribute("users", restResponse.getData().getRecords());
        }

        RestResponse<TtCustomerDto> restResponse = ttCustomerRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        TtCustomerDto dto = restResponse.getData();
        model.addAttribute("dto", dto);
        model.addAttribute("types", CustomerType.values());
        return "/teamticket/ttcustomer/edit";
    }

    @RequestMapping(value = "/update")
    public String update(TtCustomerDto dto, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        String[] cpids = request.getParameterValues("cpid");
        String[] productIds = request.getParameterValues("productId");
        String[] prices = request.getParameterValues("price");
        String[] sizes = request.getParameterValues("size");
        List<TtCustomerProductDto> productDtos = new ArrayList<>();
        if (productIds != null && productIds.length > 0) {
            for (int i = 0; i < productIds.length; i++) {
                TtCustomerProductDto productDto = new TtCustomerProductDto();
                if (StringUtils.isNotEmpty(cpids[i])) {
                    productDto.setId(Long.parseLong(cpids[i]));
                }
                productDto.setProductId(Long.parseLong(productIds[i]));
                productDto.setPrice(new BigDecimal(prices[i]));
                productDto.setSize(0);
                productDtos.add(productDto);
            }
        }
        dto.setArea(AreaUtils.getArea(request));
        dto.setProducts(productDtos);
        RestResponse<TtCustomerDto> restResponse = ttCustomerRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("noticeMsg", "操作成功");
        return "redirect:list.jhtml";
    }

    /**
     * 删除
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = ttCustomerRemoteService.deleteDto(getAccessToken(), id);
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
    @RequestMapping(value = "/deleteCustomerProduct")
    public Boolean deleteCustomerProduct(Long id) {
        try {
            RestResponse restResponse = ttCustomerProductRemoteService.deleteDto(getAccessToken(), id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            return Boolean.TRUE;
        } catch (Exception e) {
            return Boolean.FALSE;
        }
    }

    @RequestMapping(value = "/getProducts")
    public String getProducts(Long userId, TtProductDto dto, ModelMap model) {
        //通过员工ID查询所授权的产品信息
        if (userId == null || userId == -1) {
            userId = getCurrentUser().getId();
        }
        RestResponse<TtProductAuthorizaDto> PAdto1 = ttProductAuthorizaRemoteService.findByUserId(userId);
        //产品信息
        List<TtProductAuthorizaProductDto> PAPdto = PAdto1.getData().getProducts();
        List<TtProductDto> newdto = new ArrayList<>();
        if (PAPdto != null && PAPdto.size() > 0) {
            for (TtProductAuthorizaProductDto productDto : PAPdto) {
                TtProductDto newProduct = ttProductRemoteService.findById(productDto.getProductId()).getData();
                newProduct.setMarketPrice(productDto.getPrice());
                newProduct.setSales(productDto.getSize());
                newdto.add(newProduct);
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
        if (newdto != null && newdto.size() > 0) {
            for (TtProductDto productDto : newdto) {
                boolean ok = false;
                if (records != null && records.size() > 0) {
                    for (TtProductDto papDto : records) {
                        if (productDto.getId().equals(papDto.getId())) {
                            ok = true;
                            continue;
                        }
                    }
                }
                if (ok) {
                    newrecords.add(productDto);
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

        model.addAttribute("userId", userId);
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttcustomer/productlist";
    }

    /**
     * 清账
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/closeout")
    public String closeout(TtOrderDto dto, ModelMap model) {
        dto.setPaymentStatus(PaymentStatus.guazhang);
        dto.setOrderStatus(OrderStatus.audit);
        //查询已消费的订单
        dto.setTicketStatus(Boolean.TRUE);
        RestResponse<PageDto<TtOrderDto>> restResponse = ttOrderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttcustomer/closeout";
    }

    /**
     * 创建清帐账单
     *
     * @param model
     * @return
     */
    @RequestMapping("/createBill")
    public String createBill(Long[] ids, TtAccountingBillDto dto, ModelMap model) {
        // String[] ids = request.getParameterValues("ids");
        String a = getAccessToken();
        RestResponse<TtAccountingBillDto> restResponse = ttAccountingBillRemoteService.returnBill(getAccessToken(), dto, ids);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        String str = StringUtils.join(ids, ",");
        model.addAttribute("ids", str);
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/teamticket/ttcustomer/createbill";
    }

    /**
     * 结算绩效,保存账单
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/settlement")
    public JSONObject settlement(TtAccountingBillDto dto, HttpServletRequest request) {
        String strings = request.getParameter("ids");
        String[] ids = strings.split(",");
        JSONObject object = new JSONObject();
        RestResponse<TtAccountingBillDto> restResponse = ttAccountingBillRemoteService.createDto(getAccessToken(), dto, ids);
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
    public String billList(TtAccountingBillDto dto, ModelMap model) {
        RestResponse<PageDto<TtAccountingBillDto>> restResponse = ttAccountingBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/teamticket/ttcustomer/billlist";
    }

    @RequestMapping(value = "/viewBill")
    public String viewBill(TtOrderDto dto, ModelMap model) {
        RestResponse<PageDto<TtOrderDto>> restResponse = ttOrderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<TtAccountingBillDto> response = ttAccountingBillRemoteService.findBySn(dto.getAccountingBillSn());
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("bill", response.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/teamticket/ttcustomer/viewbill";
    }

    /**
     * 导出清帐账单
     *
     * @param response
     * @param dto
     */
    @ResponseBody
    @RequestMapping(value = "/exportBill")
    public void exportBill(HttpServletResponse response, TtAccountingBillDto dto) {
        RestResponse<PageDto<TtAccountingBillDto>> restResponse = ttAccountingBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<TtAccountingBillDto> billDtos = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("大客户清帐账单", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (TtAccountingBillDto accountingBillDto : billDtos) {
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
            ExcelUtils.export(collection, "大客户清帐账单", new String[]{"编号", "支出方式", "支出金额",
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
    public void export(HttpServletResponse response, TtOrderDto dto) {
        RestResponse<PageDto<TtOrderDto>> restResponse = ttOrderRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<TtAccountingBillDto> billResponse = ttAccountingBillRemoteService.findBySn(dto.getAccountingBillSn());
        if (!billResponse.success()) {
            throw new BusinessException(billResponse.getErrorMsg());
        }
        List<TtOrderDto> orderDtoList = restResponse.getData().getRecords();
        TtAccountingBillDto billDto = billResponse.getData();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("大客户清帐账单明细", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (TtOrderDto orderDto : orderDtoList) {
                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(orderDto.getCreateTime());
                Object[] objects = new Object[6];
                objects[0] = orderDto.getEnterpriseName();
                objects[1] = orderDto.getSn();
                objects[2] = date;
                objects[3] = date;
                objects[4] = orderDto.getTotalAmount();
                objects[5] = TaOfflinePayType.valueOf(billDto.getChannelNo()).getTitle();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "大客户清帐账单明细", new String[]{"客户名称", "订单编号",
                            "下单时间", "消费时间", "清帐金额", "清帐方式"},
                    new int[]{0, 1, 2, 3, 4, 5}, orderDtoList.size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
