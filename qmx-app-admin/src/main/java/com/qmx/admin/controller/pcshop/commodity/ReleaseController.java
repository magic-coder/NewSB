package com.qmx.admin.controller.pcshop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.CategoryRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.GroupRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.ReleaseRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.shop.api.dto.commodity.*;
import com.qmx.shop.api.enumerate.commodity.CommodityReleaseTypeEnum;
import com.qmx.shop.api.enumerate.common.PlatformTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
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
 * @Date: 2018/1/10  14:56
 */
@Controller("/pccommodity/release")
@RequestMapping("/pccommodity/release")
public class ReleaseController extends BaseController {

    @Autowired
    private ReleaseRemoteService releaseRemoteService;
    @Autowired
    private CategoryRemoteService categoryRemoteService;
    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;

    /**
     * 商品发布列表
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(ReleaseDto dto, ModelMap modelMap) {
        RestResponse<PageDto<ReleaseDto>> restResponse = releaseRemoteService.findList(getAccessToken(), dto);
        RestResponse<List<CategoryDto>> categoryRest = categoryRemoteService.findAll(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        if (!categoryRest.success()) {
            throw new BusinessException(categoryRest.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("commodityCategoryDto", categoryRest.getData());
        modelMap.addAttribute("page", restResponse.getData());
        modelMap.addAttribute("groupId", dto.getGroupId());
        return "/pcshop/commodity/release/list";
    }


    /**
     * 设置商品发布
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/addRelease", method = RequestMethod.GET)
    public String addRelease(ProductInfoDto dto, ModelMap modelMap,HttpServletRequest request) {
        RestResponse<List<CategoryDto>> restResponse = categoryRemoteService.findAll(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto sysUserDto = getCurrentMember();
        SmsTemplateQueryVo templateQueryVo = new SmsTemplateQueryVo();
        templateQueryVo.setPageSize(100);
        RestResponse<PageDto<SmsTemplateDto>> smsTemplateResponse = null;
        templateQueryVo.setModuleId(getCurrentModuleId(request));
        if(sysUserDto.getUserType() == SysUserType.supplier){
            smsTemplateResponse = smsTemplateRemoteService.findSupplierAuthPage(getAccessToken(),templateQueryVo);
        }else{
            smsTemplateResponse = smsTemplateRemoteService.findPage(getAccessToken(), templateQueryVo);
        }
        if (!smsTemplateResponse.success()) {
            throw new BusinessException(smsTemplateResponse.getErrorMsg());
        }
        PageDto<SmsTemplateDto> pageDto = smsTemplateResponse.getData();
        modelMap.addAttribute("smsTemplates", pageDto.getRecords());
        modelMap.addAttribute("dto", restResponse.getData());
        modelMap.addAttribute("groupId", dto.getGroupId());
        return "/pcshop/commodity/release/addrelease";
    }

    /**
     * 保存商品发布信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/saveRelease", method = RequestMethod.POST)
    public String saveRelease(ReleaseDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        //获取图片集合
        List<ImageDto> imageList = ImageDto.getImageList(request);
        dto.setImageDtos(imageList);
        dto.setPlatformType(PlatformTypeEnum.PC);
        RestResponse<ReleaseDto> restResponse = releaseRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:/pccommodity/group/list";
    }

    /**
     * 编辑商品发布信息
     *
     * @param id
     * @param modelMap
     * @param groupId
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, Long groupId, ModelMap modelMap,HttpServletRequest request) {
        RestResponse<ReleaseDto> restResponse = releaseRemoteService.release(getAccessToken(), id);
        RestResponse<CategoryDto> categoryDtoRest=categoryRemoteService.findById(getAccessToken(),restResponse.getData().getCatogaryId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        if (!categoryDtoRest.success()) {
            throw new BusinessException(categoryDtoRest.getErrorMsg());
        }
        SysUserDto sysUserDto = getCurrentMember();
        SmsTemplateQueryVo templateQueryVo = new SmsTemplateQueryVo();
        templateQueryVo.setPageSize(100);
        templateQueryVo.setModuleId(getCurrentModuleId(request));
        RestResponse<PageDto<SmsTemplateDto>> smsTemplateResponse = null;
        if(sysUserDto.getUserType() == SysUserType.supplier){
            smsTemplateResponse = smsTemplateRemoteService.findSupplierAuthPage(getAccessToken(),templateQueryVo);
        }else{
            smsTemplateResponse = smsTemplateRemoteService.findPage(getAccessToken(), templateQueryVo);
        }
        if (!smsTemplateResponse.success()) {
            throw new BusinessException(smsTemplateResponse.getErrorMsg());
        }
        PageDto<SmsTemplateDto> pageDto = smsTemplateResponse.getData();
        request.setAttribute("smsTemplates", pageDto.getRecords());
        modelMap.addAttribute("dto", restResponse.getData());
        modelMap.addAttribute("categoryDto", categoryDtoRest.getData());
        return "/pcshop/commodity/release/edit";
    }

    /**
     * 更新商品发布信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(ReleaseDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        //获取图片集合
        List<ImageDto> imageList = ImageDto.getImageList(request);
        dto.setImageDtos(imageList);
        RestResponse<ReleaseDto> restResponse = releaseRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        //return "redirect:list?groupId=" + Long.parseLong(request.getParameter("groupId"));
        return "redirect:/pccommodity/group/list";
    }

    /**
     * 根据品类id获取所有商品
     *
     * @param categoryId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/findCommodity", method = RequestMethod.GET)
    public JSONObject findCommodity(Long categoryId) {
        RestResponse<List<ProductInfoDto>> restResponse = releaseRemoteService.getSaleByCategory(getAccessToken(), categoryId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        Map<String, Object> map = new HashMap<>();
        if (!restResponse.getData().isEmpty()) {
            for (ProductInfoDto dto : restResponse.getData()) {
                map.put(String.valueOf(dto.getId()), dto.getName());
            }
        }
        JSONObject object = new JSONObject();
        object.put("dto", map);
        return object;
    }

    /**
     * 商品上下架
     *
     * @param releaseId
     * @param groupId
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/soldPutAway", method = RequestMethod.GET)
    public String soldPutAway(Long releaseId, Long groupId, RedirectAttributes redirectAttributes) {
        RestResponse<ReleaseDto> restResponse = releaseRemoteService.soldOutPutAway(getAccessToken(), releaseId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "操作成功");
        return "redirect:/pccommodity/group/list?groupId=" + groupId;
    }

    /**
     * 获取该商品未发布的剩余库存
     *
     * @param cid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getNotReleaseStock", method = RequestMethod.GET)
    public JSONObject getNotReleaseStock(Long cid) {
        RestResponse<Long> restResponse = releaseRemoteService.getNotReleaseStockByCid(getAccessToken(), cid);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONObject object = new JSONObject();
        object.put("stock", restResponse.getData());
        return object;
    }

    /**
     * 获取该发布信息的日志信息
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/logList", method = RequestMethod.GET)
    public String logList(ReleaseLogDto dto, ModelMap modelMap) {
        RestResponse<PageDto<ReleaseLogDto>> restResponse = releaseRemoteService.findLogList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("page", restResponse.getData());
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("type", CommodityReleaseTypeEnum.values());
        return "/pcshop/commodity/release/loglist";
    }

    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public JSONObject delete(Long id) {
        JSONObject jsonObject = new JSONObject();
        RestResponse<Boolean> restResponse = releaseRemoteService.deleteDto(getAccessToken(), id);
        if (restResponse.success()) {
            jsonObject.put("data", "success");
        } else {
            jsonObject.put("data", restResponse.getErrorMsg());
        }
        return jsonObject;
    }
}
