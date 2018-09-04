package com.qmx.admin.controller.shop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.commodity.CategoryRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.GroupRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.ProductInfoRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.shop.api.dto.commodity.GroupDto;
import com.qmx.shop.api.dto.commodity.ProductInfoDto;
import com.qmx.shop.api.dto.commodity.ReleaseDto;
import com.qmx.shop.api.enumerate.common.PlatformTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @Author: Zhubiyuan
 * @Date: 2018/1/8  11:01
 */
@Controller("/commodity/group")
@RequestMapping("/commodity/group")
public class GroupController extends BaseController {
    @Autowired
    private GroupRemoteService groupRemoteService;
    @Autowired
    private ProductInfoRemoteService productInfoRemoteService;
    @Value("${com.qmx.app.siteUrl}")
    private String url;

    /**
     * 获取商品分组列表
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(GroupDto dto, ModelMap modelMap, HttpServletRequest request) {
        modelMap.addAttribute("type", "grouplist");
        dto.setPlatformType(PlatformTypeEnum.WEI_XIN);
        RestResponse<PageDto<GroupDto>> restResponse = groupRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        PageDto<GroupDto> pageDto = restResponse.getData();
        if (null != pageDto.getRecords() && !pageDto.getRecords().isEmpty()) {
            //商城链接
            modelMap.addAttribute("shopUrl", url + "/commodity/index/getIndex?userId=" + pageDto.getRecords().get(0).getMemberId());
            for (GroupDto groupDto : pageDto.getRecords()) {
                //组链接
                groupDto.setGroupUrl(url + "/commodity/index/getProductById?groupId=" + groupDto.getId() + "&userId=" + groupDto.getMemberId());
                if (null != groupDto.getReleaseDtos() && !groupDto.getReleaseDtos().isEmpty()) {
                    //商品链接
                    for (ReleaseDto releaseDto : groupDto.getReleaseDtos()) {
                        releaseDto.setReleaseUrl(url + "/commodity/index/getProductById?releaseId=" + releaseDto.getId() + "&userId=" + releaseDto.getMemberId());
                    }
                }
            }
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/shop/commodity/group/list";
    }

    /**
     * 添加商品分组跳转页面
     *
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add() {
        return "/shop/commodity/group/add";
    }

    /**
     * 保存商品分组
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(GroupDto dto, RedirectAttributes redirectAttributes) {
        dto.setPlatformType(PlatformTypeEnum.WEI_XIN);
        RestResponse<GroupDto> restResponse = groupRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:list";
    }

    /**
     * 编辑商品分组
     *
     * @param id
     * @param ModelMap
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, ModelMap ModelMap) {
        RestResponse<GroupDto> restResponse = groupRemoteService.getById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        ModelMap.addAttribute("dto", restResponse.getData());
        return "/shop/commodity/group/edit";
    }

    /**
     * 更新商品分组信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(GroupDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        RestResponse<GroupDto> restResponse = groupRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        return "redirect:list";
    }


    /**
     * 根据ajax批量删除商品分组信息
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public JSONObject delete(Long id) {
        JSONObject jsonObject = new JSONObject();
        RestResponse<Boolean> restResponse = groupRemoteService.deleteDto(getAccessToken(), id);
        if (restResponse.success()) {
            jsonObject.put("data", "success");
        } else {
            jsonObject.put("data", restResponse.getErrorMsg());
        }
        return jsonObject;
    }

    /**
     * 根据品类id获取商品
     *
     * @param categoryId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getInfoById", method = RequestMethod.GET)
    public JSONObject getInfoById(Long categoryId) {
        RestResponse<List<ProductInfoDto>> restResponse = productInfoRemoteService.getByCId(getAccessToken(), categoryId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        Map<String, Object> map = new HashMap<>();
        if (null != restResponse.getData() && !restResponse.getData().isEmpty()) {
            for (ProductInfoDto dto : restResponse.getData()) {
                map.put(String.valueOf(dto.getId()), dto.getName());
            }
        }
        JSONObject object = new JSONObject();
        object.put("commodityInfo", map);
        return object;
    }
}

