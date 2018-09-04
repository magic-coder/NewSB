package com.qmx.member.controller;

import com.baomidou.mybatisplus.plugins.Page;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.api.dto.MemberLevelDto;
import com.qmx.member.model.MemberLevel;
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
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/memberLevel")
@Api(value = "会员等级管理", tags = "会员等级管理", description = "会员等级管理")
public class MemberLevelController extends BaseController {
    @Autowired
    private MemberLevelService memberLevelService;

    @ApiOperation(value = "获取列表", notes = "获取列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberLevelDto", paramType = "body", dataType = "MemberLevelDto")
    })
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<MemberLevelDto>> findList(@RequestParam("access_token") String access_token,
                                                          @RequestBody MemberLevelDto dto) {
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

        List<MemberLevelDto> list = new ArrayList<>();
        Page<MemberLevel> page = memberLevelService.query(params);
        for (MemberLevel record : page.getRecords()) {
            dto = new MemberLevelDto();
            BeanUtils.copyProperties(record, dto);
            list.add(dto);
        }
        PageDto<MemberLevelDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

    @ApiOperation(value = "创建", notes = "创建")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberLevelDto", paramType = "body", dataType = "MemberLevelDto")
    })
    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<MemberLevelDto> createDto(@RequestParam("access_token") String access_token,
                                                  @RequestBody MemberLevelDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            MemberLevel memberLevel = memberLevelService.findByName(dto.getName());
            if (memberLevel != null) {
                return RestResponse.fail("重复的等级");
            }
            if(!dto.getLevelLock()){
                dto.setUpgradeId(null);
            }
            MemberLevel model = new MemberLevel();
            BeanUtils.copyProperties(dto, model);
            SysUserDto userDto = getCurrentUser(access_token);

            model.setCreateBy(userDto.getId());
            model.setUpdateBy(userDto.getId());

            model = memberLevelService.save(model);
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
    public RestResponse<MemberLevelDto> updateDto(@RequestParam("access_token") String access_token,
                                                  @RequestBody MemberLevelDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            MemberLevel model = memberLevelService.find(dto.getId());
            if (model.getName().equals(dto.getName())) {
            } else {
                MemberLevel memberLevel = memberLevelService.findByName(dto.getName());
                if (memberLevel != null) {
                    return RestResponse.fail("重复的等级");
                }
            }
            if(!dto.getLevelLock()){
                dto.setUpgradeId(null);
            }
            BeanUtils.copyProperties(dto, model, new String[]{"id", "enable"});
            SysUserDto userDto = getCurrentUser(access_token);
            model.setUpdateBy(userDto.getId());
            model = memberLevelService.update(model);
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
//            memberLevelService.del(id, getCurrentId(access_token));
            memberLevelService.delAll(id,getCurrentId(access_token));
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
    public RestResponse<MemberLevelDto> findById(@RequestParam("id") Long id) {
        MemberLevel model = memberLevelService.find(id);
        return RestResponse.ok(model);
    }

    @ApiOperation(value = "根据所有等级", notes = "根据所有等级")
    @RequestMapping(value = "/findAll", method = RequestMethod.POST)
    public RestResponse<List<MemberLevel>> findAll() {
        List<MemberLevel> listL = memberLevelService.findAll();
        return RestResponse.ok(listL);
    }

    @ApiOperation(value = "根据等级名字查询", notes = "根据等级名字查询")
    @RequestMapping(value = "/findByName", method = RequestMethod.POST)
    public RestResponse<MemberLevelDto> findByName(@RequestParam("levelName") String levelName) {
        MemberLevel memberLevel = memberLevelService.findByName(levelName);
        if(memberLevel == null){
            return RestResponse.ok(null);
        }
        MemberLevelDto dto = new MemberLevelDto();
        BeanUtils.copyProperties(memberLevel, dto);
        return RestResponse.ok(dto);
    }
}
