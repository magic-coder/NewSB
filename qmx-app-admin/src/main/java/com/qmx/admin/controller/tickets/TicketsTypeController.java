package com.qmx.admin.controller.tickets;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsTypeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.tickets.api.dto.SysTicketsTypeDTO;
import com.qmx.tickets.api.query.SysTicketsTypeVO;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Author liubin
 * @Description 票型管理
 * @Date Created on 2017/11/30 9:47.
 * @Modified By liubin
 * 暂时不用此类，添加票型用门票Controller里面的
 */
@Controller
@RequestMapping("/tickets/ticketsType")
public class TicketsTypeController extends BaseController {

    @Autowired
    private TicketsTypeRemoteService ticketsTypeRemoteService;
    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, HttpServletResponse response, SysTicketsTypeVO sysTicketsTypeVO){
        RestResponse<PageDto<SysTicketsTypeDTO>> restResponse = ticketsTypeRemoteService.findPage(getAccessToken(),sysTicketsTypeVO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryVO",sysTicketsTypeVO);
        request.setAttribute("page",restResponse.getData());
        return "/tickets/tickets_type/list";
    }

    /**
     * 获取验票人
     */
    @RequestMapping(value = "/listMemberInDialog", method = RequestMethod.GET)
    public String listMemberInDialog(UserQueryVo userQueryVo, ModelMap model) {
        userQueryVo.setUserType(SysUserType.employee);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(),userQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("userQueryVo",userQueryVo);
        model.addAttribute("page",restResponse.getData());
        return "/tickets/tickets_type/list_member_in_dialog";
    }

    @RequestMapping(value = "/addTicketsType", method = RequestMethod.GET)
    public String addTicketsType(HttpServletRequest request, HttpServletResponse response) {
        //SmsTemplateQueryVo templateQueryVo = new SmsTemplateQueryVo();
        //templateQueryVo.setPageSize(100);
        //RestResponse<PageDto<SmsTemplateDto>> restResponse = smsTemplateRemoteService.findPage(getAccessToken(), templateQueryVo);
        //if (!restResponse.success()) {
        //    throw new BusinessException(restResponse.getErrorMsg());
        //}
        //PageDto<SmsTemplateDto> pageDto = restResponse.getData();
        request.setAttribute("currentMember", getCurrentMember());
        //request.setAttribute("smsTemplates", pageDto.getRecords());
        return "/tickets/tickets_type/add";
    }

    @RequestMapping(value = "/editTicketsType", method = RequestMethod.GET)
    public String editTicketsType(HttpServletRequest request, HttpServletResponse response, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysTicketsTypeDTO> restResponse = ticketsTypeRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //SmsTemplateQueryVo templateQueryVo = new SmsTemplateQueryVo();
        //templateQueryVo.setPageSize(100);
        //RestResponse<PageDto<SmsTemplateDto>> smsTemplateResponse = smsTemplateRemoteService.findPage(getAccessToken(), templateQueryVo);
        //if (!smsTemplateResponse.success()) {
        //    throw new BusinessException(smsTemplateResponse.getErrorMsg());
        //}
        //PageDto<SmsTemplateDto> pageDto = smsTemplateResponse.getData();
        request.setAttribute("currentMember", getCurrentMember());
        //request.setAttribute("smsTemplates", pageDto.getRecords());
        SysTicketsTypeDTO sysTicketsTypeDTO = restResponse.getData();
        request.setAttribute("dto", sysTicketsTypeDTO);
        return "/tickets/tickets_type/edit";
    }

    @RequestMapping(value = "/saveTicketsType", method = RequestMethod.POST)
    public String saveTicketsType(HttpServletRequest request, HttpServletResponse response,
                                  SysTicketsTypeDTO sysTicketsTypeDTO, Long[] checkTicketMemberIds,
                                  String isSupplierCheck) {
        Assert.notNull(sysTicketsTypeDTO, "票型信息不能为空");
        //String checkMembers = StringUtils.join(checkTicketMemberIds, ",");
        //if (isSupplierCheck != null) {
        //    checkMembers += "," + sysTicketsTypeDTO.getSupplierId();
        //}
        //sysTicketsTypeDTO.setCheckMembers(checkMembers);
        RestResponse<SysTicketsTypeDTO> restResponse = ticketsTypeRemoteService.saveTicketsType(getAccessToken(), sysTicketsTypeDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/updateTicketsType", method = RequestMethod.POST)
    public String updateTicketsType(HttpServletRequest request, HttpServletResponse response,
                                    SysTicketsTypeDTO sysTicketsTypeDTO, Long[] checkTicketMemberIds,
                                    String isSupplierCheck) {
        Assert.notNull(sysTicketsTypeDTO, "票型信息不能为空");
        Assert.notNull(sysTicketsTypeDTO.getId(), "票型Id信息不能为空");
        //String checkMembers = StringUtils.join(checkTicketMemberIds, ",");
        //if (isSupplierCheck != null) {
        //    checkMembers += "," + sysTicketsTypeDTO.getSupplierId();
        //}
        // sysTicketsTypeDTO.setCheckMembers(checkMembers);
        RestResponse<SysTicketsTypeDTO> restResponse = ticketsTypeRemoteService.updateTicketsType(getAccessToken(), sysTicketsTypeDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/deleteTicketsType")
    public String deleteTicketsType(HttpServletRequest request, HttpServletResponse response,
                                    Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = ticketsTypeRemoteService.deleteTicketsType(getAccessToken(), new Long[]{id});
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
