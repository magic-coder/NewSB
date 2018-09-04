package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxTemplatemsgRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxTemplatemsgDto;
import com.qmx.wxbasics.api.enumerate.TemplatemsgType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxTemplatemsg")
public class WxTemplatemsgController extends BaseController {

    @Autowired
    private WxTemplatemsgRemoteService wxTemplatemsgRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxTemplatemsgDto dto, ModelMap model) {
        RestResponse<PageDto<WxTemplatemsgDto>> restResponse = wxTemplatemsgRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxtemplatemsg/list";
    }

    /**
     * 增加
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        model.addAttribute("types", TemplatemsgType.values());
        return "/wx/wxtemplatemsg/add";
    }

    /**
     * 保存
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(WxTemplatemsgDto dto) {
        RestResponse restResponse = wxTemplatemsgRemoteService.createTemplatemsg(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
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
        RestResponse<WxTemplatemsgDto> restResponse = wxTemplatemsgRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("types", TemplatemsgType.values());
        return "/wx/wxtemplatemsg/edit";
    }

    /**
     * 更新
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(WxTemplatemsgDto dto) {
        RestResponse restResponse = wxTemplatemsgRemoteService.updateTemplatemsg(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 删除
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxTemplatemsgRemoteService.deleteTemplatemsg(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
