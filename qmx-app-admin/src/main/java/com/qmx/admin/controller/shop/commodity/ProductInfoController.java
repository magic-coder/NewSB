package com.qmx.admin.controller.shop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.commodity.CategoryRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.GroupRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.ProductInfoRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.StorageRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.shop.api.dto.commodity.CategoryDto;
import com.qmx.shop.api.dto.commodity.GroupDto;
import com.qmx.shop.api.dto.commodity.ProductInfoDto;
import com.qmx.shop.api.dto.commodity.StorageDto;
import com.qmx.shop.api.enumerate.commodity.CommodityOperationTypeEnum;
import com.qmx.shop.api.enumerate.commodity.CommodityTypEnum;
import com.qmx.shop.api.enumerate.common.PlatformTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/4 11:47
 */
@Controller("/commodity/info")
@RequestMapping("/commodity/info")
public class ProductInfoController extends BaseController {
    @Autowired
    private ProductInfoRemoteService productInfoRemoteService;
    @Autowired
    private CategoryRemoteService categoryRemoteService;
    @Autowired
    private StorageRemoteService storageRemoteService;

    /**
     * 获取商品基础信息列表
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(ProductInfoDto dto, ModelMap modelMap) {
        RestResponse<PageDto<ProductInfoDto>> restResponse = productInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //查询所有的商品品类
        RestResponse<List<CategoryDto>> response = categoryRemoteService.findAll(getAccessToken());
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        modelMap.addAttribute("category", response.getData());
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        modelMap.addAttribute("type", CommodityTypEnum.values());
        return "/shop/commodity/info/list";
    }

    /**
     * 添加商品基础信息跳转页面
     *
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(ModelMap modelMap, Long id,GroupDto dto) {
        Assert.notNull(id,"系统异常，请重试!");
        modelMap.addAttribute("cid", id);
        return "/shop/commodity/info/add";
    }

    /**
     * 保存商品基础信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(ProductInfoDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        dto.setPlaceOrigin(getArea(request));
        RestResponse<ProductInfoDto> restResponse = productInfoRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:/commodity/category/list";
    }


    /**
     * 编辑商品信息页面
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, ModelMap modelMap) {
        RestResponse<ProductInfoDto> restResponse = productInfoRemoteService.getById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        restResponse.getData().setPlaceOrigin(restResponse.getData().getPlaceOrigin().replaceAll("\"", "\'"));
        modelMap.addAttribute("dto", restResponse.getData());
        return "/shop/commodity/info/edit";
    }

    /**
     * 更新商品基础信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(ProductInfoDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        dto.setPlaceOrigin(getArea(request));
        RestResponse<ProductInfoDto> restResponse = productInfoRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        return "redirect:/commodity/category/list";
    }

    public static String getArea(HttpServletRequest request) {
        String province = request.getParameter("province");
        String city = request.getParameter("city");
        String area = request.getParameter("county");
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("county", area);
        jsonObject.put("city", city);
        jsonObject.put("province", province);
        String place = jsonObject.toJSONString();
        return place;
    }

    /**
     * 根据ajax删除商品基础信息
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = productInfoRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "error");
            json.put("msg", restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    /**
     * 添加品类跳转页面
     *
     * @return
     */
    @RequestMapping(value = "/addVariety", method = RequestMethod.GET)
    public String addVariety(Long sid, ModelMap modelMap) {
        modelMap.addAttribute("sid", sid);
        return "/shop/commodity/info/addvariety";
    }



    /**
     * 查看商品基础信息
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/disPlay", method = RequestMethod.GET)
    public String disPlay(Long id, ModelMap modelMap) {
        RestResponse<ProductInfoDto> restResponse = productInfoRemoteService.getById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", restResponse.getData());
        modelMap.addAttribute("type", CommodityTypEnum.values());
        modelMap.addAttribute("operationType", CommodityOperationTypeEnum.values());
        return "/shop/commodity/info/display";
    }

}