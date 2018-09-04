package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysOrderSourceRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.enumerate.SmsTemplateType;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import com.qmx.coreservice.api.user.dto.SysOrderSourceDTO;
import com.qmx.coreservice.api.user.query.SysOrderSourceVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * @Author liubin
 * @Description 订单来源管理
 * @Date Created on 2017/12/28 17:24.
 * @Modified By
 */
@Controller
@RequestMapping("/orderSource")
public class OrderSourceController extends BaseController {

    @Autowired
    private SysOrderSourceRemoteService orderSourceRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, SysOrderSourceVO sysOrderSourceVO){
        RestResponse<PageDto<SysOrderSourceDTO>> restResponse = orderSourceRemoteService.findPage(getAccessToken(),sysOrderSourceVO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto",sysOrderSourceVO);
        request.setAttribute("page",restResponse.getData());
        return "/user/order_source/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request){
        List<SysModuleDto> sysModuleDtos = getUserModuleList(request);
        //获取当前模块
        //Long currentId = getCurrentModuleId(request);
        request.setAttribute("moduleList", sysModuleDtos);
        return "/user/order_source/add";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysOrderSourceDTO> restResponse = orderSourceRemoteService.findById(id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<SysModuleDto> sysModuleDtos = getUserModuleList(request);
        //获取当前模块
        //Long currentId = getCurrentModuleId(request);
        request.setAttribute("moduleList", sysModuleDtos);
        request.setAttribute("dto",restResponse.getData());
        return "/user/order_source/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysOrderSourceDTO sysOrderSourceDTO){
        Assert.notNull(sysOrderSourceDTO,"订单来源信息不能为空");
        Assert.notNull(sysOrderSourceDTO.getName(),"订单来源名称不能为空");
        RestResponse<SysOrderSourceDTO> restResponse = orderSourceRemoteService.saveOrderService(getAccessToken(),sysOrderSourceDTO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(SysOrderSourceDTO sysOrderSourceDTO){
        Assert.notNull(sysOrderSourceDTO,"订单来源信息不能为空");
        Assert.notNull(sysOrderSourceDTO.getId(),"订单来源id不能为空");
        Assert.notNull(sysOrderSourceDTO.getName(),"订单来源名称不能为空");
        RestResponse<SysOrderSourceDTO> restResponse = orderSourceRemoteService.updateOrderSource(getAccessToken(),sysOrderSourceDTO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<Boolean> restResponse = orderSourceRemoteService.deleteOrderSource(getAccessToken(),new Long[]{id});
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
