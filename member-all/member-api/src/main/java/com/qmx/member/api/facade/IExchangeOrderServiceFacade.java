package com.qmx.member.api.facade;

import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.member.api.dto.ExchangeDto;
import com.qmx.member.api.dto.ExchangeOrderDto;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@RequestMapping("/exchangeOrder")
public interface IExchangeOrderServiceFacade {
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<ExchangeOrderDto>> findList(@RequestBody ExchangeOrderDto dto);

    @RequestMapping(value = "/updateStateType", method = RequestMethod.POST)
    public RestResponse updateStateType(@RequestBody ExchangeOrderDto dto);

}
