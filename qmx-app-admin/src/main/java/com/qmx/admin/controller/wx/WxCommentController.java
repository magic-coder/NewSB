package com.qmx.admin.controller.wx;

import com.alibaba.fastjson.JSONArray;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxCommentRemoteService;
import com.qmx.admin.remoteapi.wx.WxUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxCommentDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/wxComment")
public class WxCommentController extends BaseController {

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxCommentRemoteService wxCommentRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxUserRemoteService wxUserRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxCommentDto dto, ModelMap model) {
        dto.setIsUserMessage(Boolean.TRUE);
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        RestResponse<PageDto<WxCommentDto>> restResponse = wxCommentRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("siteUrl", siteUrl);
        model.addAttribute("aid", aid);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxcomment/list";
    }

    /**
     * 回复评论界面
     *
     * @param model
     * @param dto
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap model, WxCommentDto dto) {
        RestResponse<WxCommentDto> restResponse = wxCommentRemoteService.findById(getAccessToken(), dto.getId());
        RestResponse<List<WxCommentDto>> restResponseList = wxCommentRemoteService.findByUserId(getAccessToken(), dto.getUserId());
        JSONArray urls = new JSONArray();
        for (WxCommentDto wxCommentDto : restResponseList.getData()) {
            String urls_str = wxCommentDto.getUrls();
            JSONArray array = new JSONArray();
            if (StringUtils.isNotEmpty(urls_str)) {
                String[] urls_list = urls_str.split(",");
                for (String string : urls_list) {
                    array.add(string);
                }
            }
            urls.add(array);
        }
        model.addAttribute("urls", urls);
        model.addAttribute("wxComment", restResponse.getData());
        model.addAttribute("wxComments", restResponseList.getData());
        return "/wx/wxcomment/add";
    }

    /**
     * 保存回复评论
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(WxCommentDto dto) {
        RestResponse<WxCommentDto> restResponse = wxCommentRemoteService.createComment(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 删除
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(WxCommentDto dto) {
        RestResponse restResponse = wxCommentRemoteService.deleteComment(getAccessToken(), dto.getId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}