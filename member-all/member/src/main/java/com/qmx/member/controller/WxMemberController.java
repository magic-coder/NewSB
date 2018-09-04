package com.qmx.member.controller;

import com.qmx.base.api.dto.RestResponse;
import com.qmx.member.api.dto.MemberDto;
import com.qmx.member.model.Member;
import com.qmx.member.service.MemberService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/")
@Api(value = "会员个人中心", tags = "会员个人中心", description = "会员个人中心")
public class WxMemberController extends BaseController {
    @Autowired
    private MemberService memberService;

    @ApiOperation(value = "获取会员", notes = "获取会员")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "id", required = false, paramType = "query", dataType = "Long"),
            @ApiImplicitParam(name = "openid", value = "openid", paramType = "query", dataType = "String")
    })
    @RequestMapping(value = "/finduser")
    public RestResponse<MemberDto> finduser(@RequestParam(name = "id", required = false) Long id,
                                            @RequestParam(name = "openid", required = false) String openid) {
        try {
            Member member = null;
            if (id != null) {
                member = memberService.find(id);
            }
            if (!StringUtils.isEmpty(openid)) {
                member = memberService.findByOpenId(openid);
            }
            if (member == null) {
                return RestResponse.fail("没有用户信息!!!");
            }
            MemberDto memberDto = new MemberDto();
            BeanUtils.copyProperties(member, memberDto);
            return RestResponse.ok(memberDto);
        } catch (BeansException e) {
            return RestResponse.fail(e.getMessage());
        }
    }



    //自动检查会员过期时间,过期会更新会员过期状态
//    @Scheduled(fixedRate = 1000 * 60 * 120)
//    @Scheduled(cron = "0 0 1 * * ? ")
//    public void updateState(){
//        try {
//            memberService.updateState();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

}
