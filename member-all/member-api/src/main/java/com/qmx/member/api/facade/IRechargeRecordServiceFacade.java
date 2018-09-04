package com.qmx.member.api.facade;

import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.member.api.dto.MemberIntegeralDto;
import com.qmx.member.api.dto.MemberMoneyDto;
import com.qmx.member.api.dto.RechargeRecordDto;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@RequestMapping("/rechargerecord")
public interface IRechargeRecordServiceFacade {
    @RequestMapping(value = "/memberMoneyList", method = RequestMethod.POST)
    public RestResponse<PageDto<MemberMoneyDto>> memberMoneyList(@RequestBody MemberMoneyDto dto);

    @RequestMapping(value = "/memberIntegeralList", method = RequestMethod.POST)
    public RestResponse<PageDto<MemberIntegeralDto>> memberIntegeralList(@RequestBody MemberIntegeralDto dto);

//    @RequestMapping(value = "/findList", method = RequestMethod.POST)
//    public RestResponse<PageDto<RechargeRecordDto>> findList(@RequestParam("access_token") String access_token,
//                                                             @RequestBody RechargeRecordDto dto);
//
//    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
//    public RestResponse<RechargeRecordDto> createDto(@RequestParam("access_token") String access_token,
//                                                     @RequestBody RechargeRecordDto dto);
//
//    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
//    public RestResponse<RechargeRecordDto> updateDto(@RequestParam("access_token") String access_token,
//                                                     @RequestBody RechargeRecordDto dto);
//
//    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
//    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
//                                           @RequestParam("id") Long id);
//
//    @RequestMapping(value = "/findById", method = RequestMethod.POST)
//    public RestResponse<RechargeRecordDto> findById(@RequestParam("id") Long id);
}
