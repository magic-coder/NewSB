package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxMapvoiceRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.wxbasics.api.dto.WxMapvoiceDto;
import com.qmx.wxbasics.api.dto.WxMapvoiceScenicDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/wxMapvoice")
public class WxMapvoiceController extends BaseController {
    @Value("${com.qmx.app.siteUrl}")
    private String siteUrl;
    @Autowired
    private WxMapvoiceRemoteService wxMapvoiceRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxMapvoiceDto dto, ModelMap model) {
        RestResponse<PageDto<WxMapvoiceDto>> restResponse = wxMapvoiceRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("siteUrl", siteUrl);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxmapvoice/list";
    }

    /**
     * 增加
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        return "/wx/wxmapvoice/add";
    }

    /**
     * 保存
     *
     * @param dto
     * @param request
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(WxMapvoiceDto dto, HttpServletRequest request) {

        List<WxMapvoiceScenicDto> wxMapvoiceDtoList = new ArrayList<WxMapvoiceScenicDto>();
        wxMapvoiceDtoList.addAll(WxMapvoiceScenicDto.toEntitys(request));
        dto.setScenics(wxMapvoiceDtoList);
        RestResponse<WxMapvoiceDto> restResponse = wxMapvoiceRemoteService.createMapvoice(getAccessToken(), dto);
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
        RestResponse<WxMapvoiceDto> restResponse1 = wxMapvoiceRemoteService.findById(id);
        RestResponse<List<WxMapvoiceScenicDto>> restResponse2 = wxMapvoiceRemoteService.findByMapVoice(id);
        if (!restResponse1.success() && !restResponse2.success()) {
            throw new BusinessException(restResponse1.getErrorMsg() + "---------" + restResponse2.getErrorMsg());
        }
        model.addAttribute("mapVoice", restResponse1.getData());
        model.addAttribute("mapVoiceScenics", restResponse2.getData());
        return "/wx/wxmapvoice/edit";
    }

    /**
     * 更新
     *
     * @param dto
     * @param request
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(WxMapvoiceDto dto, HttpServletRequest request) {
        List<WxMapvoiceScenicDto> wxMapvoiceDtoList = new ArrayList<WxMapvoiceScenicDto>();
        wxMapvoiceDtoList.addAll(WxMapvoiceScenicDto.toEntitys(request));
        dto.setScenics(wxMapvoiceDtoList);
        wxMapvoiceRemoteService.deleteMapvoiceScenic(getAccessToken(), dto.getId());
        RestResponse restResponse = wxMapvoiceRemoteService.updateMapvoice(getAccessToken(), dto);
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
        RestResponse restResponse1 = wxMapvoiceRemoteService.deleteMapvoice(getAccessToken(), id);
        RestResponse restResponse2 = wxMapvoiceRemoteService.deleteMapvoiceScenic(getAccessToken(), id);
        if (!restResponse1.success() && !restResponse2.success()) {
            throw new BusinessException(restResponse1.getErrorMsg() + "---------" + restResponse2.getErrorMsg());
        }
        return "redirect:list";
    }

}
