package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxReplyRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxReplyDto;
import com.qmx.wxbasics.api.enumerate.ReplyType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/wxReply")
public class WxReplyController extends BaseController {

    @Autowired
    private WxReplyRemoteService wxReplyRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    /**
     * 关注时自动回复内容
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/subscribe")
    public String subscribe(WxReplyDto dto, ModelMap model) {
        model.addAttribute("type", dto.getMsgTypes() == null ? "TEXT" : dto.getMsgTypes());
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        RestResponse<List<WxReplyDto>> restResponse = wxReplyRemoteService.findByKeyvalue(aid, "subscribe");
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("wxReply", restResponse.getData());
        return "/wx/wxreply/subscribe";
    }

    /**
     * 保存关注时自动回复内容
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/savesubscribe")
    public String savesubscribe(WxReplyDto dto, ModelMap model) {
        dto.setKeyvalue("subscribe");
        if (dto.getId() == null) {
            RestResponse<WxReplyDto> restResponse = wxReplyRemoteService.createReply(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            model.addAttribute("dto", restResponse.getData());
        } else {
            RestResponse restResponse = wxReplyRemoteService.updateReply(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            model.addAttribute("dto", dto);
        }

        return "redirect:subscribe?msgTypes=" + dto.getMsgTypes() + "";
    }

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxReplyDto dto, ModelMap model) {
        if (dto.getMsgTypes() == null) {
            dto.setMsgTypes(ReplyType.TEXT);
        }
        RestResponse<PageDto<WxReplyDto>> restResponse = wxReplyRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("type", dto.getMsgTypes() == null ? "TEXT" : dto.getMsgTypes());
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxreply/list";
    }

    /**
     * 增加
     *
     * @param model
     * @param msgTypes
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap model, String msgTypes) {
        return "/wx/wxreply/add" + msgTypes;
    }

    @RequestMapping(value = "/save")
    public String save(WxReplyDto dto) {
        if (dto.getId() == null) {
            RestResponse<WxReplyDto> restResponse = wxReplyRemoteService.createReply(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        } else {
            RestResponse restResponse = wxReplyRemoteService.updateReply(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        }
        return "redirect:list?msgTypes=" + dto.getMsgTypes() + "";
    }

    /**
     * 编辑
     *
     * @param model
     * @param dto
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(ModelMap model, WxReplyDto dto) {
        RestResponse<WxReplyDto> restResponse = wxReplyRemoteService.findById(dto.getId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxreply/add" + restResponse.getData().getMsgTypes().name().toLowerCase();
    }

    /**
     * 更新
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(WxReplyDto dto) {
        RestResponse restResponse = wxReplyRemoteService.updateReply(getAccessToken(), dto);
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
    public String delete(WxReplyDto dto) {
        RestResponse restResponse = wxReplyRemoteService.deleteReply(getAccessToken(), dto.getId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list?msgTypes=" + dto.getMsgTypes() + "";
    }

}
