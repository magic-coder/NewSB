package com.qmx.admin.controller.hotel;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.hotel.RefundInformRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.hotel.api.dto.RefundInformDto;
import com.qmx.hotel.api.enumerate.InformTypeEnum;
import com.qmx.hotel.api.enumerate.InformWayEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by earnest on 2017/12/6 0006.
 */
@Controller
@RequestMapping("/refundInform")
public class RefundInformController extends BaseController {
    @Autowired
    private RefundInformRemoteService refundInformRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    /**
     * 审核通知列表
     *
     * @param modelMap
     * @param dto
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(ModelMap modelMap, RefundInformDto dto) {
        RestResponse<PageDto<RefundInformDto>> restResponse = refundInformRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<RefundInformDto> list = restResponse.getData().getRecords();
        if (!list.isEmpty()) {
            for (RefundInformDto refundInformDto : list) {
                String[] strings;
                if (!StringUtils.isEmpty(refundInformDto.getInformWay())) {
                    strings = refundInformDto.getInformWay().split(",");
                    String str = "";
                    String way;
                    for (String string : strings) {
                        way = InformWayEnum.valueOf(string).getType();
                        str = str + way + ",";
                    }
                    str = str.substring(0, str.length() - 1);
                    refundInformDto.setInformWay(str);
                }

            }
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        modelMap.addAttribute("way", InformWayEnum.values());
        modelMap.addAttribute("type", InformTypeEnum.values());
        return "/hotel/refundinform/list";
    }

    /**
     * 添加审核通知跳转页面
     *
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap modelMap) {
        modelMap.addAttribute("way", InformWayEnum.values());
        modelMap.addAttribute("type", InformTypeEnum.values());
        return "/hotel/refundinform/add";
    }

    /**
     * 获取供应商的所有员工
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/listProductAuthorizeJson")
    public Object listProductAuthorizeJson() {
        // ProductCategory productCategory = productCategoryService.find(productCategoryId);
        //Brand brand = brandService.find(brandId);
        //List<Tag> tags = tagService.findList(tagId);
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
       /* Pageable pageable = new Pageable();
        pageable.setPageNumber(page);
        pageable.setPageSize(row);
        pageable.setSearchProperty("name");
        pageable.setSearchValue(q);
        Page<Product> list = productService.findPage(admin, productCategory, null, null, true, null, null, isGift, isOutOfStock, isStockAlert, ProductOrderTypeEnum.dateDesc, pageable);
        for (Product product : list.getContent()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", product.getId());
            map.put("name", product.getName() == null ? "" : product.getName());
            rows.add(map);
        }*/
//        PageDto<RefundInformDto> pageDto = new PageDto<>();
        UserQueryVo userQueryVo = new UserQueryVo();
        SysUserDto userDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (userDto.getUserType() == SysUserType.supplier) {
            userQueryVo.setUserType(SysUserType.employee);
        }
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

    /**
     * 保存审核通知信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(RefundInformDto dto, RedirectAttributes redirectAttributes) {
        RestResponse<RefundInformDto> restResponse = refundInformRemoteService.createRefundInform(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:list";
    }

    /**
     * 编辑审核通知信息
     *
     * @param modelMap
     * @param id
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(ModelMap modelMap, Long id) {
        RestResponse<RefundInformDto> restResponse = refundInformRemoteService.getRefundInformById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", restResponse.getData());
        modelMap.addAttribute("type", InformTypeEnum.values());
        modelMap.addAttribute("way", InformWayEnum.values());
        return "/hotel/refundinform/edit";
    }

    /**
     * 更新审核信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(RefundInformDto dto, RedirectAttributes redirectAttributes) {
        RestResponse<RefundInformDto> restResponse = refundInformRemoteService.updateRefundInform(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        return "redirect:list";
    }

    /**
     * 删除审核信息
     *
     * @param id
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id, RedirectAttributes redirectAttributes) {
        RestResponse restResponse = refundInformRemoteService.deleteRefundInform(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "删除成功");
        return "redirect:list";
    }

    /**
     * 根据ajax批量删除审核通知信息
     *
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/deleteAll")
    public JSONObject deleteAll(String ids) {
        JSONObject jsonObject = new JSONObject();
        try {
            String[] id = ids.split(",");
            for (String s : id) {
                refundInformRemoteService.deleteRefundInform(getAccessToken(), Long.parseLong(s));
                jsonObject.put("data", "1");
            }
        } catch (Exception e) {
            jsonObject.put("data", "2");
            e.printStackTrace();
        }
        return jsonObject;
    }

    /**
     * 查询审核通知信息
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/disPlay")
    public String disPlay(Long id, ModelMap modelMap) {
        Assert.notNull(id, "审核id不能为空");
        RestResponse<RefundInformDto> restResponse = refundInformRemoteService.getRefundInformById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", restResponse.getData());
        modelMap.addAttribute("type", InformTypeEnum.values());
        modelMap.addAttribute("way", InformWayEnum.values());
        return "/hotel/refundinform/disPlay";
    }
}
