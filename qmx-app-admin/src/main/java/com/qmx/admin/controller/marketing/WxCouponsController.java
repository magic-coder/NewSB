package com.qmx.admin.controller.marketing;


import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxCouponsRemoteService;
import com.qmx.admin.remoteapi.shop.ticket.ProductRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxCouponsDto;
import com.qmx.shop.api.dto.ticket.ProductDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/wxCoupons")
public class WxCouponsController extends BaseController {

    @Autowired
    private ProductRemoteService shopProductRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxCouponsRemoteService wxCouponsRemoteService;

    /**
     * 优惠券列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxCouponsDto dto, ModelMap model) {
        RestResponse<PageDto<WxCouponsDto>> restResponse = wxCouponsRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/marketing/coupons/list";
    }

    /**
     * 新增页面
     *
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/marketing/coupons/add";
    }

    /**
     * 保存
     */
    @ResponseBody
    @RequestMapping(value = "/save")
    public JSONObject save(WxCouponsDto dto) {
        JSONObject json = new JSONObject();
        RestResponse<WxCouponsDto> restResponse = wxCouponsRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "保存失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "保存成功！");
        }
        return json;
    }

    /**
     * 编辑页面
     */
    @RequestMapping("/edit")
    public String edit(ModelMap model, Long id) {
        RestResponse<WxCouponsDto> restResponse = wxCouponsRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        return "/marketing/coupons/edit";
    }

    /**
     * 编辑
     */
    @ResponseBody
    @RequestMapping(value = "/update")
    public JSONObject update(WxCouponsDto dto) {
        JSONObject json = new JSONObject();
        RestResponse<WxCouponsDto> restResponse = wxCouponsRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "保存失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "保存成功！");
        }
        return json;
    }

    /**
     * 删除
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = wxCouponsRemoteService.deleteDto(getAccessToken(),id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    /*不用删除，裂变分销需要获取商城门票数据*/
    @RequestMapping(value = "/productlist")
    public String productlist(ProductDto dto, ModelMap model) {
        try {
            RestResponse<PageDto<ProductDto>> restResponse = shopProductRemoteService.findList(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            model.addAttribute("dto", dto);
            model.addAttribute("page", restResponse.getData());
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("dto", dto);
            model.addAttribute("page", new PageDto<>());
        }
        return "/marketing/coupons/productlist";
    }

}