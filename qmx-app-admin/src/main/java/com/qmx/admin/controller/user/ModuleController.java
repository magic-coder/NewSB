package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import com.qmx.coreservice.api.user.query.ModuleQueryVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 模块管理
 * Created by liubin on 2017/8/30.
 */
@Controller
@RequestMapping("/module")
public class ModuleController extends BaseController {

    @Autowired
    private SysModuleRemoteService sysModuleRemoteService;

    @RequestMapping("/add")
    public String add(HttpServletRequest request, HttpServletResponse response){
        return "/user/module/add";
    }

    @RequestMapping("/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response
            ,Long id,RedirectAttributes redirectAttributes){
        Assert.notNull(id,"id不能为空");
        RestResponse<Boolean> restResponse = sysModuleRemoteService.deleteModuleById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"删除成功");
        return "redirect:list";
    }

    @RequestMapping("/edit")
    public String edit(HttpServletRequest request, HttpServletResponse response,Long id, ModelMap model){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysModuleDto> restResponse = sysModuleRemoteService.getModuleById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto",restResponse.getData());
        return "/user/module/edit";
    }

    @RequestMapping(value = "/update",method = RequestMethod.POST)
    public String update(HttpServletRequest request, HttpServletResponse response,
                         SysModuleDto dto,RedirectAttributes redirectAttributes){
        Assert.notNull(dto,"模块信息不能为空");
        Assert.hasText(dto.getModuleName(),"模块名称不能为空");
        Assert.hasText(dto.getAppKey(),"模块AppKey不能为空");
        Assert.hasText(dto.getAppSecret(),"模块AppSecret不能为空");
        RestResponse<SysModuleDto> restResponse = sysModuleRemoteService.update(getAccessToken(),dto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/save",method = RequestMethod.POST)
    public String save(HttpServletRequest request, HttpServletResponse response,SysModuleDto dto,RedirectAttributes redirectAttributes){
        Assert.notNull(dto,"模块信息不能为空");
        Assert.hasText(dto.getModuleName(),"模块名称不能为空");
        Assert.hasText(dto.getAppKey(),"模块AppKey不能为空");
        Assert.hasText(dto.getAppSecret(),"模块AppSecret不能为空");
        RestResponse<SysModuleDto> restResponse = sysModuleRemoteService.create(getAccessToken(),dto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping("/list")
    public String list(HttpServletRequest request,
                       ModuleQueryVo moduleQueryVo,
                       HttpServletResponse response, ModelMap model){
        RestResponse<PageDto<SysModuleDto>> restResponse = sysModuleRemoteService.findPageModule(getAccessToken(),moduleQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }

        model.addAttribute("dto",moduleQueryVo);
        model.addAttribute("page",restResponse.getData());
        return "/user/module/list";
    }
}
