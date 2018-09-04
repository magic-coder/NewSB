package com.qmx.member.api.facade;

import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.member.api.dto.DiscountDto;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@RequestMapping("/discount")
public interface IDiscountServiceFacade {
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<DiscountDto>> findList(@RequestParam("access_token") String access_token,
                                                          @RequestBody DiscountDto dto);

    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<DiscountDto> createDto(@RequestParam("access_token") String access_token,
                                                  @RequestBody DiscountDto dto);

    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<DiscountDto> updateDto(@RequestParam("access_token") String access_token,
                                                  @RequestBody DiscountDto dto);

    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
                                           @RequestParam("id") Long id);

    @RequestMapping(value = "/findById", method = RequestMethod.POST)
    public RestResponse<DiscountDto> findById(@RequestParam("id") Long id);
}
