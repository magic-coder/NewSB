package com.qmx.admin.controller.shop.qrcode;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.qrcode.GroupRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import com.qmx.shop.api.dto.qrcode.GroupDto;
import com.qmx.shop.api.dto.qrcode.ProductDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;

@Controller("/qrcode/group")
@RequestMapping("/qrcode/group")
public class GroupController extends BaseController {
    @Autowired
    private GroupRemoteService groupRemoteService;
    @Value("${com.qmx.app.siteUrl}")
    private String url;

    @RequestMapping(value = "/list")
    public String list(GroupDto dto, ProductDto pDto, ModelMap model, HttpServletRequest request) {
        model.addAttribute("type", "grouplist");
        RestResponse<PageDto<GroupDto>> restResponse = groupRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }

        model.addAttribute("dto", dto);
        model.addAttribute("pDto", pDto);
        model.addAttribute("page", restResponse.getData());
        return "/shop/qrcode/group/list";
    }

    @RequestMapping(value = "/add")
    public String add() {
        return "/shop/qrcode/group/add";
    }

    @RequestMapping(value = "/save")
    public String save(GroupDto dto) {
        RestResponse<GroupDto> restResponse = groupRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }

        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<GroupDto> restResponse = groupRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/shop/qrcode/group/edit";
    }

    @RequestMapping(value = "/update")
    public String update(GroupDto dto) {
        RestResponse<GroupDto> restResponse = groupRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public String view(Long id, ModelMap model) {
        RestResponse<GroupDto> restResponse = groupRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        GroupDto dto = restResponse.getData();
        //生成分组链接
        dto.setGroupUrl(url + "/shop/qrcode/index/index?groupId=" + dto.getId() + "&userId=" + dto.getMemberId());
        // dto.setGroupUrl(url+ new StringBuffer().append("/shop/ticket/index/index?userId=" + 958580506489999361L));
        //生成分组二维码链接
        if (dto.getGroupUrl() != null) {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            QRCodeUtil.encode(dto.getGroupUrl(), 400, 400, out);
            byte[] tempbyte = out.toByteArray();
            String base64Url = Base64Util.encodeToString(tempbyte);
            //model.addAttribute("codeUrl", "data:image/png;base64," + base64Url);
            dto.setQrcodeUrl("data:image/png;base64," + base64Url);
        }
        model.addAttribute("dto", restResponse.getData());
        return "/shop/qrcode/group/view";
    }

    /**
     * 根据ajax批量删除商品分组信息
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public JSONObject delete(Long id) {
        JSONObject jsonObject = new JSONObject();
        RestResponse<Boolean> restResponse = groupRemoteService.deleteDto(getAccessToken(), id);
        if (restResponse.success()) {
            jsonObject.put("data", "success");
        } else {
            jsonObject.put("data", restResponse.getErrorMsg());
        }
        return jsonObject;
    }
}
