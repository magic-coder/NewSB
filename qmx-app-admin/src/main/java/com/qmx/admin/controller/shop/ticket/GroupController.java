package com.qmx.admin.controller.shop.ticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysOrderSourceRemoteService;
import com.qmx.admin.remoteapi.core.SysPayOrderRemoteService;
import com.qmx.admin.remoteapi.shop.ticket.GroupRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.shop.api.dto.ticket.GroupDto;
import com.qmx.shop.api.dto.ticket.ProductDto;
import com.qmx.shop.api.enumerate.common.PlatformTypeEnum;
import com.qmx.tickets.api.dto.SysTicketsDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller("/ticket/group")
@RequestMapping("/ticket/group")
public class GroupController extends BaseController {
    @Autowired
    private GroupRemoteService groupRemoteService;
    @Autowired
    private TicketsRemoteService ticketsRemoteService;

    @Value("${com.qmx.app.siteUrl}")
    private String url;

    @RequestMapping(value = "/list")
    public String list(GroupDto dto, ProductDto pDto, ModelMap model) {
        SysUserDto currentUser = getCurrentMember();

        model.addAttribute("type", "grouplist");
        //设置查询微信端数据
        dto.setPlatformType(PlatformTypeEnum.WEI_XIN);
        dto.setProductDto(pDto);
        RestResponse<PageDto<GroupDto>> restResponse = groupRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<GroupDto> list = restResponse.getData().getRecords();
        if (null != list && !list.isEmpty()) {
            for (GroupDto groupDto : list) {
                List<ProductDto> productDtos = groupDto.getProducts();
                if (null != productDtos && !productDtos.isEmpty()) {
                    for (ProductDto productDto : productDtos) {
                        RestResponse<SysTicketsDTO> sysTicketsDTORest = ticketsRemoteService.findById(productDto.getOutId());
                        if (!sysTicketsDTORest.success()) {
                            throw new BusinessException(sysTicketsDTORest.getErrorMsg());
                        }
                        productDto.setSn(sysTicketsDTORest.getData().getSn());
                        productDto.setTicketUrl(url + "/shop/ticket/index/getProductById?ticketId=" + productDto.getId() + "&userId=" + currentUser.getId());
                    }
                }
                groupDto.setGroupUrl(url + "/shop/ticket/index/getProductById?groupId=" + groupDto.getId() + "&userId=" + currentUser.getId());
            }
            model.addAttribute("shopUrl", url + "/shop/ticket/index/index?userId=" + currentUser.getId());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("pDto", pDto);
        model.addAttribute("page", restResponse.getData());
        return "/shop/ticket/group/list";
    }

    @RequestMapping(value = "/add")
    public String add() {
        return "/shop/ticket/group/add";
    }

    @RequestMapping(value = "/save")
    public String save(GroupDto dto) {
        //设置为微信端的数据
        dto.setPlatformType(PlatformTypeEnum.WEI_XIN);
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
        return "/shop/ticket/group/edit";
    }

    @RequestMapping(value = "/update")
    public String update(GroupDto dto) {
        RestResponse<GroupDto> restResponse = groupRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
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
