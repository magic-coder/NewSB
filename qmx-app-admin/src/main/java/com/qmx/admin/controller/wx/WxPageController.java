package com.qmx.admin.controller.wx;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxPageRemoteService;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxPageDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequestMapping("/wxPage")
public class WxPageController extends BaseController {
    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxPageRemoteService wxPageRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    @RequestMapping(value = "/template")
    public String template() {
        return "/wx/wxpage/template";
    }

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxPageDto dto, ModelMap model) {
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        dto.setAuthorizer(aid);
        RestResponse<PageDto<WxPageDto>> restResponse = wxPageRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("siteUrl", siteUrl);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxpage/list";
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
        return "/wx/wxpage/add_" + template;
    }

    /**
     * 保存
     *
     * @param dto
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/save")
    public String save(WxPageDto dto, HttpServletRequest request) throws Exception {
        JSONObject json = new JSONObject();
        String[] img_urls = request.getParameterValues("img_url");
        String[] img_titles = request.getParameterValues("img_title");
        String[] info = request.getParameterValues("info");
        String[] url = request.getParameterValues("url");
        json.put("imgUrls", img_urls);
        json.put("imgTitles", img_titles);
        json.put("info", info);
        json.put("url", url);
        String requestInfo = json.toJSONString();

        Long aid = wxAuthorizationRemoteService.findByMId(getCurrentUser().getId()).getData().getId();
        dto.setAuthorizer(aid);
        Map<String, Object> data = RequestUtils.getRequestMap(request, "_");
        JSONObject jsonObject = new JSONObject();
        jsonObject.putAll(data);
        String dataInfo = jsonObject.toJSONString();

        RestResponse restResponse = wxPageRemoteService.savePage(getAccessToken(), requestInfo, dataInfo, dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 编辑
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<WxPageDto> restResponse = wxPageRemoteService.findById(getAccessToken(), id);
        model.addAttribute("dto", restResponse.getData());
        JSONObject jsonObject = JSONObject.parseObject(restResponse.getData().getParams());
        model.addAttribute("params", jsonObject);
        model.addAttribute("template", restResponse.getData().getTemplate());
        return "/wx/wxpage/add_" + restResponse.getData().getTemplate();
    }

    /**
     * 删除
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxPageRemoteService.deletePage(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }


}
