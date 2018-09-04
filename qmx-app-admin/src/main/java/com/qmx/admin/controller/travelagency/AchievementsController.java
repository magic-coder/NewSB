package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.AchievementsRemoteService;
import com.qmx.admin.remoteapi.travelagency.ProductRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.travelagency.api.dto.AchievementsDto;
import com.qmx.travelagency.api.dto.ProductDto;
import com.qmx.travelagency.api.enumerate.AmountMoney;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller("/taAchievements")
@RequestMapping("/taAchievements")
public class AchievementsController extends BaseController {
    @Autowired
    private AchievementsRemoteService achievementsRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private ProductRemoteService productRemoteService;

    @RequestMapping(value = "/list")
    public String list(AchievementsDto dto, ModelMap model) {
        RestResponse<PageDto<AchievementsDto>> restResponse = achievementsRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/achievements/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        return "/travelagency/achievements/add";
    }

    @RequestMapping(value = "/getUser")
    public String getUser(UserQueryVo dto, ModelMap model) {
        dto.setUserType(SysUserType.employee);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/achievements/userlist";
    }

    @RequestMapping(value = "/getProducts")
    public String getProducts(ProductDto dto, ModelMap model) {
        RestResponse<PageDto<ProductDto>> restResponse = productRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/achievements/productlist";
    }

    @ResponseBody
    @RequestMapping(value = "/deleteProduct")
    public JSONObject deleteProduct(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = achievementsRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    @RequestMapping(value = "/save")
    public String save(AchievementsDto dto, HttpServletRequest request) {

        String[] productIds = request.getParameterValues("productIds");
        String[] types = request.getParameterValues("types");
        String[] numbers = request.getParameterValues("numbers");
        if (productIds == null || productIds.length < 0) {
            return "redirect:list.jhtml";
        }
        for (int i = 0; i < productIds.length; i++) {
            dto.setProductId(Long.parseLong(productIds[i]));
            if ("amount".equals(types[i])) {
                dto.setType(AmountMoney.amount);
            } else {
                dto.setType(AmountMoney.money);
            }
            dto.setNumber(Double.parseDouble(numbers[i]));
            RestResponse<AchievementsDto> restResponse = achievementsRemoteService.createDto(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<AchievementsDto> restResponse = achievementsRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/travelagency/achievements/edit";
    }

    @RequestMapping(value = "/update")
    public String update(AchievementsDto dto) {
        RestResponse<AchievementsDto> restResponse = achievementsRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = achievementsRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }
}
