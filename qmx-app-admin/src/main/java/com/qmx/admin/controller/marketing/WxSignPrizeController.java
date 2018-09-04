package com.qmx.admin.controller.marketing;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxCouponsRemoteService;
import com.qmx.admin.remoteapi.marketing.WxSignPrizeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxCouponsDto;
import com.qmx.marketing.api.dto.WxSignPrizeDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/WxSignPrize")
public class WxSignPrizeController extends BaseController {

    @Autowired
    private WxSignPrizeRemoteService wxSignPrizeRemoteService;
    @Autowired
    private WxCouponsRemoteService wxCouponsRemoteService;

    /**
     * 列表
     */
    @RequestMapping(value = "/list")
    public String list(WxSignPrizeDto dto, ModelMap model) {
        RestResponse<PageDto<WxSignPrizeDto>> restResponse = wxSignPrizeRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "prize");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/signprize/list";
    }

    /**
     * 添加
     *
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/marketing/signprize/add";
    }

    /**
     * 保存
     */
    @RequestMapping("/save")
    public String save(WxSignPrizeDto dto, HttpServletRequest request) throws Exception {
        RestResponse<WxSignPrizeDto> restResponse = wxSignPrizeRemoteService.createDto(getAccessToken(), dto);
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
        RestResponse<WxSignPrizeDto> restResponse = wxSignPrizeRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/marketing/signprize/edit";
    }

    /**
     * 更新
     */
    @RequestMapping("/update")
    public String update(WxSignPrizeDto dto, HttpServletRequest request) throws Exception {
        RestResponse<WxSignPrizeDto> restResponse = wxSignPrizeRemoteService.updateDto(getAccessToken(), dto);
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
        RestResponse restResponse = wxSignPrizeRemoteService.deleteDto(getAccessToken(), id);
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
        return "/marketing/signprize/couponlist";
    }
}
