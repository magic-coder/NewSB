package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxWeatherRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.wxbasics.api.dto.WxMapmarkerDto;
import com.qmx.wxbasics.api.enumerate.MapmarkerType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxWeather")
public class WxWeatherController extends BaseController {
    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxWeatherRemoteService wxWeatherRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    /**
     * 天气界面
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/wxweather")
    public String wxweather(WxMapmarkerDto dto, ModelMap model) {
        Long aid = wxAuthorizationRemoteService.findByMId(getCurrentUser().getId()).getData().getId();
        dto.setAuthorizer(aid);
        RestResponse<WxMapmarkerDto> restResponse = wxWeatherRemoteService.findByAuthorizerId(dto.getAuthorizer());
        model.addAttribute("aid", aid);
        model.addAttribute("siteUrl", siteUrl);
        model.addAttribute("wxMapMarker", restResponse.getData());
        return "/wx/wxweather/wxweather";
    }

    /**
     * 保存天气
     *
     * @param dto
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveweather")
    public String saveweather(WxMapmarkerDto dto, Model model) throws Exception {
        Long aid = wxAuthorizationRemoteService.findByMId(getCurrentUser().getId()).getData().getId();
        dto.setType(MapmarkerType.weather);
        dto.setAuthorizer(aid);
        wxWeatherRemoteService.getWeatherInfo(getAccessToken(), dto);
        model.addAttribute("wxMapMarker", dto);
        return "redirect:wxweather";
    }
}
