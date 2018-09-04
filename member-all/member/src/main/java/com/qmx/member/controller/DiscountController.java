package com.qmx.member.controller;

import com.baomidou.mybatisplus.plugins.Page;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.api.dto.AssociatedDto;
import com.qmx.member.api.dto.DiscountDto;
import com.qmx.member.api.enumerate.ProductType;
import com.qmx.member.model.Associated;
import com.qmx.member.model.Discount;
import com.qmx.member.model.MemberLevel;
import com.qmx.member.service.AssociatedService;
import com.qmx.member.service.DiscountService;
import com.qmx.member.service.MemberLevelService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/discount")
@Api(value = "会员优惠规则", tags = "会员优惠规则", description = "会员优惠规则")
public class DiscountController extends BaseController {
    @Autowired
    private MemberLevelService memberLevelService;
    @Autowired
    private DiscountService discountService;
    @Autowired
    private AssociatedService associatedService;

    @ApiOperation(value = "获取列表", notes = "获取列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "ConsumptionDto", paramType = "body", dataType = "ConsumptionDto")
    })
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<DiscountDto>> findList(@RequestParam("access_token") String access_token,
                                                       @RequestBody DiscountDto dto) {
        Map<String, Object> params = InstanceUtil.transBean2StringMap(dto);
        SysUserDto userDto = getCurrentUser(access_token);
        if (userDto.getUserType() == SysUserType.employee) {
            params.put("memberId", userDto.getId());
        } else if (userDto.getUserType() == SysUserType.group_supplier) {
            params.put("groupSupplierId", userDto.getId());
        } else if (userDto.getUserType() == SysUserType.supplier) {
            params.put("supplierId", userDto.getId());
        } else if (userDto.getUserType() == SysUserType.admin) {

        } else {
            params.put("memberId", userDto.getId());
        }

        List<DiscountDto> list = new ArrayList<>();
        Page<Discount> page = discountService.query(params);
        for (Discount record : page.getRecords()) {
            dto = new DiscountDto();
            BeanUtils.copyProperties(record, dto);
            list.add(dto);
        }
        PageDto<DiscountDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

    @ApiOperation(value = "创建", notes = "创建")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "ConsumptionDto", paramType = "body", dataType = "ConsumptionDto")
    })
    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<DiscountDto> createDto(@RequestParam("access_token") String access_token,
                                               @RequestBody DiscountDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            Discount discount = discountService.findByLevelId(dto.getLevelId());
            if (discount != null) {
                return RestResponse.fail("重复的优惠规则");
            }
            Discount model = new Discount();
            BeanUtils.copyProperties(dto, model);
            SysUserDto userDto = getCurrentUser(access_token);

            model.setCreateBy(userDto.getId());
            model.setUpdateBy(userDto.getId());
            model = discountService.saveAll(model, dto);
            return RestResponse.ok(model);
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.fail(e.getMessage());
        }
    }

    @ApiOperation(value = "更新", notes = "更新")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberLevelDto", paramType = "body", dataType = "MemberLevelDto")
    })
    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<DiscountDto> updateDto(@RequestParam("access_token") String access_token,
                                               @RequestBody DiscountDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            Discount model = discountService.find(dto.getId());
            if (model.getLevelId().equals(dto.getLevelId())) {
            } else {
                Discount dd = discountService.findByLevelId(dto.getLevelId());
                if (dd != null) {
                    return RestResponse.fail("重复的优惠规则");
                }
            }
            BeanUtils.copyProperties(dto, model, new String[]{"id", "enable"});
            SysUserDto userDto = getCurrentUser(access_token);
            model.setUpdateBy(userDto.getId());
            model = discountService.updateAll(model, dto);
            return RestResponse.ok(model);
        } catch (Exception e) {
            return RestResponse.fail(e.getMessage());
        }
    }

    @ApiOperation(value = "删除", notes = "删除")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "id", value = "id", required = true, paramType = "query", dataType = "Long")
    })
    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
                                           @RequestParam("id") Long id) {
        try {
            discountService.del(id, getCurrentId(access_token));
            return RestResponse.ok(Boolean.TRUE);
        } catch (Exception e) {
            return RestResponse.fail(e.getMessage());
        }
    }

    @ApiOperation(value = "根据ID查询", notes = "根据ID查询")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "id", required = true, paramType = "query", dataType = "Long")
    })
    @RequestMapping(value = "/findById", method = RequestMethod.POST)
    public RestResponse<DiscountDto> findById(@RequestParam("id") Long id) {
        Discount model = discountService.find(id);
        DiscountDto discountDto = new DiscountDto();
        BeanUtils.copyProperties(model, discountDto);
        AssociatedDto dto;
        List<Associated> menpiao = associatedService.findByConsumptionId(id, ProductType.menpiao);
        HashMap<ProductType, List<AssociatedDto>> productTypeListHashMap = new HashMap<>();
        List<AssociatedDto> mps = new ArrayList<>();
        if (menpiao != null && menpiao.size() != 0) {
            for (Associated associated : menpiao) {
                dto = new AssociatedDto();
                BeanUtils.copyProperties(associated, dto);
                mps.add(dto);
            }
            productTypeListHashMap.put(ProductType.menpiao, mps);
        }
        List<Associated> shangpin = associatedService.findByConsumptionId(id, ProductType.shangpin);
        if (shangpin != null && shangpin.size() != 0) {
            List<AssociatedDto> sps = new ArrayList<>();
            for (Associated associated : shangpin) {
                dto = new AssociatedDto();
                BeanUtils.copyProperties(associated, dto);
                sps.add(dto);
            }
            productTypeListHashMap.put(ProductType.shangpin, sps);
        }
        discountDto.setMap(productTypeListHashMap);
        return RestResponse.ok(discountDto);
    }

    @ApiOperation(value = "根据所有等级", notes = "根据所有等级")
    @RequestMapping(value = "/findAll", method = RequestMethod.POST)
    public RestResponse<List<MemberLevel>> findAll() {
        List<MemberLevel> listL = memberLevelService.findAll();
        return RestResponse.ok(listL);
    }
}
