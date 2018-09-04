package com.qmx.member.controller;

import com.baomidou.mybatisplus.plugins.Page;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.api.dto.ExchangeDto;
import com.qmx.member.api.dto.ExchangeOrderDto;
import com.qmx.member.model.Exchange;
import com.qmx.member.model.ExchangeOrder;
import com.qmx.member.service.ExchangeOrderService;
import com.qmx.member.service.ExchangeService;
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
@RequestMapping("/exchangeOrder")
@Api(value = "会员兑换记录", tags = "会员兑换记录", description = "会员兑换记录")
public class ExchangeOrderController extends BaseController {
    @Autowired
    private ExchangeOrderService exchangeOrderService;

    @ApiOperation(value = "会员兑换记录列表", notes = "会员兑换记录列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
            @ApiImplicitParam(name = "dto", value = "ExchangeOrderDto", paramType = "body", dataType = "ExchangeOrderDto")
    })
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<ExchangeOrderDto>> findList(@RequestBody ExchangeOrderDto dto) {
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
        List<ExchangeOrderDto> list = new ArrayList<>();
        Page<ExchangeOrder> page = exchangeOrderService.query(params);
        for (ExchangeOrder exchangeOrder : page.getRecords()) {
            dto = new ExchangeOrderDto();
            BeanUtils.copyProperties(exchangeOrder, dto);
            list.add(dto);
        }
        PageDto<ExchangeOrderDto> pageDto = new PageDto<>(page.getTotal(), page.getSize(), page.getCurrent(), list);
        return RestResponse.ok(pageDto);
    }

    @ApiOperation(value = "更新订单发货状态", notes = "更新订单发货状态")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "dto", value = "ExchangeOrderDto", paramType = "body", dataType = "ExchangeOrderDto")
    })
    @RequestMapping(value = "/updateStateType", method = RequestMethod.POST)
    public RestResponse updateStateType(@RequestBody ExchangeOrderDto dto) {

        try {
            Assert.notNull(dto.getId(), "订单获取失败");
            Boolean state = exchangeOrderService.updateStateType(dto.getId());
            if (state) {
                return RestResponse.ok();
            } else {
                return RestResponse.fail("提交失败");
            }
        } catch (Exception e) {
            return RestResponse.fail("提交失败");
        }
    }


}
