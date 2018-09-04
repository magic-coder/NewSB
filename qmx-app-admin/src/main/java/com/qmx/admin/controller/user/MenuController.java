package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysMenuRemoteService;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysMenuDto;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 菜单controller
 * Created by liubin on 2017/8/30.
 */
@Controller
@RequestMapping("/menu")
public class MenuController extends BaseController {

    @Autowired
    private SysMenuRemoteService sysMenuRemoteService;
    @Autowired
    private SysModuleRemoteService sysModuleRemoteService;

    /**
     * 根据模块id获取菜单信息
     * @param moduleId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/findModuleId", method = {RequestMethod.GET,RequestMethod.POST})
    public RestResponse<List<SysMenuDto>> findMenusByModuleId(Long moduleId){
        RestResponse<List<SysMenuDto>> menuResponse = sysMenuRemoteService.findMenusByModuleId(getAccessToken(),moduleId);
        return menuResponse;
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request){
        RestResponse<List<SysModuleDto>> moduleResponse = sysModuleRemoteService.findAllModule(getAccessToken());
        if(!moduleResponse.success()){
            throw new BusinessException(moduleResponse.getErrorMsg());
        }
        List<SysUserType> list = new ArrayList<>();
        list.add(SysUserType.admin);
        list.add(SysUserType.group_supplier);
        list.add(SysUserType.supplier);
        list.add(SysUserType.distributor);
        list.add(SysUserType.distributor2);
        request.setAttribute("userTypes",list);
        request.setAttribute("modules",moduleResponse.getData());
        return "/user/menu/add";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request,Long moduleId){
        RestResponse<List<SysModuleDto>> moduleResponse = sysModuleRemoteService.findAllModule(getAccessToken());
        if(!moduleResponse.success()){
            throw new BusinessException(moduleResponse.getErrorMsg());
        }
        List<SysModuleDto> sysModuleDtos = moduleResponse.getData();
        if(moduleId == null){
            moduleId = sysModuleDtos.get(0).getId();
        }
        RestResponse<List<SysMenuDto>> restResponse = sysMenuRemoteService.findMenusByModuleId(getAccessToken(),moduleId);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("modules",sysModuleDtos);
        request.setAttribute("moduleId",moduleId);
        request.setAttribute("dto",restResponse.getData());
        return "/user/menu/list";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysMenuDto> menuResp = sysMenuRemoteService.findMenuById(id);
        if(!menuResp.success()){
            throw new BusinessException(menuResp.getErrorMsg());
        }
        SysMenuDto sysMenuDto = menuResp.getData();
        RestResponse<List<SysModuleDto>> moduleResponse = sysModuleRemoteService.findAllModule(getAccessToken());
        if(!moduleResponse.success()){
            throw new BusinessException(moduleResponse.getErrorMsg());
        }
        if(sysMenuDto != null){
            RestResponse<List<SysMenuDto>> menuResponse = sysMenuRemoteService.findMenusByModuleId(getAccessToken(),sysMenuDto.getModuleId());
            if(!menuResponse.success()){
                throw new BusinessException(menuResponse.getErrorMsg());
            }
            request.setAttribute("menuList",menuResponse.getData());
        }
        List<SysUserType> list = new ArrayList<>();
        list.add(SysUserType.admin);
        list.add(SysUserType.group_supplier);
        list.add(SysUserType.supplier);
        list.add(SysUserType.distributor);
        list.add(SysUserType.distributor2);
        request.setAttribute("userTypes",list);
        request.setAttribute("modules",moduleResponse.getData());
        request.setAttribute("menuInfo",sysMenuDto);
        return "/user/menu/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysMenuDto sysMenuDto, String[] userTypes,RedirectAttributes redirectAttributes){
        Assert.notNull(sysMenuDto,"菜单不能为空");
        Assert.notNull(sysMenuDto.getMenuName(),"菜单名称不能为空");
        Assert.notNull(userTypes,"用户类型不能为空");
        Assert.notNull(sysMenuDto.getModuleId(),"所属模块不能为空");
        String userType = StringUtils.join(userTypes,",");
        sysMenuDto.setUserType(userType);
        RestResponse<SysMenuDto> restResponse = sysMenuRemoteService.create(getAccessToken(),sysMenuDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list?moduleId="+sysMenuDto.getModuleId();
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(SysMenuDto sysMenuDto, String[] userTypes,RedirectAttributes redirectAttributes){
        Assert.notNull(sysMenuDto,"菜单不能为空");
        Assert.notNull(sysMenuDto.getId(),"菜单id不能为空");
        Assert.notNull(sysMenuDto.getMenuName(),"菜单名称不能为空");
        Assert.notNull(userTypes,"用户类型不能为空");
        Assert.notNull(sysMenuDto.getModuleId(),"所属模块不能为空");
        String userType = StringUtils.join(userTypes,",");
        sysMenuDto.setUserType(userType);
        RestResponse<SysMenuDto> restResponse = sysMenuRemoteService.update(getAccessToken(),sysMenuDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"更新成功");
        return "redirect:list?moduleId="+sysMenuDto.getModuleId();
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id,RedirectAttributes redirectAttributes){
        Assert.notNull(id,"菜单id不能为空");
        RestResponse<Boolean> restResponse = sysMenuRemoteService.deleteMenuById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"删除成功");
        return "redirect:list";
    }
}
