package com.qmx.admin.controller.tickets;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.tickets.SightRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsStockRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsTypeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.tickets.api.dto.SysSightDTO;
import com.qmx.tickets.api.dto.SysTicketsDTO;
import com.qmx.tickets.api.dto.SysTicketsStockDTO;
import com.qmx.tickets.api.dto.SysTicketsTypeDTO;
import com.qmx.tickets.api.enumerate.ProductSourceEnum;
import com.qmx.tickets.api.query.SysSightVO;
import com.qmx.tickets.api.query.SysTicketsTypeVO;
import com.qmx.tickets.api.query.SysTicketsVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * @Author liubin
 * @Description 门票管理
 * @Date Created on 2017/12/1 14:25.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/tickets")
public class TicketsController extends BaseController {

    @Autowired
    private TicketsTypeRemoteService ticketsTypeRemoteService;
    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TicketsRemoteService ticketsRemoteService;
    @Autowired
    private TicketsStockRemoteService stockRemoteService;
    @Autowired
    private SightRemoteService sightRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, SysTicketsVO sysTicketsVO) {
        RestResponse<PageDto<SysTicketsDTO>> restResponse = ticketsRemoteService.findPage(getAccessToken(), sysTicketsVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysTicketsVO);
        request.setAttribute("page", restResponse.getData());
        return "/tickets/tickets/list_with_type";
    }

    /**
     * json票型分页
     *
     * @param sysTicketsVO
     * @return
     */
    @ResponseBody
    @RequestMapping("/listJson")
    public RestResponse listJson(SysTicketsVO sysTicketsVO) {
        RestResponse<PageDto<SysTicketsDTO>> restResponse = ticketsRemoteService.findPage(getAccessToken(), sysTicketsVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return RestResponse.ok(restResponse.getData());
    }

    @RequestMapping(value = "/addTickets", method = RequestMethod.GET)
    public String addTickets(HttpServletRequest request) {

        SysUserDto sysUserDto = getCurrentMember();
        Long supplierId = sysUserDto.getId();

        RestResponse<List<SysTicketsStockDTO>> sysTicketsStockResponse = stockRemoteService.findEffectiveList(getAccessToken(), supplierId);
        if (!sysTicketsStockResponse.success()) {
            throw new BusinessException(sysTicketsStockResponse.getErrorMsg());
        }
        SmsTemplateQueryVo templateQueryVo = new SmsTemplateQueryVo();
        templateQueryVo.setPageSize(100);
        RestResponse<PageDto<SmsTemplateDto>> smsTemplateResponse = null;
        templateQueryVo.setModuleId(getCurrentModuleId(request));
        if(sysUserDto.getUserType() == SysUserType.supplier){
            smsTemplateResponse = smsTemplateRemoteService.findSupplierAuthPage(getAccessToken(),templateQueryVo);
        }else{
            smsTemplateResponse = smsTemplateRemoteService.findPage(getAccessToken(), templateQueryVo);
        }
        if (!smsTemplateResponse.success()) {
            throw new BusinessException(smsTemplateResponse.getErrorMsg());
        }
        PageDto<SmsTemplateDto> pageDto = smsTemplateResponse.getData();
        SysTicketsTypeVO ticketsTypeVO = new SysTicketsTypeVO();
        ticketsTypeVO.setPageSize(50);
        RestResponse<PageDto<SysTicketsTypeDTO>> restResponse1 = ticketsTypeRemoteService.findPage(getAccessToken(),ticketsTypeVO);
        if (!restResponse1.success()) {
            throw new BusinessException(restResponse1.getErrorMsg());
        }
        PageDto<SysTicketsTypeDTO> pageDto1 = restResponse1.getData();
        request.setAttribute("ticketsTypeList", pageDto1.getRecords());
        request.setAttribute("smsTemplates", pageDto.getRecords());
        request.setAttribute("ticketStocks", sysTicketsStockResponse.getData());
        return "/tickets/tickets/add";
    }

    @RequestMapping(value = "/editTickets", method = RequestMethod.GET)
    public String editTickets(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysTicketsDTO sysTicketsDTO = restResponse.getData();
        //SysTicketsTypeDTO ticketsTypeDTO = sysTicketsDTO.getTicketsType();
        //Long supplierId = ticketsTypeDTO.getSupplierId();
        Long supplierId = sysTicketsDTO.getSupplierId();
        SysUserDto sysUserDto = getCurrentMember();
        if (sysUserDto.getSupplierFlag()) {
            //supplierId = ticketsTypeDTO.getSupplier2Id();
            supplierId = sysTicketsDTO.getSupplier2Id();
        }

        RestResponse<List<SysTicketsStockDTO>> sysTicketsStockResponse = stockRemoteService.findEffectiveList(getAccessToken(), supplierId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SmsTemplateQueryVo templateQueryVo = new SmsTemplateQueryVo();
        templateQueryVo.setPageSize(100);
        templateQueryVo.setModuleId(getCurrentModuleId(request));
        RestResponse<PageDto<SmsTemplateDto>> smsTemplateResponse = null;
        if(sysUserDto.getUserType() == SysUserType.supplier){
            smsTemplateResponse = smsTemplateRemoteService.findSupplierAuthPage(getAccessToken(),templateQueryVo);
        }else{
            smsTemplateResponse = smsTemplateRemoteService.findPage(getAccessToken(), templateQueryVo);
        }
        if (!smsTemplateResponse.success()) {
            throw new BusinessException(smsTemplateResponse.getErrorMsg());
        }
        PageDto<SmsTemplateDto> pageDto = smsTemplateResponse.getData();
        SysTicketsTypeVO ticketsTypeVO = new SysTicketsTypeVO();
        ticketsTypeVO.setPageSize(50);
        RestResponse<PageDto<SysTicketsTypeDTO>> restResponse1 = ticketsTypeRemoteService.findPage(getAccessToken(),ticketsTypeVO);
        if (!restResponse1.success()) {
            throw new BusinessException(restResponse1.getErrorMsg());
        }
        PageDto<SysTicketsTypeDTO> pageDto1 = restResponse1.getData();
        request.setAttribute("ticketsTypeList", pageDto1.getRecords());
        request.setAttribute("smsTemplates", pageDto.getRecords());
        request.setAttribute("ticketStocks", sysTicketsStockResponse.getData());
        request.setAttribute("dto", sysTicketsDTO);
        return "/tickets/tickets/edit";
    }

    @RequestMapping(value = "/saveTickets", method = RequestMethod.POST)
    public String saveTickets(SysTicketsDTO sysTicketsDTO) {
        Assert.notNull(sysTicketsDTO, "门票信息不能为空");
        sysTicketsDTO.setFullName(sysTicketsDTO.getName());
        sysTicketsDTO.setProductSource(ProductSourceEnum.local);
        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.saveTickets(getAccessToken(), sysTicketsDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/updateTickets", method = RequestMethod.POST)
    public String update(SysTicketsDTO sysTicketsDTO) {
        Assert.notNull(sysTicketsDTO, "门票信息不能为空");
        Assert.notNull(sysTicketsDTO.getId(), "门票Id信息不能为空");
        //sysTicketsDTO.setFullName(sysTicketsDTO.getName());
        sysTicketsDTO.setProductSource(ProductSourceEnum.local);
        sysTicketsDTO.setFullName(sysTicketsDTO.getName());
        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.updateTickets(getAccessToken(), sysTicketsDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/deleteTickets")
    public String deleteTickets(HttpServletRequest request, HttpServletResponse response,
                                Long id) {
        Assert.notNull(id, "id不能为空");
        return "redirect:list";
    }


    /**
     * 票型列表
     * @param request
     * @param response
     * @param sysTicketsTypeVO
     * @return
     */
    /*@RequestMapping("/listTicketsType")
    public String listTicketsType(HttpServletRequest request, HttpServletResponse response, SysTicketsTypeVO sysTicketsTypeVO){
        RestResponse<PageDto<SysTicketsTypeDTO>> restResponse = ticketsTypeRemoteService.findPage(getAccessToken(),sysTicketsTypeVO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryVO",sysTicketsTypeVO);
        request.setAttribute("page",restResponse.getData());
        return "/tickets/tickets_type/list";
    }*/

    /**
     * 获取验票人
     */
    @RequestMapping(value = "/listMemberInDialog", method = RequestMethod.GET)
    public String listMemberInDialog(UserQueryVo userQueryVo, ModelMap model) {
        userQueryVo.setUserType(SysUserType.employee);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("userQueryVo", userQueryVo);
        model.addAttribute("page", restResponse.getData());
        return "/tickets/tickets_type/list_member_in_dialog";
    }

    /**
     * 上架
     */
    @ResponseBody
    @RequestMapping(value = "/shelvesTickets", method = RequestMethod.POST)
    public RestResponse shelvesTickets(Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse restResponse = ticketsRemoteService.shelvesTickets(getAccessToken(), new Long[]{id});
        return restResponse;
    }

    /**
     * 下架
     */
    @ResponseBody
    @RequestMapping(value = "/underTickets", method = RequestMethod.POST)
    public RestResponse underTickets(Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse restResponse = ticketsRemoteService.underTickets(getAccessToken(), new Long[]{id});
        return restResponse;
    }
}
