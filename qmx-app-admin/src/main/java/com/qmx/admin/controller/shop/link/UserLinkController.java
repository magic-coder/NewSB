package com.qmx.admin.controller.shop.link;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by zcl on 2018/5/24.
 */
@Controller("/link/user")
@RequestMapping("/link/user")
public class UserLinkController extends BaseController {
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Value("${com.qmx.app.siteUrl}")
    private String url;

    @RequestMapping(value = "/list")
    public String list(UserQueryVo vo, HttpServletRequest request, Model model) {
        SysUserDto dto = getCurrentUser();
        PageDto<SysUserDto> pageDto = new PageDto<>();
        if (dto != null && dto.getUserType() == SysUserType.admin) {
            vo.setMemberId(dto.getId());
            RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), vo);
            pageDto = restResponse.getData();
        } else if (dto != null && dto.getUserType() == SysUserType.supplier) {
            List<SysUserDto> list = new ArrayList<>();
            list.add(dto);
            pageDto.setTotal(1);
            if (!list.isEmpty()) {
                pageDto.setRecords(list);
            }
        }
        model.addAttribute("url", url);
        model.addAttribute("page", pageDto);
        model.addAttribute("dto", vo);
        return "/shop/userlink/list";
    }
}
