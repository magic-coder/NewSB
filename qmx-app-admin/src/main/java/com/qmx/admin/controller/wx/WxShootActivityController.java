package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxShootActivityRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxShootActivityDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxShootActivity")
public class WxShootActivityController extends BaseController {

    @Autowired
    private WxShootActivityRemoteService wxShootActivityRemoteService;
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
    public String list(WxShootActivityDto dto, ModelMap model) {
        RestResponse<PageDto<WxShootActivityDto>> restResponse = wxShootActivityRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxshootactivity/list";
    }

    /**
     * 添加页面
     *
     * @return
     */
    @RequestMapping(value = "/add")
    public String add() {
        return "/wx/wxshootactivity/add";
    }

    /**
     * 保存添加
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(WxShootActivityDto dto) {
        Long aid = wxAuthorizationRemoteService.findByMId(getCurrentUser().getId()).getData().getId();
        dto.setAuthorizer(aid);
        RestResponse restResponse = wxShootActivityRemoteService.saveShootActivity(getAccessToken(), dto);
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
        RestResponse<WxShootActivityDto> restResponse = wxShootActivityRemoteService.findId(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxshootactivity/edit";
    }

    /**
     * 保存编辑
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(WxShootActivityDto dto) {
        RestResponse restResponse = wxShootActivityRemoteService.updateShootActivity(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 删除(改变状态)
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxShootActivityRemoteService.deleteShootActivity(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

}
