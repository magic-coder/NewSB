package com.qmx.admin.controller.pcshop.ticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.shop.ticket.ProductRemoteService;
import com.qmx.admin.remoteapi.tickets.BookRuleRemoteService;
import com.qmx.admin.remoteapi.tickets.ConsumeRuleRemoteService;
import com.qmx.admin.remoteapi.tickets.RefundRuleRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.shop.api.dto.ticket.ProductDto;
import com.qmx.shop.api.dto.ticket.ProductPriceDto;
import com.qmx.shop.api.enumerate.common.PlatformTypeEnum;
import com.qmx.tickets.api.dto.SysBookRuleDTO;
import com.qmx.tickets.api.dto.SysConsumeRuleDTO;
import com.qmx.tickets.api.dto.SysRefundRuleDTO;
import com.qmx.tickets.api.dto.SysTicketsDTO;
import com.qmx.tickets.api.query.SysBookRuleVO;
import com.qmx.tickets.api.query.SysTicketsVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.Iterator;
import java.util.List;

@Controller("/pcticket/product")
@RequestMapping("/pcticket/product")
public class ProductController extends BaseController {
    @Autowired
    private ProductRemoteService productRemoteService;
    @Autowired
    private TicketsRemoteService ticketsRemoteService;
    @Autowired
    private ConsumeRuleRemoteService consumeRuleRemoteService;
    @Autowired
    private RefundRuleRemoteService refundRuleRemoteService;
    @Autowired
    private BookRuleRemoteService bookRuleRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(ProductDto dto, ModelMap model) {
        model.addAttribute("type", "grouplist");
        //设置查询微信端数据
        dto.setPlatformType(PlatformTypeEnum.PC);
        RestResponse<PageDto<ProductDto>> restResponse = productRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<ProductDto> list = restResponse.getData().getRecords();
        for (ProductDto productDto : list) {
            SysTicketsDTO ticketsDTO = ticketsRemoteService.findById(productDto.getOutId()).getData();
            if (ticketsDTO != null) {
                productDto.setMarketable(ticketsDTO.getMarketable());
            }
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/pcshop/ticket/product/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(Long groupId, ModelMap modelMap) {
        modelMap.addAttribute("groupId", groupId);
        return "/pcshop/ticket/product/addproduct";
    }

    @RequestMapping(value = "/getProducts")
    public String getProducts(SysTicketsVO dto, Long groupId, ModelMap model) {
        RestResponse<PageDto<SysTicketsDTO>> restResponse = ticketsRemoteService.findPage(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<SysTicketsDTO> list = restResponse.getData().getRecords();
        if (!list.isEmpty()) {
            Iterator iterator = list.iterator();
            while (iterator.hasNext()) {
                SysTicketsDTO sysTicketsDTO = (SysTicketsDTO) iterator.next();
                if (sysTicketsDTO.getMarketable()) {
                    RestResponse<SysUserDto> userDtoRest = sysUserRemoteService.findById(sysTicketsDTO.getCreateBy());
                    if (!userDtoRest.success()) {
                        throw new BusinessException(userDtoRest.getErrorMsg());
                    }
                    sysTicketsDTO.setCreateName(userDtoRest.getData().getAccount());
                } else {
                    iterator.remove();
                }
            }
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("groupId", groupId);
        return "/pcshop/ticket/product/productlist";
    }

    @RequestMapping(value = "/addProduct", method = RequestMethod.GET)
    public String addProduct(Long id, Long groupId, ModelMap model) {
        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //RestResponse<PageDto<SysBookRuleDTO>> bookResponse = bookRuleRemoteService.findPage(getAccessToken(), new SysBookRuleVO());
        model.addAttribute("product", restResponse.getData());
        model.addAttribute("groupId", groupId);
        return "/pcshop/ticket/product/addproduct";
    }

    @ResponseBody
    @RequestMapping(value = "/getBookRule", method = RequestMethod.POST)
    public JSONObject getBookRule(Long outId) {
        Assert.notNull(outId, "外部产品id不能为空");
        RestResponse<SysTicketsDTO> ticketsDTORest = ticketsRemoteService.findById(outId);
        if (!ticketsDTORest.success()) {
            throw new BusinessException(ticketsDTORest.getErrorMsg());
        }
        //预订规则
        RestResponse<SysBookRuleDTO> restResponse = bookRuleRemoteService.findById(ticketsDTORest.getData().getDefaultBookRuleId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //检票规则
        RestResponse<SysConsumeRuleDTO> consumeRuleDTORest = consumeRuleRemoteService.findById(ticketsDTORest.getData().getDefaultConsumeRuleId());
        if (!consumeRuleDTORest.success()) {
            throw new BusinessException(consumeRuleDTORest.getErrorMsg());
        }
        //退款规则
        RestResponse<SysRefundRuleDTO> refundRuleDTORest = refundRuleRemoteService.findById(ticketsDTORest.getData().getDefaultRefundRuleId());
        if (!refundRuleDTORest.success()) {
            throw new BusinessException(refundRuleDTORest.getErrorMsg());
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("bookingRules", restResponse.getData().getId().toString());
        jsonObject.put("bookingRemind", restResponse.getData().getRemind());
        jsonObject.put("bookings", restResponse.getData().getName());

        jsonObject.put("ticketRules", consumeRuleDTORest.getData().getId().toString());
        jsonObject.put("ticketRemind", consumeRuleDTORest.getData().getRemind());
        jsonObject.put("ticket", consumeRuleDTORest.getData().getName());

        jsonObject.put("refundRules", refundRuleDTORest.getData().getId().toString());
        jsonObject.put("refundRemind", refundRuleDTORest.getData().getRefundInfo());
        jsonObject.put("refund", refundRuleDTORest.getData().getName());
        return jsonObject;
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(ProductDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        Assert.notNull(dto.getOutId(), "外部产品id不能为空！");
        if (!dto.getPlayState()) {
            if (dto.getSalePrice().compareTo(BigDecimal.ZERO) == 0) {
                throw new BusinessException("销售金额不能为0");
            }
        }
        RestResponse<SysTicketsDTO> sysTicketsDTORest = ticketsRemoteService.findById(dto.getOutId());
        if (!sysTicketsDTORest.success()) {
            throw new BusinessException(sysTicketsDTORest.getErrorMsg());
        }
        dto.setSn(sysTicketsDTORest.getData().getSn());
        String datePriceData = request.getParameter("datePriceData");
        //设置为pc端数据
        dto.setPlatformType(PlatformTypeEnum.PC);
        RestResponse<ProductDto> restResponse = productRemoteService.createDto(getAccessToken(), dto, datePriceData);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:/pcticket/group/list.jhtml";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, ModelMap model) {
        RestResponse<ProductDto> restResponse = productRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        ProductDto dto = restResponse.getData();
        //查询门票名称
        dto.setOutName(ticketsRemoteService.findById(dto.getOutId()).getData().getName());
        //查询预订规则名称
        //  SysBookRuleDTO sysBookRuleDTO = bookRuleRemoteService.findById(getAccessToken(), 960443171920240641L).getData();
        dto.setBookingName(bookRuleRemoteService.findById(dto.getBookingRules()).getData().getName());
        //查询退款设置名称
        dto.setRefundName(refundRuleRemoteService.findById(dto.getRefundRules()).getData().getName());
        //查询检票规则名称
        dto.setTicketName(consumeRuleRemoteService.findById(dto.getTicketRules()).getData().getName());
        List<ProductPriceDto> list = restResponse.getData().getPrices();
        JSONObject obj = new JSONObject();
        if (!list.isEmpty()) {
            for (ProductPriceDto priceDto : list) {
                JSONObject json = new JSONObject();
                json.put("id", priceDto.getId() + "");
                json.put("sellPrice", priceDto.getSellPrice());
                json.put("suggestPrice", priceDto.getDayMaxStock());
                json.put("stock", priceDto.getMaxStock());
                obj.put(priceDto.getDate(), json);
            }
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("distribution", obj.toString());
        return "/pcshop/ticket/product/edit";
    }

    @RequestMapping(value = "/update")
    public String update(ProductDto dto, HttpServletRequest request) {
        if (!dto.getPlayState()) {
            if (dto.getSalePrice().compareTo(BigDecimal.ZERO) == 0) {
                throw new BusinessException("销售金额不能为0");
            }
        }
        String datePriceData = request.getParameter("datePriceData");
        RestResponse<ProductDto> restResponse = productRemoteService.updateDto(getAccessToken(), dto, datePriceData);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:/pcticket/group/list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public JSONObject delete(Long id) {
        JSONObject jsonObject = new JSONObject();
        RestResponse<Boolean> restResponse = productRemoteService.deleteDto(getAccessToken(), id);
        if (restResponse.success()) {
            jsonObject.put("data", "success");
        } else {
            jsonObject.put("data", restResponse.getErrorMsg());
        }
        return jsonObject;
    }

    /**
     * 更新产品状态
     *
     * @param id
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/updateStatus", method = RequestMethod.GET)
    public String updateStatus(Long id, RedirectAttributes redirectAttributes) {
        RestResponse<Boolean> restResponse = productRemoteService.updateDtoStatus(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "操作成功");
        return "redirect:/pcticket/group/list.jhtml";
    }
}
