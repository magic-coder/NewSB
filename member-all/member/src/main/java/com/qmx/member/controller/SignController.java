package com.qmx.member.controller;

import com.qmx.base.api.dto.RestResponse;
import com.qmx.member.model.Sign;
import com.qmx.member.service.SignService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/sign")
@Api(value = "积分签到", tags = "积分签到", description = "积分签到")
public class SignController extends BaseController {
    @Autowired
    private SignService signService;

    @ApiOperation(value = "签到", notes = "签到")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "会员id", paramType = "body", dataType = "Long")
    })
    @RequestMapping(value = "/add")
    public RestResponse<Boolean> add(@RequestParam("id") Long id) {
        try {
            Assert.notNull(id,"用户数据异常");
            //查询今天有没有签到,有就不用签到
            Boolean flag = signService.findByMemberId(id);
            if(flag){
                return RestResponse.ok(Boolean.FALSE);
            }
            Sign model = new Sign();
            model.setMemberId(id);
            model.setIntegral(1);
            model.setTime(new Date());
            //查询昨天有没有签到,有记录就取连续签到数,没有就重置为0
            Integer ContinuousSign = signService.isContinuousSign(id);
            model.setContinuousSign(++ContinuousSign);
            signService.save(model);
            return RestResponse.ok(Boolean.TRUE);
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.ok(Boolean.FALSE);
        }
    }

//    @ApiOperation(value = "创建兑换", notes = "创建创建兑换")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
//            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
//    })
//    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
//    public RestResponse<ExchangeDto> createDto(@RequestParam("access_token") String access_token,
//                                             @RequestBody ExchangeDto dto) {
//        try {
//            Assert.notNull(dto, "数据不能为空");
//            Integer pastTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(dto.getExpiryTime()));
//            Integer startTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(new Date()));
//            if(pastTime-startTime <= 0){
//                return RestResponse.fail("请选择正确的过期时间");
//            }
//            Exchange model = new Exchange();
//            BeanUtils.copyProperties(dto, model);
//            SysUserDto userDto = getCurrentUser(access_token);
//            model.setCreateBy(userDto.getId());
//            model.setUpdateBy(userDto.getId());
//            model = exchangeService.save(model);
//            return RestResponse.ok(model);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return RestResponse.fail(e.getMessage());
//        }
//    }
//
//    @ApiOperation(value = "更新兑换", notes = "更新兑换")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
//            @ApiImplicitParam(name = "dto", value = "MemberDto", paramType = "body", dataType = "MemberDto")
//    })
//    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
//    public RestResponse<ExchangeDto> updateDto(@RequestParam("access_token") String access_token,
//                                             @RequestBody ExchangeDto dto) {
//        try {
//            Assert.notNull(dto, "数据不能为空");
//            Integer pastTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(dto.getExpiryTime()));
//            Integer startTime = new Integer(new SimpleDateFormat("yyyyMMdd").format(new Date()));
//            if(pastTime-startTime <= 0){
//                return RestResponse.fail("请选择正确的过期时间");
//            }
//            Exchange exchange = exchangeService.find(dto.getId());
//            BeanUtils.copyProperties(dto, exchange, new String[]{"id", "enable","state"});
//            SysUserDto userDto = getCurrentUser(access_token);
//            exchange.setUpdateBy(userDto.getId());
//            exchange = exchangeService.update(exchange);
//            return RestResponse.ok(exchange);
//        } catch (Exception e) {
//            return RestResponse.fail(e.getMessage());
//        }
//    }
//
//    @ApiOperation(value = "删除兑换", notes = "删除兑换")
//    @ApiImplicitParams({
//            @ApiImplicitParam(name = "access_token", value = "access_token", required = true, paramType = "query", dataType = "String"),
//            @ApiImplicitParam(name = "id", value = "id", required = true, paramType = "query", dataType = "Long")
//    })
//    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
//    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
//                                           @RequestParam("id") Long id) {
//        try {
//            exchangeService.del(id, getCurrentId(access_token));
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
//    public RestResponse<ExchangeDto> findById(@RequestParam("id") Long id) {
//        Exchange exchange = exchangeService.find(id);
//        return RestResponse.ok(exchange);
//    }
//
//    @Scheduled(cron = "0 0 1 * * ? ")
//    public void updateState(){
//        try {
//            exchangeService.updateState();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }


}
