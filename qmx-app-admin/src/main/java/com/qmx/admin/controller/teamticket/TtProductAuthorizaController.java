package com.qmx.admin.controller.teamticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtProductAuthorizaRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtProductRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.teamticket.api.dto.TtProductAuthorizaDto;
import com.qmx.teamticket.api.dto.TtProductAuthorizaProductDto;
import com.qmx.teamticket.api.dto.TtProductDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/ttproductauthoriza")
public class TtProductAuthorizaController extends BaseController {
    @Autowired
    private TtProductAuthorizaRemoteService authorizaRemoteService;
    @Autowired
    private TtProductRemoteService ttProductRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping(value = "/list")
    public String list(TtProductAuthorizaDto dto, ModelMap model) {
        RestResponse<PageDto<TtProductAuthorizaDto>> restResponse = authorizaRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductauthoriza/list";
    }

    @RequestMapping(value = "/add")
    public String add() {
        return "/teamticket/ttproductauthoriza/add";
    }

    @RequestMapping(value = "/getUsers", method = {RequestMethod.GET, RequestMethod.POST})
    public String getUsers(UserQueryVo dto, ModelMap model) {
        dto.setUserType(SysUserType.employee);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), dto);
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductauthoriza/userlist";
    }

    @RequestMapping(value = "/getProducts")
    public String getProducts(TtProductDto dto, ModelMap model) {
        dto.setMarketable(Boolean.TRUE);
        RestResponse<PageDto<TtProductDto>> restResponse = ttProductRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductauthoriza/productlist";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<TtProductAuthorizaDto> restResponse = authorizaRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/teamticket/ttproductauthoriza/edit";
    }

    @RequestMapping(value = "/save")
    public String save(TtProductAuthorizaDto dto, HttpServletRequest request) {
        String[] productIds = request.getParameterValues("productId");
        String[] prices = request.getParameterValues("price");
        String[] sizes = request.getParameterValues("size");
        List<TtProductAuthorizaProductDto> productDtos = new ArrayList<>();
        try {
            if ((productIds != null && prices != null && sizes != null)) {
                for (int i = 0; i < productIds.length; i++) {
                    TtProductAuthorizaProductDto productDto = new TtProductAuthorizaProductDto();
                    productDto.setProductId(Long.parseLong(productIds[i]));
                    productDto.setPrice(new BigDecimal(prices[i]));
                    productDto.setSize(Integer.parseInt(sizes[i]));
                    productDtos.add(productDto);
                }
            }
        } catch (Exception e) {
            throw new BusinessException("数据异常,请重新输入");
        }
        dto.setProducts(productDtos);

        RestResponse<TtProductAuthorizaDto> restResponse = authorizaRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(TtProductAuthorizaDto dto, HttpServletRequest request) {
        String[] aids = request.getParameterValues("aid");
        String[] productIds = request.getParameterValues("productId");
        String[] prices = request.getParameterValues("price");
        String[] sizes = request.getParameterValues("size");
        List<TtProductAuthorizaProductDto> productDtos = new ArrayList<>();
        try {
            if ((productIds != null && prices != null && sizes != null)) {
                for (int i = 0; i < productIds.length; i++) {
                    TtProductAuthorizaProductDto productDto = new TtProductAuthorizaProductDto();
                    if (StringUtils.isNotEmpty(aids[i])) {
                        productDto.setId(Long.parseLong(aids[i]));
                    }
                    productDto.setProductId(Long.parseLong(productIds[i]));
                    productDto.setPrice(new BigDecimal(prices[i]));
                    productDto.setSize(Integer.parseInt(sizes[i]));
                    productDtos.add(productDto);
                }
            }
        } catch (Exception e) {
            throw new BusinessException("数据异常,请重新输入");
        }
        dto.setProducts(productDtos);

        RestResponse<TtProductAuthorizaDto> restResponse = authorizaRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    /**
     * 删除
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = authorizaRemoteService.deleteDto(getAccessToken(), id);
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
    @RequestMapping(value = "/deleteAuthorizaProduct")
    public Boolean deleteCustomerProduct(Long id) {
        try {
            RestResponse restResponse = authorizaRemoteService.deleteAuthorizaProduct(getAccessToken(), id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            return Boolean.TRUE;
        } catch (Exception e) {
            return Boolean.FALSE;
        }
    }
}
