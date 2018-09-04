package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxShootActivityRemoteService;
import com.qmx.admin.remoteapi.wx.WxShootParticipateRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxShootParticipateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxShootParticipate")
public class WxShootParticipateController extends BaseController {

    @Autowired
    private WxShootParticipateRemoteService wxShootParticipateRemoteService;
    @Autowired
    private WxShootActivityRemoteService wxShootActivityRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxShootParticipateDto dto, ModelMap model) {
        RestResponse<PageDto<WxShootParticipateDto>> restResponse = wxShootParticipateRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxshootparticipate/list";
    }

    /**
     * 编辑页面
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<WxShootParticipateDto> restResponse = wxShootParticipateRemoteService.findId(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxshootparticipate/edit";
    }

    /**
     * 保存编辑
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(WxShootParticipateDto dto) {
        try {
            RestResponse restResponse = wxShootParticipateRemoteService.updateWxShootParticipate(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            return "redirect:list";
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 删除(改变状态)
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxShootParticipateRemoteService.deleteShootParticipate(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
