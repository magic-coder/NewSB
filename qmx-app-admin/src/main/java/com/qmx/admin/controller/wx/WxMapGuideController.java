package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxMapGuideRemoteService;
import com.qmx.admin.remoteapi.wx.WxWeatherRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxMapmarkerDto;
import com.qmx.wxbasics.api.enumerate.MapmarkerType;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/wxMapGuide")
public class WxMapGuideController extends BaseController {
    @Autowired
    private WxMapGuideRemoteService wxMapGuideRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxWeatherRemoteService wxWeatherRemoteService;

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;

    /**
     * 显示界面
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/wxmapguide")
    public String wxmapguide(WxMapmarkerDto dto, ModelMap model) {
        Long aid = wxAuthorizationRemoteService.findByMId(getCurrentUser().getId()).getData().getId();
        dto.setAuthorizer(aid);
        RestResponse<WxMapmarkerDto> restResponse = wxMapGuideRemoteService.findByAuthorizerId(dto.getAuthorizer());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }

        model.addAttribute("siteUrl", siteUrl);
        RestResponse<WxMapmarkerDto> weather = wxWeatherRemoteService.findByAuthorizerId(dto.getAuthorizer());
        if (!weather.success()) {
            throw new BusinessException(weather.getErrorMsg());
        }
        model.addAttribute("aid", aid);
        model.addAttribute("weather", weather.getData());
        model.addAttribute("wxMapMarker", restResponse.getData());
        return "/wx/wxmap/wxmapguide";
    }

    /**
     * 保存/跟新
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/savemapguide")
    public String savemapguide(WxMapmarkerDto dto, Model model, HttpServletRequest request) {
        try {
            Long aid = wxAuthorizationRemoteService.findByMId(getCurrentUser().getId()).getData().getId();

            String city = request.getParameter("city");
            if (StringUtils.isNotEmpty(city)) {
                WxMapmarkerDto weather = null;
                try {
                    weather = wxWeatherRemoteService.findByAuthorizerId(dto.getAuthorizer()).getData();
                } catch (Exception e) {
                }
                WxMapmarkerDto weatherdto = new WxMapmarkerDto();
                if (weather != null) {
                    weatherdto.setId(weather.getId());
                }
                weatherdto.setAuthorizer(aid);
                weatherdto.setType(MapmarkerType.weather);
                weatherdto.setName(city);
                weatherdto.setLatitude(dto.getLatitude());
                weatherdto.setLongitude(dto.getLongitude());
                wxWeatherRemoteService.getWeatherInfo(getAccessToken(), weatherdto);
            }


            dto.setType(MapmarkerType.mapguide);
            dto.setAuthorizer(aid);
            if (dto.getId() != null) {
                RestResponse<WxMapmarkerDto> restResponse = wxMapGuideRemoteService.updateMapGuide(getAccessToken(), dto);
                if (!restResponse.success()) {
                    throw new BusinessException(restResponse.getErrorMsg());
                }
            } else {
                RestResponse<WxMapmarkerDto> restResponse = wxMapGuideRemoteService.createMapGuide(getAccessToken(), dto);
                if (!restResponse.success()) {
                    throw new BusinessException(restResponse.getErrorMsg());
                }
            }
            model.addAttribute("wxMapMarker", dto);
            return "redirect:wxmapguide";
        } catch (Exception e) {
            return "redirect:wxmapguide";
        }
    }
}
