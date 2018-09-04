package com.qmx.admin.controller.marketing;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxCouponsRemoteService;
import com.qmx.admin.remoteapi.marketing.WxTurntableRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxCouponsDto;
import com.qmx.marketing.api.dto.WxTurntableDto;
import com.qmx.marketing.api.dto.WxTurntablePrizeDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/WxTurntable")
public class WxTurntableController extends BaseController {
    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxTurntableRemoteService wxTurntableRemoteService;
    @Autowired
    private WxCouponsRemoteService wxCouponsRemoteService;

    /**
     * 列表
     */
    @RequestMapping(value = "/list")
    public String list(WxTurntableDto dto, ModelMap model) {
        RestResponse<PageDto<WxTurntableDto>> restResponse = wxTurntableRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "turntable");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("siteUrl", siteUrl);
        return "/marketing/turntable/list";
    }

    /**
     * 添加
     *
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/marketing/turntable/add";
    }

    /**
     * 保存
     */
    @RequestMapping("/save")
    public String save(WxTurntableDto dto, HttpServletRequest request) throws ParseException {
        List<WxTurntablePrizeDto> prizeDtos = new ArrayList<WxTurntablePrizeDto>();
        prizeDtos.addAll(WxTurntablePrizeDto.toEntitys(request));
        dto.setPrizes(prizeDtos);
        RestResponse<WxTurntableDto> restResponse = wxTurntableRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 编辑
     */
    @RequestMapping("/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<WxTurntableDto> restResponse = wxTurntableRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/marketing/turntable/edit";
    }

    /**
     * 更新
     */
    @RequestMapping("/update")
    public String update(WxTurntableDto dto, HttpServletRequest request) throws ParseException {
        List<WxTurntablePrizeDto> prizeDtos = new ArrayList<WxTurntablePrizeDto>();
        prizeDtos.addAll(WxTurntablePrizeDto.toEntitys(request));
        dto.setPrizes(prizeDtos);
        RestResponse<WxTurntableDto> restResponse = wxTurntableRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 删除
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = wxTurntableRemoteService.deleteDto(getAccessToken(), id);
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
    public String couponlist(WxCouponsDto dto, String num, ModelMap model) {
        try {
            RestResponse<PageDto<WxCouponsDto>> restResponse = wxCouponsRemoteService.findList(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            model.addAttribute("dto", dto);
            model.addAttribute("num", num);
            model.addAttribute("page", restResponse.getData());
        } catch (Exception e) {
            model.addAttribute("dto", dto);
            model.addAttribute("num", num);
            model.addAttribute("page", new PageDto<>());
        }
        return "/marketing/turntable/couponlist";
    }
}
