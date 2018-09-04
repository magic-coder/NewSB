package com.qmx.admin.controller.teamticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.teamticket.TtProductRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.teamticket.api.dto.TtProductDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/ttproduct")
public class TtProductController extends BaseController {
    @Autowired
    private TtProductRemoteService ttProductRemoteService;

    @RequestMapping(value = "/list")
    public String list(TtProductDto dto, ModelMap model) {
        RestResponse<PageDto<TtProductDto>> restResponse = ttProductRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproduct/list";
    }

    @RequestMapping(value = "/add")
    public String add() {
        return "/teamticket/ttproduct/add";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<TtProductDto> restResponse = ttProductRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/teamticket/ttproduct/edit";
    }

    @RequestMapping(value = "/save")
    public String save(TtProductDto dto) {
        RestResponse<TtProductDto> restResponse = ttProductRemoteService.createTtProduct(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/update")
    public String update(TtProductDto dto) {
        RestResponse<TtProductDto> restResponse = ttProductRemoteService.updateTtProduct(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    /**
     * 删除
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = ttProductRemoteService.deleteTtProduct(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

}
