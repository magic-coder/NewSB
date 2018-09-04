package com.qmx.member.api.facade;

import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.member.api.dto.MemberLevelDto;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@RequestMapping("/memberLevel")
public interface IMemberLevelServiceFacade {
    @RequestMapping(value = "/findList", method = RequestMethod.POST)
    public RestResponse<PageDto<MemberLevelDto>> findList(@RequestParam("access_token") String access_token,
                                                          @RequestBody MemberLevelDto dto);

    @RequestMapping(value = "/createDto", method = RequestMethod.POST)
    public RestResponse<MemberLevelDto> createDto(@RequestParam("access_token") String access_token,
                                                  @RequestBody MemberLevelDto dto);

    @RequestMapping(value = "/updateDto", method = RequestMethod.POST)
    public RestResponse<MemberLevelDto> updateDto(@RequestParam("access_token") String access_token,
                                                  @RequestBody MemberLevelDto dto);

    @RequestMapping(value = "/deleteDto", method = RequestMethod.POST)
    public RestResponse<Boolean> deleteDto(@RequestParam("access_token") String access_token,
                                           @RequestParam("id") Long id);

    @RequestMapping(value = "/findById", method = RequestMethod.POST)
    public RestResponse<MemberLevelDto> findById(@RequestParam("id") Long id);

    @RequestMapping(value = "/findAll", method = RequestMethod.POST)
    public RestResponse<List<MemberLevelDto>> findAll();

    @RequestMapping(value = "/findByName", method = RequestMethod.POST)
    public RestResponse<MemberLevelDto> findByName(@RequestParam("levelName") String levelName);
}
