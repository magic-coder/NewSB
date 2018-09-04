package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxPersonalCenterRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxPersonalCenterDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/wxPersonalCenter")
public class WxPersonalCenterController extends BaseController {
    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxPersonalCenterRemoteService wxPersonalCenterRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    /**
     * 编辑
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        RestResponse<WxPersonalCenterDto> restResponse = wxPersonalCenterRemoteService.findAid(getAccessToken(), aid);
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("url", siteUrl + "/wxpersonalcenter?id=" + aid);
        return "/wx/wxpersonalcenter/edit";
    }

    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public int save(Long aid, String age, boolean type, String phone) {
        try {
            RestResponse<WxPersonalCenterDto> restResponse = wxPersonalCenterRemoteService.updateWxPersonalCenter(aid, age, type, phone);
            if (!restResponse.success()) {
                return 0;
            }
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

}
