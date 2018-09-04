package com.qmx.admin.controller.shop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.CategoryRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.shop.api.dto.commodity.CategoryDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by zcl on 2018/3/21.
 */

@Controller("/commodity/category")
@RequestMapping("/commodity/category")
public class CategoryController extends BaseController{
    @Autowired
    private CategoryRemoteService categoryRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping(value = "/list")
    public String findList(CategoryDto dto, ModelMap modelMap) {
        RestResponse<PageDto<CategoryDto>> restResponse = categoryRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/shop/commodity/category/list";
    }

    /**
     * 添加品类跳转页面
     *
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String addVariety( ModelMap modelMap) {
        return "/shop/commodity/category/add";
    }

    /**
     * 保存商品品类信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String saveVariety(CategoryDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        RestResponse<CategoryDto> restResponse = categoryRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:list";
    }

    /**
     * 根据ajax批量删除酒店基础信息
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public JSONObject deleteAll(Long id) {
        JSONObject json = new JSONObject();
        RestResponse<Boolean> restResponse = categoryRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("data", "error");
            json.put("msg", restResponse.getErrorMsg());
        } else {
            json.put("data", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    /**
     * 编辑
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, ModelMap modelMap){
        RestResponse<CategoryDto> restResponse=categoryRemoteService.findById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto",restResponse.getData());
        return "/shop/commodity/category/edit";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(CategoryDto dto){
        Assert.notNull(dto.getId(),"品类id不能为空！");
        RestResponse<CategoryDto> restResponse=categoryRemoteService.updateDto(getAccessToken(),dto);
        if(!restResponse.success()){
            throw  new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 获取普通供应商
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getSupplier", method = RequestMethod.POST)
    public Object getSupplier(Integer page, String q) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> rows = new ArrayList<>();
        UserQueryVo userQueryVo = new UserQueryVo();
        userQueryVo.setUserType(SysUserType.supplier);
        userQueryVo.setSupplierFlag(Boolean.FALSE);
        userQueryVo.setPageIndex(page);
        userQueryVo.setUsername(q);
        //userQueryVo.setGroupSupplierId(941911937119309826L);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        for (SysUserDto sysUserDto : restResponse.getData().getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", String.valueOf(sysUserDto.getId()));
            map.put("account", sysUserDto.getAccount());
            map.put("username", sysUserDto.getUsername());
            rows.add(map);
        }
        result.put("total", restResponse.getData().getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    /**
     * 获取特殊供应商
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getSpecialSupplier", method = RequestMethod.POST)
    public Object getSpecialSupplier(Integer page, String q) {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        UserQueryVo userQueryVo = new UserQueryVo();
        userQueryVo.setUserType(SysUserType.supplier);
        userQueryVo.setSupplierFlag(Boolean.TRUE);
        userQueryVo.setPageIndex(page);
        userQueryVo.setUsername(q);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        for (SysUserDto sysUserDto : restResponse.getData().getRecords()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", String.valueOf(sysUserDto.getId()));
            map.put("account", sysUserDto.getAccount());
            map.put("username", sysUserDto.getUsername());
            rows.add(map);
        }
        result.put("total", restResponse.getData().getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

}
