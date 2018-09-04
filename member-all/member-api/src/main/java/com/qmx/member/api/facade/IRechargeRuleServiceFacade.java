package com.qmx.member.api.facade;

import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.member.api.dto.RechargeRuleDto;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@RequestMapping("/rechargerule")
public interface IRechargeRuleServiceFacade {
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<RechargeRuleDto>> findList(@RequestParam("access_token") String access_token,
                                                           @RequestBody RechargeRuleDto dto);

    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<RechargeRuleDto> createDto(@RequestParam("access_token") String access_token,
                                                   @RequestBody RechargeRuleDto dto);

    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<RechargeRuleDto> updateDto(@RequestParam("access_token") String access_token,
                                                   @RequestBody RechargeRuleDto dto);

    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
                                           @RequestParam("id") Long id);

    @RequestMapping(value = "/findById", method = RequestMethod.POST)
    public RestResponse<RechargeRuleDto> findById(@RequestParam("id") Long id);
}
