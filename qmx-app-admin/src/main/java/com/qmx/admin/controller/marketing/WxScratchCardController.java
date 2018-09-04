package com.qmx.admin.controller.marketing;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxCouponsRemoteService;
import com.qmx.admin.remoteapi.marketing.WxScratchCardRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxCouponsDto;
import com.qmx.marketing.api.dto.WxScratchCardDto;
import com.qmx.marketing.api.dto.WxScratchCardPrizeDto;
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
@RequestMapping("/WxScratchCard")
public class WxScratchCardController extends BaseController {

    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxScratchCardRemoteService wxScratchCardRemoteService;
    @Autowired
    private WxCouponsRemoteService wxCouponsRemoteService;

    /**
     * 列表
     */
    @RequestMapping(value = "/list")
    public String list(WxScratchCardDto dto, ModelMap model) {
        RestResponse<PageDto<WxScratchCardDto>> restResponse = wxScratchCardRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "scratchCard");
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("siteUrl", siteUrl);
        return "/marketing/scratchcard/list";
    }

    /**
     * 添加
     *
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/marketing/scratchcard/add";
    }

    /**
     * 保存
     */
    @RequestMapping("/save")
    public String save(WxScratchCardDto dto, HttpServletRequest request) throws ParseException {
        List<WxScratchCardPrizeDto> prizeDtos = new ArrayList<WxScratchCardPrizeDto>();
        prizeDtos.addAll(WxScratchCardPrizeDto.toEntitys(request));
        dto.setPrizes(prizeDtos);
        RestResponse<WxScratchCardDto> restResponse = wxScratchCardRemoteService.createDto(getAccessToken(), dto);
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
        RestResponse<WxScratchCardDto> restResponse = wxScratchCardRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/marketing/scratchcard/edit";
    }

    /**
     * 更新
     */
    @RequestMapping("/update")
    public String update(WxScratchCardDto dto, HttpServletRequest request) throws ParseException {
        List<WxScratchCardPrizeDto> prizeDtos = new ArrayList<WxScratchCardPrizeDto>();
        prizeDtos.addAll(WxScratchCardPrizeDto.toEntitys(request));
        dto.setPrizes(prizeDtos);
        RestResponse<WxScratchCardDto> restResponse = wxScratchCardRemoteService.updateDto(getAccessToken(), dto);
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
        RestResponse restResponse = wxScratchCardRemoteService.deleteDto(getAccessToken(), id);
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
        return "/marketing/scratchcard/couponlist";
    }
}
