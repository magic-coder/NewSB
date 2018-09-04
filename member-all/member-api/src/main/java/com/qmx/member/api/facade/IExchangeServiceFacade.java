package com.qmx.member.api.facade;

import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.member.api.dto.ExchangeDto;
import com.qmx.member.api.dto.MemberDto;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.BeanUtils;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RequestMapping("/exchange")
public interface IExchangeServiceFacade {
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<ExchangeDto>> findList(@RequestBody ExchangeDto dto);


    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<ExchangeDto> createDto(@RequestParam("access_token") String access_token,
                                               @RequestBody ExchangeDto dto);

    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<ExchangeDto> updateDto(@RequestParam("access_token") String access_token,
                                               @RequestBody ExchangeDto dto);


    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
                                           @RequestParam("id") Long id);


    @RequestMapping(value = "/findById", method = RequestMethod.POST)
    public RestResponse<ExchangeDto> findById(@RequestParam("id") Long id);
}
