package com.qmx.admin.controller.member;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.member.ExchangeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.member.api.dto.ExchangeDto;
import com.qmx.member.api.enumerate.DeliverType;
import com.qmx.member.api.enumerate.ExchangeProductType;
import com.qmx.member.api.enumerate.MemberSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/exchange")
public class ExchangeController extends BaseController {
    @Autowired
    private ExchangeRemoteService exchangeRemoteService ;

    @RequestMapping(value = "/list")
    public String list(ExchangeDto dto, ModelMap model) {
        RestResponse<PageDto<ExchangeDto>> restResponse = exchangeRemoteService.findList(dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("productTypes", ExchangeProductType.values());
        model.addAttribute("deliverTypes", DeliverType.values());
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/member/exchange/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        ExchangeProductType[] productTypes = ExchangeProductType.values();
        DeliverType[] deliverTypes = DeliverType.values();
        model.addAttribute("productTypes", productTypes);
        model.addAttribute("deliverTypes", deliverTypes);
        return "/member/exchange/add";
    }


    @RequestMapping(value = "/save")
    public String save(ExchangeDto dto, HttpServletRequest request) {
        RestResponse<ExchangeDto> restResponse = exchangeRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<ExchangeDto> restResponse = exchangeRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        ExchangeDto dto = restResponse.getData();
        model.addAttribute("dto", dto);
        ExchangeProductType[] productTypes = ExchangeProductType.values();
        DeliverType[] deliverTypes = DeliverType.values();
        model.addAttribute("productTypes", productTypes);
        model.addAttribute("deliverTypes", deliverTypes);
        return "/member/exchange/edit";
    }

    @RequestMapping(value = "/update")
    public String update(ExchangeDto dto, HttpServletRequest request) {
        RestResponse<ExchangeDto> restResponse = exchangeRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = exchangeRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
