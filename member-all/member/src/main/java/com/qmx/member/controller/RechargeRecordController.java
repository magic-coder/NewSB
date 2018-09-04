package com.qmx.member.controller;

import com.baomidou.mybatisplus.plugins.Page;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.member.api.dto.MemberIntegeralDto;
import com.qmx.member.api.dto.MemberMoneyDto;
import com.qmx.member.model.MemberIntegeral;
import com.qmx.member.model.MemberMoney;
import com.qmx.member.service.MemberIntegeralService;
import com.qmx.member.service.MemberMoneyService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/rechargerecord")
@Api(value = "会员充值记录管理", tags = "会员充值记录管理", description = "会员充值记录管理")
public class RechargeRecordController extends BaseController {
    @Autowired
    private MemberMoneyService memberMoneyService;
    @Autowired
    private MemberIntegeralService memberIntegeralService ;

    @ApiOperation(value = "获取金额列表", notes = "获取金额列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "dto", value = "dto", paramType = "MemberMoneyDto", dataType = "MemberMoneyDto")
    })
    @RequestMapping(value = "/memberMoneyList", method = RequestMethod.POST)
    public RestResponse<PageDto<MemberMoneyDto>> memberMoneyList(@RequestBody MemberMoneyDto dto) {
        Assert.notNull(dto.getMemberId(), "获得用户信息失败");
        Map<String, Object> params = InstanceUtil.transBean2StringMap(dto);
        List<MemberMoneyDto> list = new ArrayList<>();
        Page<MemberMoney> page = memberMoneyService.query(params);
        for (MemberMoney memberMoney : page.getRecords()) {
            dto = new MemberMoneyDto();
            BeanUtils.copyProperties(memberMoney, dto);
            list.add(dto);
        }
        PageDto<MemberMoneyDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

    @ApiOperation(value = "获取积分列表", notes = "获取积分列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "dto", value = "dto", paramType = "MemberIntegeralDto", dataType = "MemberIntegeralDto")
    })
    @RequestMapping(value = "/memberIntegeralList", method = RequestMethod.POST)
    public RestResponse<PageDto<MemberIntegeralDto>> memberIntegeralList(@RequestBody MemberIntegeralDto dto) {
        Assert.notNull(dto.getMemberId(), "获得用户信息失败");
        Map<String, Object> params = InstanceUtil.transBean2StringMap(dto);
        List<MemberIntegeralDto> list = new ArrayList<>();
        Page<MemberIntegeral> page = memberIntegeralService.query(params);
        for (MemberIntegeral memberIntegeral : page.getRecords()) {
            dto = new MemberIntegeralDto();
            BeanUtils.copyProperties(memberIntegeral, dto);
            list.add(dto);
        }
        PageDto<MemberIntegeralDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

//    @ApiOperation(value = "获取列表", notes = "获取列表")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
//            @ApiImplicitParam(name = "dto", value = "RechargeRecordDto", paramType = "body", dataType = "RechargeRecordDto")
//    })
//    @RequestMapping(value = "/findList", method = RequestMethod.POST)
//    public RestResponse<PageDto<RechargeRecordDto>> findList(@RequestParam("access_token") String access_token,
//                                                             @RequestBody RechargeRecordDto dto) {
//        Map<String, Object> params = InstanceUtil.transBean2StringMap(dto);
//        SysUserDto userDto = getCurrentUser(access_token);
//        if (userDto.getUserType() == SysUserType.employee) {
//            params.put("memberId", userDto.getId());
//        } else if (userDto.getUserType() == SysUserType.group_supplier) {
//            params.put("groupSupplierId", userDto.getId());
//        } else if (userDto.getUserType() == SysUserType.supplier) {
//            params.put("supplierId", userDto.getId());
//        } else if (userDto.getUserType() == SysUserType.admin) {
//
//        } else {
//            params.put("memberId", userDto.getId());
//        }
//
//        List<RechargeRecordDto> list = new ArrayList<>();
//        Page<RechargeRecord> page = rechargeRecordService.query(params);
//        for (RechargeRecord record : page.getRecords()) {
//            dto = new RechargeRecordDto();
//            BeanUtils.copyProperties(record, dto);
//            list.add(dto);
//        }
//        PageDto<RechargeRecordDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
//        return RestResponse.ok(pageDto);
//    }
//
//    @ApiOperation(value = "创建", notes = "创建")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
//            @ApiImplicitParam(name = "dto", value = "RechargeRecordDto", paramType = "body", dataType = "RechargeRecordDto")
//    })
//    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
//    public RestResponse<RechargeRecordDto> createDto(@RequestParam("access_token") String access_token,
//                                                     @RequestBody RechargeRecordDto dto) {
//        try {
//            Assert.notNull(dto, "数据不能为空");
//
//            RechargeRecord model = new RechargeRecord();
//            BeanUtils.copyProperties(dto, model);
//            SysUserDto userDto = getCurrentUser(access_token);
//
//            model.setCreateBy(userDto.getId());
//            model.setUpdateBy(userDto.getId());
//
//            model = rechargeRecordService.save(model);
//            return RestResponse.ok(model);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return RestResponse.fail(e.getMessage());
//        }
//    }
//
//    @ApiOperation(value = "更新", notes = "更新")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
//            @ApiImplicitParam(name = "dto", value = "RechargeRecordDto", paramType = "body", dataType = "RechargeRecordDto")
//    })
//    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
//    public RestResponse<RechargeRecordDto> updateDto(@RequestParam("access_token") String access_token,
//                                                     @RequestBody RechargeRecordDto dto) {
//        try {
//            Assert.notNull(dto, "数据不能为空");
//            RechargeRecord model = rechargeRecordService.find(dto.getId());
//            BeanUtils.copyProperties(dto, model, new String[]{"id", "enable"});
//            SysUserDto userDto = getCurrentUser(access_token);
//            model.setUpdateBy(userDto.getId());
//            model = rechargeRecordService.update(model);
//            return RestResponse.ok(model);
//        } catch (Exception e) {
//            return RestResponse.fail(e.getMessage());
//        }
//    }
//
//    @ApiOperation(value = "删除", notes = "删除")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
//            @ApiImplicitParam(name = "id", value = "id", required = true, paramType = "query", dataType = "Long")
//    })
//    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
//    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
//                                           @RequestParam("id") Long id) {
//        try {
//            rechargeRecordService.del(id, getCurrentId(access_token));
//            return RestResponse.ok(Boolean.TRUE);
//        } catch (Exception e) {
//            return RestResponse.fail(e.getMessage());
//        }
//    }
//
//    @ApiOperation(value = "根据ID查询", notes = "根据ID查询")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "id", value = "id", required = true, paramType = "query", dataType = "Long")
//    })
//    @RequestMapping(value = "/findById", method = RequestMethod.POST)
//    public RestResponse<RechargeRuleDto> findById(@RequestParam("id") Long id) {
//        RechargeRecord model = rechargeRecordService.find(id);
//        return RestResponse.ok(model);
//    }
}
