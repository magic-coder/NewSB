package com.qmx.admin.controller.wx;


import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxMaterialRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxMaterialDto;
import com.qmx.wxbasics.api.enumerate.MaterialType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/wxMaterial")
public class WxMaterialController extends BaseController {

    @Autowired
    private WxMaterialRemoteService wxMaterialRemoteService;
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
    public String list(WxMaterialDto dto, ModelMap model) {
        if (dto.getType() == null) {
            dto.setType(MaterialType.NEWS);
        }
        RestResponse<PageDto<WxMaterialDto>> restResponse = wxMaterialRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", dto.getType());
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxmaterial/list";
    }

    @RequestMapping(value = "/wxmateriallist")
    public String wxmateriallist(WxMaterialDto dto, ModelMap model) {
        if (dto.getType() == null) {
            dto.setType(MaterialType.NEWS);
        }
        RestResponse<PageDto<WxMaterialDto>> restResponse = wxMaterialRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", dto.getType());
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxmaterial/wxmateriallist";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        return "/admin/wxmaterial/add";
    }

    @RequestMapping(value = "/save")
    public String save(WxMaterialDto dto) {
        RestResponse<WxMaterialDto> restResponse = wxMaterialRemoteService.createMaterial(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        model.addAttribute("dto", wxMaterialRemoteService.findById(id).getData());
        return "/admin/wxmaterial/edit";
    }

    @RequestMapping(value = "/update")
    public String update(WxMaterialDto dto) {
        RestResponse<WxMaterialDto> restResponse = wxMaterialRemoteService.updateMaterial(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse<WxMaterialDto> restResponse = wxMaterialRemoteService.deleteMaterial(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 同步素材
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/synchro", method = RequestMethod.POST)
    public int synchro() {
        RestResponse restResponse = wxMaterialRemoteService.synchroMaterial(getAccessToken());
        if (!restResponse.success()) {
            return 1;
        }
        return 0;
    }

    /**
     * 根据ID获取微信素材
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getMaterialById", method = RequestMethod.POST)
    public JSONObject getMaterialById(Long id) {
        JSONObject object = new JSONObject();
        RestResponse<String> restResponse = wxMaterialRemoteService.getByMaterial(id);
        if (!restResponse.success()) {
            object.put("state", "0");
            return object;
        }
        object = JSONObject.parseObject(restResponse.getData());
        return object;
    }

}
