package com.qmx.admin.controller.marketing;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxBargainActivityRemoteService;
import com.qmx.admin.remoteapi.shop.ticket.ProductRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.marketing.api.dto.WxBargainActivityDto;
import com.qmx.marketing.api.enumerate.BargainActivityStockType;
import com.qmx.shop.api.dto.ticket.ProductDto;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@RequestMapping("/wxBargainActivity")
public class WxBargainActivityController extends BaseController {

    @Autowired
    private WxBargainActivityRemoteService wxBargainActivityRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private ProductRemoteService shopProductRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxBargainActivityDto dto, ModelMap model) {
        RestResponse<PageDto<WxBargainActivityDto>> restResponse = wxBargainActivityRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("type", "bargain");
        model.addAttribute("page", restResponse.getData());
        return "/marketing/bargain/list";
    }

    /**
     * 新增页面
     *
     * @return
     */
    @RequestMapping("/add")
    public String add() {
        return "/marketing/bargain/add";
    }

    /**
     * 新增保存
     *
     * @param request
     * @param bargain
     * @return
     * @throws ParseException
     */
    @RequestMapping("/save")
    public String save(HttpServletRequest request, WxBargainActivityDto bargain) throws ParseException {
        Long aid = wxAuthorizationRemoteService.findByMId(getCurrentUser().getId()).getData().getId();

        bargain.setAuthorizer(aid);
        if (bargain.getStockType() == BargainActivityStockType.DAY) {
            String[] dates = request.getParameterValues("date");
            String[] numbers = request.getParameterValues("numbers");
            Integer number = 0;
            JSONArray array = new JSONArray();
            for (int i = 0; i < dates.length; i++) {
                JSONObject jsonObject = new JSONObject();
                String date = dates[i];
                String temp = numbers[i];
                number += Integer.parseInt(temp);
                jsonObject.put("date", date);
                jsonObject.put("number", temp);
                array.add(jsonObject);
            }
            bargain.setStock(array.toJSONString());
            bargain.setNumber(number);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat etime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String startdate = sdf.format(bargain.getStartDate()) + " 00:00:00";
        String enddate = sdf.format(bargain.getEndDate()) + " 23:59:59";
        Date endTime = etime.parse(enddate);
        Date starTime = etime.parse(startdate);
        bargain.setStartDate(starTime);
        bargain.setEndDate(endTime);

        RestResponse<WxBargainActivityDto> wxBargainActivityDtoRestResponse = wxBargainActivityRemoteService.saveBargainActivity(getAccessToken(), bargain);
        wxBargainActivityDtoRestResponse.getData().setUrl("www.baidu.com");
        wxBargainActivityRemoteService.updateBargainActivity(getAccessToken(), wxBargainActivityDtoRestResponse.getData());

        return "redirect:list";
    }

    /**
     * 编辑
     *
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("/edit")
    public String edit(ModelMap model, Long id) {
        RestResponse<WxBargainActivityDto> restResponse = wxBargainActivityRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        if (restResponse.getData().getStockType() == BargainActivityStockType.DAY) {
            model.addAttribute("stocks", JSONArray.parseArray(restResponse.getData().getStock()));
        }
        model.addAttribute("dto", restResponse.getData());
        return "/marketing/bargain/edit";
    }

    /**
     * 保存编辑
     *
     * @param request
     * @return
     * @throws ParseException
     */
    @RequestMapping("/update")
    public String update(HttpServletRequest request, WxBargainActivityDto wxBargainActivity) throws ParseException {
        RestResponse<WxBargainActivityDto> bargain = wxBargainActivityRemoteService.findById(wxBargainActivity.getId());
        BeanUtils.copyProperties(wxBargainActivity, bargain.getData(), new String[]{"id", "createDate", "authorizer", "url", "receive"});
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat etime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String startdate = sdf.format(bargain.getData().getStartDate()) + " 00:00:00";
        String enddate = sdf.format(bargain.getData().getEndDate()) + " 23:59:59";
        Date endTime = etime.parse(enddate);
        Date starTime = etime.parse(startdate);
        bargain.getData().setStartDate(starTime);
        bargain.getData().setEndDate(endTime);
        if (bargain.getData().getStockType() == BargainActivityStockType.DAY) {
            String[] dates = request.getParameterValues("date");
            String[] numbers = request.getParameterValues("numbers");
            Integer number = 0;
            JSONArray array = new JSONArray();
            for (int i = 0; i < dates.length; i++) {
                JSONObject jsonObject = new JSONObject();
                String date = dates[i];
                String temp = numbers[i];
                number += Integer.parseInt(temp);
                jsonObject.put("date", date);
                jsonObject.put("number", temp);
                array.add(jsonObject);
            }
            bargain.getData().setStock(array.toJSONString());
            bargain.getData().setNumber(number);
        }
        wxBargainActivityRemoteService.updateBargainActivity(getAccessToken(), bargain.getData());
        return "redirect:list";
    }

    /**
     * 删除活动(改变状态)
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxBargainActivityRemoteService.deleteBargainActivity(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /*不用删除，裂变分销需要获取商城门票数据*/
    @RequestMapping(value = "/productlist")
    public String productlist(ProductDto dto, ModelMap model) {
        RestResponse<PageDto<ProductDto>> restResponse = shopProductRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/marketing/bargain/productlist";
    }

}
