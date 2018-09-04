package com.qmx.member.controller;

import com.baomidou.mybatisplus.plugins.Page;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.api.dto.ExchangeDto;
import com.qmx.member.api.dto.MemberDto;
import com.qmx.member.api.enumerate.MemberSource;
import com.qmx.member.api.enumerate.MemberState;
import com.qmx.member.model.Exchange;
import com.qmx.member.model.Member;
import com.qmx.member.model.MemberLevel;
import com.qmx.member.service.ExchangeService;
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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/exchange")
@Api(value = "会员兑换管理", tags = "会员兑换管理", description = "会员兑换管理")
public class ExchangeController extends BaseController {
    @Autowired
    private ExchangeService exchangeService;

    @ApiOperation(value = "获取兑换列表", notes = "获取兑换列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
    })
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<ExchangeDto>> findList(@RequestBody ExchangeDto dto) {
        Map<String, Object> params = InstanceUtil.transBean2StringMap(dto);
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
        List<ExchangeDto> list = new ArrayList<>();
        Page<Exchange> page = exchangeService.query(params);
        for (Exchange exchange : page.getRecords()) {
            dto = new ExchangeDto();
            BeanUtils.copyProperties(exchange, dto);
            list.add(dto);
        }
        PageDto<ExchangeDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

    @ApiOperation(value = "创建兑换", notes = "创建创建兑换")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
    })
    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<ExchangeDto> createDto(@RequestParam("access_token") String access_token,
                                             @RequestBody ExchangeDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            Integer pastTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(dto.getExpiryTime()));
            Integer startTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(new Date()));
            if(pastTime-startTime <= 0){
                return RestResponse.fail("请选择正确的过期时间");
            }
            Exchange model = new Exchange();
            BeanUtils.copyProperties(dto, model);
            SysUserDto userDto = getCurrentUser(access_token);
            model.setCreateBy(userDto.getId());
            model.setUpdateBy(userDto.getId());
            model = exchangeService.save(model);
            return RestResponse.ok(model);
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.fail(e.getMessage());
        }
    }

    @ApiOperation(value = "更新兑换", notes = "更新兑换")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
    })
    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<ExchangeDto> updateDto(@RequestParam("access_token") String access_token,
                                             @RequestBody ExchangeDto dto) {
        try {
            Assert.notNull(dto, "数据不能为空");
            Integer pastTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(dto.getExpiryTime()));
            Integer startTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(new Date()));
            if(pastTime-startTime <= 0){
                return RestResponse.fail("请选择正确的过期时间");
            }
            Exchange exchange = exchangeService.find(dto.getId());
            BeanUtils.copyProperties(dto, exchange, new String[]{"id", "enable","state"});
            SysUserDto userDto = getCurrentUser(access_token);
            exchange.setUpdateBy(userDto.getId());
            exchange = exchangeService.update(exchange);
            return RestResponse.ok(exchange);
        } catch (Exception e) {
            return RestResponse.fail(e.getMessage());
        }
    }

    @ApiOperation(value = "删除兑换", notes = "删除兑换")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "id", value = "id", required = true, paramType = "query", dataType = "Long")
    })
    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
                                           @RequestParam("id") Long id) {
        try {
            exchangeService.del(id, getCurrentId(access_token));
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
    public RestResponse<ExchangeDto> findById(@RequestParam("id") Long id) {
        Exchange exchange = exchangeService.find(id);
        return RestResponse.ok(exchange);
    }

    @Scheduled(cron = "0 0 1 * * ? ")
    public void updateState(){
        try {
            exchangeService.updateState();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
