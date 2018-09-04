package com.qmx.member.controller;

import com.baomidou.mybatisplus.plugins.Page;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.api.dto.MemberDto;
import com.qmx.member.api.enumerate.MemberSource;
import com.qmx.member.api.enumerate.MemberState;
import com.qmx.member.model.Member;
import com.qmx.member.model.MemberLevel;
import com.qmx.member.service.MemberLevelService;
import com.qmx.member.service.MemberService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/member")
@Api(value = "会员管理", tags = "会员管理", description = "会员管理")
public class MemberController extends BaseController {
    @Autowired
    private MemberService memberService;
    @Autowired
    private MemberLevelService memberLevelService;

    @ApiOperation(value = "获取列表", notes = "获取列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
    })
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<MemberDto>> findList(@RequestParam("access_token") String access_token,
                                                     @RequestBody MemberDto dto) {
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

        List<MemberDto> list = new ArrayList<>();
        Page<Member> page = memberService.query(params);
        for (Member record : page.getRecords()) {
            dto = new MemberDto();
            BeanUtils.copyProperties(record, dto);
            list.add(dto);
        }
        PageDto<MemberDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

    @ApiOperation(value = "创建", notes = "创建")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
    })
    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<MemberDto> createDto(@RequestParam("access_token") String access_token,
                                             @RequestBody MemberDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");

            Member model = new Member();
            BeanUtils.copyProperties(dto, model);
            SysUserDto userDto = getCurrentUser(access_token);

            model.setCreateBy(userDto.getId());
            model.setUpdateBy(userDto.getId());
            MemberLevel level = memberLevelService.find(dto.getLevelId());
            model.setLevelName(level.getName());
            if (dto.getSource() == null) {
                model.setSource(MemberSource.xsht);
            }
            if (dto.getIntegral() == null) {
                model.setIntegral(0.00);
            }
            if (dto.getMoney() == null) {
                model.setMoney(0.00);
            }
            if (dto.getCardNumber() != null && dto.getCardNumber() != "") {
                if (dto.getState() == null) {
                    model.setState(MemberState.normal);
                }
                model = memberService.save(model);
            } else {
                model.setState(MemberState.locking);
                model = memberService.save(model);
//                model.setCardNumber(model.getId().toString());
//                model.setState(MemberState.normal);
//                model = memberService.update(model);
            }
            return RestResponse.ok(model);
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.fail(e.getMessage());
        }
    }

    @ApiOperation(value = "更新", notes = "更新")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
    })
    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<MemberDto> updateDto(@RequestParam("access_token") String access_token,
                                             @RequestBody MemberDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            Member member = memberService.find(dto.getId());
            BeanUtils.copyProperties(dto, member, new String[]{"id", "enable"});
            SysUserDto userDto = getCurrentUser(access_token);
            MemberLevel level = memberLevelService.find(dto.getLevelId());
            member.setLevelName(level.getName());
            member.setUpdateBy(userDto.getId());
            member = memberService.update(member);
            return RestResponse.ok(member);
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
            memberService.del(id, getCurrentId(access_token));
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
    public RestResponse<MemberDto> findById(@RequestParam("id") Long id) {
        Member member = memberService.find(id);
        return RestResponse.ok(member);
    }

    //自动检查会员过期时间,过期会更新会员过期状态
//    @Scheduled(fixedRate = 1000 * 60 * 120)
    @Scheduled(cron = "0 0 1 * * ? ")
    public void updateState(){
        try {
            memberService.updateState();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
