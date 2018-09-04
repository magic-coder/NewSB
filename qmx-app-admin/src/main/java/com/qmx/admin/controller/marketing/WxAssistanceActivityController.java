package com.qmx.admin.controller.marketing;


import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxAssistanceActivityRemoteService;
import com.qmx.admin.remoteapi.marketing.WxCouponsRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxAssistanceActivityDto;
import com.qmx.marketing.api.dto.WxCouponsDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;

@Controller
@RequestMapping("/wxAssistanceActivity")
public class WxAssistanceActivityController extends BaseController {

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxAssistanceActivityRemoteService wxAssistanceActivityRemoteService;
    @Autowired
    private WxCouponsRemoteService wxCouponsRemoteService;
    /**
     * 列表
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxAssistanceActivityDto dto, ModelMap model) {
        RestResponse<PageDto<WxAssistanceActivityDto>> restResponse = wxAssistanceActivityRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "activity");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("siteUrl", siteUrl);
        return "/marketing/assistance/list";
    }

    /**
     * 新增页面
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/marketing/assistance/add";
    }

    /**
     * 保存
     */
    @ResponseBody
    @RequestMapping(value = "/save")
    public JSONObject save(WxAssistanceActivityDto dto){
        JSONObject json = new JSONObject();
        RestResponse<WxAssistanceActivityDto> restResponse = wxAssistanceActivityRemoteService.createDto(getAccessToken(),dto);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "保存失败！" + restResponse.getErrorMsg());
        }else{
            json.put("state", "success");
            json.put("msg", "保存成功！");
        }
        return json;
    }

    /**
     * 编辑页面
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("/edit")
    public String edit(ModelMap model, Long id) {
        RestResponse<WxAssistanceActivityDto> restResponse = wxAssistanceActivityRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/marketing/assistance/edit";
    }

    @ResponseBody
    @RequestMapping(value = "/update")
    public JSONObject update(WxAssistanceActivityDto dto) {
        JSONObject json = new JSONObject();
        RestResponse<WxAssistanceActivityDto> restResponse = wxAssistanceActivityRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "保存失败！" + restResponse.getErrorMsg());
        }else{
            json.put("state", "success");
            json.put("msg", "保存成功！");
        }
        return json;
    }

    /**
     * 删除
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = wxAssistanceActivityRemoteService.deleteDto(getAccessToken(),id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    /**
     * 通用优惠券列表
     */
    @RequestMapping(value = "/couponlist")
    public String couponlist(WxCouponsDto dto, ModelMap model) {
        try {
            RestResponse<PageDto<WxCouponsDto>> restResponse = wxCouponsRemoteService.findList(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            model.addAttribute("dto", dto);
            model.addAttribute("page", restResponse.getData());
        } catch (Exception e) {
            model.addAttribute("dto", dto);
            model.addAttribute("page", new PageDto<>());
        }
        return "/marketing/assistance/couponlist";
    }

}
