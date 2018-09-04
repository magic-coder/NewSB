package com.qmx.admin.controller.shop.qrcode;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.shop.qrcode.ProductRemoteService;
import com.qmx.admin.remoteapi.tickets.DistributionRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.shop.api.dto.qrcode.ProductDto;
import com.qmx.tickets.api.dto.SysDistributionDTO;
import com.qmx.tickets.api.dto.SysTicketsDTO;
import com.qmx.tickets.api.query.SysTicketsVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

@Controller("/qrcode/product")
@RequestMapping("/qrcode/product")
public class ProductController extends BaseController {
    @Autowired
    private ProductRemoteService productRemoteService;
    @Autowired
    private TicketsRemoteService ticketsRemoteService;
    @Autowired
    private DistributionRemoteService distributionRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Value("${com.qmx.app.siteUrl}")
    private String url;

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(ProductDto dto, ModelMap model) {
        model.addAttribute("type", "grouplist");
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
        return "/shop/qrcode/product/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(Long groupId, ModelMap modelMap) {
        modelMap.addAttribute("groupId", groupId);
        return "/shop/qrcode/product/addproduct";
    }

    @RequestMapping(value = "/getProducts")
    public String getProducts(SysTicketsVO dto, Long groupId, ModelMap model) {
        RestResponse<PageDto<SysTicketsDTO>> restResponse = distributionRemoteService.findPageForDistribution(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<SysTicketsDTO> list = restResponse.getData().getRecords();
        if (null != list && !list.isEmpty()) {
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
        return "/shop/qrcode/product/productlist";
    }

    @ResponseBody
    @RequestMapping(value = "/addProduct", method = RequestMethod.GET)
    public JSONObject addProduct(Long id) {
        SysUserDto sysUserDto = getCurrentUser();
        JSONObject jsonObject = new JSONObject();
        RestResponse<SysTicketsDTO> sysTicketsDTORest = ticketsRemoteService.findById(id);
        if (!sysTicketsDTORest.success()) {
            throw new BusinessException(sysTicketsDTORest.getErrorMsg());
        }
        SysTicketsDTO sysTicketsDTO = sysTicketsDTORest.getData();

        if (!org.springframework.util.StringUtils.isEmpty(sysTicketsDTO.getLimitQrPrice()) && sysTicketsDTO.getLimitQrPrice()) {
            jsonObject.put("price", sysTicketsDTO.getQrPrice());
        }
        RestResponse<SysDistributionDTO> restResponse = distributionRemoteService.findDistribution(getAccessToken(), sysUserDto.getId(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysDistributionDTO distributionDTO = restResponse.getData();
        jsonObject.put("outId", distributionDTO.getId().toString());
        jsonObject.put("outName", distributionDTO.getName());
        return jsonObject;
    }


    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(ProductDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        Assert.notNull(dto.getOutId(), "外部分销产品id为空");
        SysDistributionDTO distribution = distributionRemoteService.findById(dto.getOutId()).getData();
        if (distribution == null) {
            throw new BusinessException("授权异常");
        }
        RestResponse<SysTicketsDTO> sysTicketsDTORest = ticketsRemoteService.findById(distribution.getProductId());
        if (!sysTicketsDTORest.success() || sysTicketsDTORest.getData() == null) {
            throw new BusinessException(sysTicketsDTORest.getErrorMsg());
        }
        //市场价
        dto.setMarketPrice(sysTicketsDTORest.getData().getMarketPrice());
        RestResponse<ProductDto> restResponse = productRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:/qrcode/group/list.jhtml";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, ModelMap model) {
        RestResponse<ProductDto> restResponse = productRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        ProductDto dto = restResponse.getData();
        if (dto == null) {
            throw new BusinessException("产品ID错误");
        }
        SysDistributionDTO distribution = distributionRemoteService.findById(dto.getOutId()).getData();
        if (distribution == null) {
            throw new BusinessException("授权异常");
        }

        //查询门票名称
        dto.setOutName(distribution.getName());
        //判断门票
        RestResponse<SysTicketsDTO> sysTicketsDTORest = ticketsRemoteService.findById(distribution.getProductId());
        if (!sysTicketsDTORest.success()) {
            throw new BusinessException(sysTicketsDTORest.getErrorMsg());
        }
        SysTicketsDTO sysTicketsDTO = sysTicketsDTORest.getData();
        if (sysTicketsDTO == null) {
            throw new BusinessException("未查询到门票产品");
        }
        if (sysTicketsDTO.getLimitQrPrice() != null && sysTicketsDTO.getLimitQrPrice()) {
            model.addAttribute("priceFlag", Boolean.TRUE);
        } else {
            model.addAttribute("priceFlag", Boolean.FALSE);
        }

        model.addAttribute("dto", restResponse.getData());
        return "/shop/qrcode/product/edit";
    }

    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public String view(Long id, ModelMap model) {
        RestResponse<ProductDto> restResponse = productRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        ProductDto productDto = restResponse.getData();
        //生成产品链接
        productDto.setProductUrl(url + "/shop/qrcode/index/index?productId=" + productDto.getId() + "&userId=" + productDto.getMemberId());
        //生成产品二维码链接
        if (productDto.getProductUrl() != null) {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            QRCodeUtil.encode(productDto.getProductUrl(), 400, 400, out);
            byte[] tempbyte = out.toByteArray();
            String base64Url = Base64Util.encodeToString(tempbyte);
            //model.addAttribute("codeUrl", "data:image/png;base64," + base64Url);
            productDto.setQrcodeUrl("data:image/png;base64," + base64Url);
        }
        model.addAttribute("dto", restResponse.getData());
        return "/shop/qrcode/product/view";
    }

    @RequestMapping(value = "/update")
    public String update(ProductDto dto) {
        RestResponse<ProductDto> restResponse = productRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:/qrcode/group/list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject jsonObject = new JSONObject();
        RestResponse restResponse = productRemoteService.deleteDto(getAccessToken(), id);
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
        return "redirect:/qrcode/group/list.jhtml";
    }
}
