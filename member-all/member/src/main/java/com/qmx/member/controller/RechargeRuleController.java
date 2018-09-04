package com.qmx.member.controller;

import com.baomidou.mybatisplus.plugins.Page;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.api.dto.RechargeRuleDto;
import com.qmx.member.api.enumerate.RuleType;
import com.qmx.member.model.RechargeRule;
import com.qmx.member.service.MemberLevelService;
import com.qmx.member.service.RechargeRuleService;
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
@RequestMapping("/rechargerule")
@Api(value = "会员等级充值规则", tags = "会员等级充值规则", description = "会员等级充值规则")
public class RechargeRuleController extends BaseController {
    @Autowired
    private RechargeRuleService rechargeRuleService;
    @Autowired
    private MemberLevelService memberLevelService;

    @ApiOperation(value = "获取列表", notes = "获取列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "RechargeRuleDto", paramType = "body", dataType = "RechargeRuleDto")
    })
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<RechargeRuleDto>> findList(@RequestParam("access_token") String access_token,
                                                           @RequestBody RechargeRuleDto dto) {
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

        List<RechargeRuleDto> list = new ArrayList<>();
        Page<RechargeRule> page = rechargeRuleService.query(params);
        for (RechargeRule record : page.getRecords()) {
            dto = new RechargeRuleDto();
            BeanUtils.copyProperties(record, dto);
            list.add(dto);
        }
        PageDto<RechargeRuleDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

    @ApiOperation(value = "创建", notes = "创建")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "RechargeRuleDto", paramType = "body", dataType = "RechargeRuleDto")
    })
    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<RechargeRuleDto> createDto(@RequestParam("access_token") String access_token,
                                                   @RequestBody RechargeRuleDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
//            List<RechargeRule> rs = rechargeRuleService.findByLevelId(dto.getLevelId());
//            if(rs != null && rs.size() > 0){
//                return RestResponse.fail("该规则重复");
//            }
            if (dto.getType() == RuleType.fixed) {
                dto.setMinAmount(null);
                dto.setMaxAmount(null);
            } else {
                dto.setAmount(null);
                if (dto.getMinAmount() > dto.getMaxAmount()) {
                    return RestResponse.fail("输入金额错误");
                }
            }
            List<RechargeRule> rules = rechargeRuleService.findRules(dto);
            if (rules == null || rules.size() != 0) {
                return RestResponse.fail("重复的充值规则");
            }
            RechargeRule model = new RechargeRule();
            BeanUtils.copyProperties(dto, model);
            SysUserDto userDto = getCurrentUser(access_token);

            model.setCreateBy(userDto.getId());
            model.setUpdateBy(userDto.getId());

            model = rechargeRuleService.save(model);
            return RestResponse.ok(model);
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.fail(e.getMessage());
        }
    }

    @ApiOperation(value = "更新", notes = "更新")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "RechargeRuleDto", paramType = "body", dataType = "RechargeRuleDto")
    })
    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<RechargeRuleDto> updateDto(@RequestParam("access_token") String access_token,
                                                   @RequestBody RechargeRuleDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            RechargeRule model = rechargeRuleService.find(dto.getId());
//            if (model.getLevelId().equals(dto.getLevelId())) {
//            } else {
//                List<RechargeRule> rs = rechargeRuleService.findByLevelId(dto.getLevelId());
//                if (rs != null && rs.size() != 0) {
//                    return RestResponse.fail("该规则重复");
//                }
//            }
            List<RechargeRule> rules = rechargeRuleService.findRules(dto);
            if (rules == null || rules.size() != 0) {
                return RestResponse.fail("重复的充值规则");
            }
            if (dto.getType() == RuleType.fixed) {
                dto.setMinAmount(null);
                dto.setMaxAmount(null);
            } else {
                dto.setAmount(null);
                if (dto.getMinAmount() > dto.getMaxAmount()) {
                    RestResponse.fail("输入金额错误");
                }
            }
//            if (dto.getGive() == GiveType.zhekou) {
//                dto.setMoneyPoint(null);
//            } else {
//                dto.setDiscountPoint(null);
//            }

            BeanUtils.copyProperties(dto, model, new String[]{"id", "enable"});
            SysUserDto userDto = getCurrentUser(access_token);
            model.setUpdateBy(userDto.getId());
            model = rechargeRuleService.update(model);
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
            rechargeRuleService.del(id, getCurrentId(access_token));
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
    public RestResponse<RechargeRuleDto> findById(@RequestParam("id") Long id) {
        RechargeRule model = rechargeRuleService.find(id);
        return RestResponse.ok(model);
    }
}
