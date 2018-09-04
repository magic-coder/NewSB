package com.qmx.admin.controller.wx;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxAuthorizationDto;
import com.qmx.wxbasics.api.dto.WxUserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/wxUser")
public class WxUserController extends BaseController {

    @Autowired
    private WxUserRemoteService wxUserRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxUserDto dto, ModelMap model) {
        RestResponse<PageDto<WxUserDto>> restResponse = wxUserRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto userDto = getCurrentUser();
        WxAuthorizationDto authorizationDto = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData();
        if (authorizationDto == null) {
            throw new BusinessException("当前账号未配置微信公众号");
        }
        model.addAttribute("authorizationDto", authorizationDto);

        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxuser/list";
    }

    /**
     * 同步微信用户
     *
     * @return
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/synchroUser", method = RequestMethod.POST)
    public int synchroUser(String appid) throws Exception {
        RestResponse restResponse = wxUserRemoteService.synchro(appid);
        if (!restResponse.success()) {
            return 1;
        }
        return 0;
    }


}
