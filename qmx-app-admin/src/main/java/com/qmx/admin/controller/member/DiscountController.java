package com.qmx.admin.controller.member;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.member.DiscountRemoteService;
import com.qmx.admin.remoteapi.member.MemberLevelRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.ReleaseRemoteService;
import com.qmx.admin.remoteapi.shop.ticket.ProductRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.member.api.dto.AssociatedDto;
import com.qmx.member.api.dto.DiscountDto;
import com.qmx.member.api.dto.MemberLevelDto;
import com.qmx.member.api.enumerate.ProductType;
import com.qmx.shop.api.dto.commodity.ReleaseDto;
import com.qmx.shop.api.dto.ticket.ProductDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/discount")
public class DiscountController extends BaseController {
    @Autowired
    private DiscountRemoteService discountRemoteService;
    @Autowired
    private MemberLevelRemoteService memberLevelRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private ProductRemoteService shopProductRemoteService;
    @Autowired
    private ReleaseRemoteService releaseRemoteService;

    @RequestMapping(value = "/list")
    public String list(DiscountDto dto, ModelMap model) {
        RestResponse<PageDto<DiscountDto>> restResponse = discountRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<MemberLevelDto>> LevelDtos = memberLevelRemoteService.findAll();
        model.addAttribute("listL", LevelDtos.getData());
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/member/Discount/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        RestResponse<List<MemberLevelDto>> restResponse = memberLevelRemoteService.findAll();
        model.addAttribute("listL", restResponse.getData());
        return "/member/Discount/add";
    }

    //添加门票
    @RequestMapping(value = "productlist")
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
        return "/member/Discount/productlist";
    }
    //添加商品
    @RequestMapping(value = "/releaselist", method = RequestMethod.GET)
    public String releaselist(ReleaseDto dto, ModelMap modelMap) {
        RestResponse<PageDto<ReleaseDto>> restResponse = releaseRemoteService.findList(getAccessToken(), dto);
//        RestResponse<List<CategoryDto>> categoryRest = categoryRemoteService.findAll(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
//        if (!categoryRest.success()) {
//            throw new BusinessException(categoryRest.getErrorMsg());
//        }
        modelMap.addAttribute("dto", dto);
//        modelMap.addAttribute("commodityCategoryDto", categoryRest.getData());
        modelMap.addAttribute("page", restResponse.getData());
//        modelMap.addAttribute("groupId", dto.getGroupId());
        return "/member/Discount/releaselist";
    }

    @RequestMapping(value = "/save")
    public String save(DiscountDto dto, HttpServletRequest request) {
        RestResponse<DiscountDto> restResponse = discountRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<DiscountDto> restResponse = discountRemoteService.findById(id);
        RestResponse<List<MemberLevelDto>> listL = memberLevelRemoteService.findAll();
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        DiscountDto dto = restResponse.getData();
        HashMap<ProductType, List<AssociatedDto>> map = dto.getMap();
        List<AssociatedDto> menpiao = map.get(ProductType.menpiao);
        List<AssociatedDto> shangpin = map.get(ProductType.shangpin);
        model.addAttribute("menpiao", menpiao);
        model.addAttribute("shangpin", shangpin);
        model.addAttribute("dto", dto);
        model.addAttribute("listL", listL.getData());
        return "/member/Discount/edit";
    }

    @RequestMapping(value = "/update")
    public String update(DiscountDto dto, HttpServletRequest request) {
        RestResponse<DiscountDto> restResponse = discountRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = discountRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
