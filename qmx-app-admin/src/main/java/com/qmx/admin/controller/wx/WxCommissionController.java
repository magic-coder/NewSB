package com.qmx.admin.controller.wx;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.ticket.ProductRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxCommissionConfigRemoteService;
import com.qmx.admin.remoteapi.wx.WxCommissionProductRemoteService;
import com.qmx.admin.remoteapi.wx.WxCommissionRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.shop.api.dto.ticket.ProductDto;
import com.qmx.wxbasics.api.dto.WxAuthorizationDto;
import com.qmx.wxbasics.api.dto.WxCommissionConfigDto;
import com.qmx.wxbasics.api.dto.WxCommissionDto;
import com.qmx.wxbasics.api.dto.WxCommissionProductDto;
import com.qmx.wxbasics.api.enumerate.CommissionType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

@Controller
@RequestMapping("/wxCommission")
public class WxCommissionController extends BaseController {
    @Autowired
    private WxCommissionRemoteService commissionRemoteService;
    @Autowired
    private WxCommissionConfigRemoteService configRemoteService;
    @Autowired
    private WxCommissionProductRemoteService productRemoteService;

    @Autowired
    private ProductRemoteService shopProductRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    /**
     * 佣金记录
     */
    @RequestMapping(value = "/list")
    public String list(WxCommissionDto dto, ModelMap model) {
        model.addAttribute("type", "list");

        RestResponse<PageDto<WxCommissionDto>> restResponse = commissionRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxcommission/list";
    }

    /**
     * 佣金概要
     */
    @RequestMapping(value = "/info")
    public String info(WxCommissionDto dto, ModelMap model) {
        model.addAttribute("type", "info");
        RestResponse<PageDto<Map>> restResponse = commissionRemoteService.getInfo(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxcommission/info";
    }

    /**
     * 结算查询
     */
    @RequestMapping(value = "/query")
    public String query(WxCommissionDto dto, String stime, String etime, ModelMap model) {
        model.addAttribute("type", "query");
        if (stime == null) {
            Date date = new Date();//当前日期
            Calendar calendar = Calendar.getInstance();//日历对象
            calendar.setTime(date);//设置当前日期
            calendar.add(Calendar.MONTH, -1);//月份减一
            stime = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());
        }
        if (etime == null) {
            etime = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        RestResponse<PageDto<Map>> restResponse = commissionRemoteService.getquery(getAccessToken(), stime, etime, dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxcommission/query";
    }

    /**
     * 佣金设置
     */
    @RequestMapping(value = "/product")
    public String product(WxCommissionProductDto dto, ModelMap model) {
        model.addAttribute("type", "product");
        RestResponse<PageDto<WxCommissionProductDto>> restResponse = productRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxcommission/product";
    }

    @RequestMapping(value = "/addproduct")
    public String addproduct(Long id, ModelMap model) {
        if (id != null) {
            RestResponse<WxCommissionProductDto> restResponse = productRemoteService.findById(id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            Long productId = restResponse.getData().getProductId();
            ProductDto product = new ProductDto();
            if (productId != null) {
                product = shopProductRemoteService.findById(productId).getData();
            }
            WxCommissionProductDto pDto = restResponse.getData();
            pDto.setProductName(product.getName());

            model.addAttribute("dto", pDto);
        } else {
            model.addAttribute("dto", new WxCommissionProductDto());
        }
        model.addAttribute("types", CommissionType.values());
        return "/wx/wxcommission/addproduct";
    }

    /*不用删除，裂变分销需要获取商城门票数据*/
    @RequestMapping(value = "/productlist")
    public String productlist(ProductDto dto, ModelMap model) {
        try {
            RestResponse<PageDto<ProductDto>> restResponse = shopProductRemoteService.findList(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            model.addAttribute("dto", dto);
            model.addAttribute("page", restResponse.getData());
        } catch (Exception e) {
            model.addAttribute("dto", dto);
            model.addAttribute("page", new PageDto<>());
        }
        return "/wx/wxcommission/productlist";
    }

    /**
     * 查询是否该产品是否有规则
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/checkProductId", method = RequestMethod.POST)
    public JSONObject checkProductId(WxCommissionProductDto dto) {
        JSONObject json = new JSONObject();
        SysUserDto userDto = getCurrentUser();
        WxAuthorizationDto authorizationDto = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData();
        WxCommissionProductDto productDto = null;
        if (dto.getId() != null) {
            productDto = productRemoteService.findByProductid(authorizationDto.getId(), dto.getProductId(), dto.getId()).getData();
        } else {
            productDto = productRemoteService.findByProductid(authorizationDto.getId(), dto.getProductId(), null).getData();
        }
        if (productDto == null) {
            RestResponse<WxCommissionProductDto> restResponse = null;
            if (dto.getId() != null) {
                restResponse = productRemoteService.updateDto(getAccessToken(), dto);
            } else {
                restResponse = productRemoteService.createDto(getAccessToken(), dto);
            }
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            json.put("type", "success");
            json.put("content", "成功");
        } else {
            json.put("type", "error");
            json.put("content", "该产品已存在规则！");
        }
        return json;
    }


    @ResponseBody
    @RequestMapping(value = "/deleteproduct")
    public JSONObject deleteproduct(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = productRemoteService.deleteDto(getAccessToken(), id);
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
     * 分销设置
     */
    @RequestMapping(value = "/config")
    public String config(ModelMap model) {
        model.addAttribute("type", "config");
        WxCommissionConfigDto configDto = configRemoteService.findBy(getAccessToken()).getData();
        if (configDto == null) {
            configDto = new WxCommissionConfigDto();
        }
        model.addAttribute("dto", configDto);
        return "/wx/wxcommission/config";
    }

    @RequestMapping(value = "/saveconfig")
    public String saveconfig(WxCommissionConfigDto configDto, ModelMap model, RedirectAttributes redirectAttributes) {
        try {
            configRemoteService.createDto(getAccessToken(), configDto);
            redirectAttributes.addFlashAttribute("noticeMsg", "操作成功");
            return "redirect:config";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("noticeMsg", "操作失败");
            return "redirect:config";
        }
    }
}
