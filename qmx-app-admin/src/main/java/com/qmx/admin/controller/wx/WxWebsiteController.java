package com.qmx.admin.controller.wx;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.*;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/wxWebsite")
public class WxWebsiteController extends BaseController {

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxWebsiteRemoteService wxWebsiteRemoteService;
    @Autowired
    private WxWebsiteButRemoteService wxWebsiteButRemoteService;
    @Autowired
    private WxWebsiteFacilityRemoteService wxWebsiteFacilityRemoteService;
    @Autowired
    private WxWebsiteImageRemoteService wxWebsiteImageRemoteService;
    @Autowired
    private WxWebsiteProjectRemoteService wxWebsiteProjectRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxWebsiteScenicSpotsRemoteService wxWebsiteScenicSpotsRemoteService;


    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxWebsiteDto dto, ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        dto.setAuthorizer(aid);
        RestResponse<PageDto<WxWebsiteDto>> restResponse = wxWebsiteRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("siteUrl", siteUrl);
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxwebsite/list";
    }

    /**
     * 模板
     *
     * @return
     */
    @RequestMapping(value = "/template")
    public String template() {
        return "/wx/wxwebsite/template";
    }

    /**
     * 新增
     *
     * @param template
     * @param model
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(String template, ModelMap model) {
        model.addAttribute("template", template);
        return "/wx/wxwebsite/add";
    }

    @RequestMapping(value = "/save")
    public String save(WxWebsiteDto dto, HttpServletRequest request) throws Exception {
        String[] butnames = request.getParameterValues("butname");
        String[] buturls = request.getParameterValues("buturl");
        String[] buticons = request.getParameterValues("buticon");

        String[] imagesurls = request.getParameterValues("imagesurl");
        String[] urls = request.getParameterValues("url");

        RestResponse restResponse = wxWebsiteRemoteService.saveWxWebsite(getAccessToken(), butnames, buturls, buticons, imagesurls, urls, dto);

        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 保存
     *
     * @param dto
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveIntroduce")
    public String saveIntroduce(WxWebsiteDto dto, HttpServletRequest request) throws Exception {
        String[] SBname = request.getParameterValues("SBname");
        String[] SBurl = request.getParameterValues("SBurl");
        String[] SBpicture = request.getParameterValues("SBpicture");
        String[] SBdescribe = request.getParameterValues("SBdescribe");

        String[] XMname = request.getParameterValues("XMname");
        String[] XMurl = request.getParameterValues("XMurl");
        String[] XMpicture = request.getParameterValues("XMpicture");

        String companyProfileURL = request.getParameter("companyProfileUrl");
        String name = request.getParameter("name");
        String serviceGuideURL = request.getParameter("serviceGuideUrl");

        String[] imagesurls = request.getParameterValues("imagesurl");
        String[] urls = request.getParameterValues("url");

        RestResponse restResponse = wxWebsiteRemoteService.saveWxWebsiteThree(getAccessToken(), SBname, SBurl, SBpicture, SBdescribe
                , XMname, XMurl, XMpicture, companyProfileURL
                , name, serviceGuideURL, imagesurls, urls, dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/saveWebsiteFour")
    public String saveWebsiteFour(WxWebsiteDto dto, HttpServletRequest request) throws Exception {
        JSONObject json = new JSONObject();
        String[] arr = {"rmzt", "tjjd", "zb", "zj", "yb"};
        for (int i = 0; i < arr.length; i++) {
            String[] title = request.getParameterValues(arr[i] + "Title");
            String[] url = request.getParameterValues(arr[i] + "Url");
            String[] picture = request.getParameterValues(arr[i] + "Picture");
            json.put(arr[i] + "Title", title);
            json.put(arr[i] + "Url", url);
            json.put(arr[i] + "Picture", picture);
        }
        String name = request.getParameter("name");

        String cityName = request.getParameter("cityName");

        String[] butnames = request.getParameterValues("butname");
        String[] buturls = request.getParameterValues("buturl");
        String[] buticons = request.getParameterValues("buticon");
        String[] tzurls = request.getParameterValues("tzurl");

        String[] imagesurls = request.getParameterValues("imagesurl");
        String[] urls = request.getParameterValues("url");
        json.put("name", name);
        json.put("cityName", cityName);
        json.put("butnames", butnames);
        json.put("buturls", buturls);
        json.put("buticons", buticons);
        json.put("tzurls", tzurls);
        json.put("imagesurls", imagesurls);
        json.put("urls", urls);
        String str_json = json.toJSONString();
        RestResponse restResponse = wxWebsiteRemoteService.saveWxWebsiteFour(getAccessToken(), str_json, dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 编辑页面
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<WxWebsiteDto> restResponse = wxWebsiteRemoteService.findId(getAccessToken(), id);
        if (restResponse.getData().getTemplate().equals("wxwebsite_four")) {
            RestResponse<List<WxWebsiteScenicSpotsDto>> listSS = wxWebsiteScenicSpotsRemoteService.findByWebId(getAccessToken(), restResponse.getData().getId());
            model.addAttribute("SSdto", listSS.getData());
        } else {
            RestResponse<List<WxWebsiteFacilityDto>> listFdto = wxWebsiteFacilityRemoteService.findWebId(getAccessToken(), restResponse.getData().getId());
            RestResponse<List<WxWebsiteProjectDto>> listPdto = wxWebsiteProjectRemoteService.findWebId(getAccessToken(), restResponse.getData().getId());
            model.addAttribute("Fdto", listFdto.getData());
            model.addAttribute("Pdto", listPdto.getData());
        }
        RestResponse<List<WxWebsiteButDto>> listBdto = wxWebsiteButRemoteService.findWebId(getAccessToken(), restResponse.getData().getId());
        RestResponse<List<WxWebsiteImageDto>> listIdto = wxWebsiteImageRemoteService.findWebId(getAccessToken(), restResponse.getData().getId());
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("Bdto", listBdto.getData());
        model.addAttribute("Idto", listIdto.getData());
        model.addAttribute("template", restResponse.getData().getTemplate());
        return "/wx/wxwebsite/edit";
    }

    /**
     * 删除
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxWebsiteRemoteService.deleteWxWebsite(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }


}
