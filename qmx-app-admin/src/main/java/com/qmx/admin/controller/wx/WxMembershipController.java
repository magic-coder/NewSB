package com.qmx.admin.controller.wx;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxMembershipRemoteService;
import com.qmx.admin.remoteapi.wx.WxMembershipRuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxMembershipDto;
import com.qmx.wxbasics.api.dto.WxMembershipRuleDto;
import com.qmx.wxbasics.api.enumerate.MembershipRuleType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/wxMembership")
public class WxMembershipController extends BaseController {

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxMembershipRemoteService wxMembershipRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxMembershipRuleRemoteService wxMembershipRuleRemoteService;


    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxMembershipDto dto, ModelMap model) {
        RestResponse<PageDto<WxMembershipDto>> restResponse = wxMembershipRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        model.addAttribute("type", "list");
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("copyurl", siteUrl + "/wxhykindex?id=" + aid);
        return "/wx/wxmembership/list";
    }

    /**
     * 编辑
     *
     * @param model
     * @param id
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(ModelMap model, Long id) {
        RestResponse<WxMembershipDto> restResponse = wxMembershipRemoteService.findId(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxmembership/edit";
    }

    /**
     * 查询
     *
     * @param model
     * @param id
     * @return
     */
    @RequestMapping(value = "/visit")
    public String visit(ModelMap model, Long id) {
        RestResponse<WxMembershipDto> restResponse = wxMembershipRemoteService.findId(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/wx/wxmembership/visit";
    }

    /**
     * 积分消费
     *
     * @param model
     * @param id
     * @return
     */
    @RequestMapping(value = "/integral")
    public String integral(ModelMap model, Long id) {
        RestResponse<WxMembershipDto> restResponse = wxMembershipRemoteService.findId(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        WxMembershipRuleDto dto = new WxMembershipRuleDto();
        dto.setType(MembershipRuleType.integralConsumption);
        dto.setAuthorizer(aid);
        RestResponse<List<WxMembershipRuleDto>> lists = wxMembershipRuleRemoteService.findType(getAccessToken(), dto);
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("rules", lists.getData());
        return "/wx/wxmembership/integral";
    }

    /**
     * 保存修改
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(WxMembershipDto dto) {
        RestResponse restResponse = wxMembershipRemoteService.updateMembership(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 保存积分消费
     *
     * @param dto
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveIntegral")
    public String saveIntegral(WxMembershipDto dto, HttpServletRequest request) {
        String useIntegral = request.getParameter("useIntegral");
        RestResponse restResponse = wxMembershipRemoteService.consumptionScore(getAccessToken(), useIntegral, dto);
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
        RestResponse restResponse = wxMembershipRemoteService.deleteMembership(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }


}
