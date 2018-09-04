package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysMenuRemoteService;
import com.qmx.admin.remoteapi.core.SysPermissionRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysMenuDto;
import com.qmx.coreservice.api.user.dto.SysPermissionDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 权限管理
 * Created by liubin on 2017/9/27 10:22.
 */
@Controller
@RequestMapping("/permission")
public class PermissionController extends BaseController {

    @Autowired
    private SysMenuRemoteService sysMenuRemoteService;
    @Autowired
    private SysPermissionRemoteService sysPermissionRemoteService;

    @RequestMapping("/menuPermissionList")
    public String menuPermissionList(HttpServletRequest request,Long menuId){
        Assert.notNull(menuId,"menuId不能为空");
        //查询菜单信息
        RestResponse<SysMenuDto> menuResponse = sysMenuRemoteService.findMenuById(menuId);
        if(!menuResponse.success()){
            throw new BusinessException(menuResponse.getErrorMsg());
        }
        //查询菜单权限信息
        RestResponse<List<SysPermissionDto>> restResponse = sysPermissionRemoteService.findPermissionByMenuId(getAccessToken(),menuId);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("menuInfo",menuResponse.getData());
        request.setAttribute("permissions",restResponse.getData());
        return "/user/permission/menu_permission_list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request,Long menuId){
        Assert.notNull(menuId,"menuId不能为空");
        //查询菜单信息
        RestResponse<SysMenuDto> menuResponse = sysMenuRemoteService.findMenuById(menuId);
        if(!menuResponse.success()){
            throw new BusinessException(menuResponse.getErrorMsg());
        }
        List<SysUserType> list = new ArrayList<>();
        list.add(SysUserType.admin);
        list.add(SysUserType.group_supplier);
        list.add(SysUserType.supplier);
        list.add(SysUserType.distributor);
        list.add(SysUserType.distributor2);
        request.setAttribute("userTypes",list);
        request.setAttribute("menuInfo",menuResponse.getData());
        return "/user/permission/add";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request,Long id){
        Assert.notNull(id,"权限id不能为空");
        RestResponse<SysPermissionDto> permissionResponse = sysPermissionRemoteService.getPermissionById(getAccessToken(),id);
        if(!permissionResponse.success()){
            throw new BusinessException(permissionResponse.getErrorMsg());
        }
        SysPermissionDto sysPermissionDto = permissionResponse.getData();
        if(sysPermissionDto == null){
            throw new BusinessException("没查询到权限信息");
        }
        RestResponse<SysMenuDto> menuResponse = sysMenuRemoteService.findMenuById(sysPermissionDto.getMenuId());
        if(!menuResponse.success()){
            throw new BusinessException(menuResponse.getErrorMsg());
        }
        List<SysUserType> list = new ArrayList<>();
        list.add(SysUserType.admin);
        list.add(SysUserType.group_supplier);
        list.add(SysUserType.supplier);
        list.add(SysUserType.distributor);
        list.add(SysUserType.distributor2);
        request.setAttribute("userTypes",list);
        request.setAttribute("menuInfo",menuResponse.getData());
        request.setAttribute("dto",sysPermissionDto);
        return "/user/permission/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysPermissionDto sysPermissionDto,String[] userTypes,RedirectAttributes redirectAttributes){
        Assert.notNull(sysPermissionDto,"权限信息不能为空");
        Assert.hasLength(sysPermissionDto.getPermission(),"权限字符串不能为空");
        Assert.hasLength(sysPermissionDto.getPermissionName(),"权限名称不能为空");
        Assert.notNull(sysPermissionDto.getMenuId(),"所属菜单Id不能为空");
        Assert.notNull(sysPermissionDto.getPermissionType(),"权限类型不能为空");
        Assert.notNull(userTypes,"用户权限对应用户类型不能为空");
        String userType = StringUtils.join(userTypes,",");
        sysPermissionDto.setUserType(userType);
        RestResponse<SysPermissionDto> restResponse = sysPermissionRemoteService.createPermission(getAccessToken(),sysPermissionDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:menuPermissionList?menuId="+sysPermissionDto.getMenuId();
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(SysPermissionDto sysPermissionDto,String[] userTypes,RedirectAttributes redirectAttributes){
        Assert.notNull(sysPermissionDto,"权限信息不能为空");
        Assert.notNull(sysPermissionDto.getId(),"权限id不能为空");
        Assert.hasLength(sysPermissionDto.getPermission(),"权限字符串不能为空");
        Assert.hasLength(sysPermissionDto.getPermissionName(),"权限名称不能为空");
        Assert.notNull(sysPermissionDto.getMenuId(),"所属菜单Id不能为空");
        Assert.notNull(sysPermissionDto.getPermissionType(),"权限类型不能为空");
        Assert.notNull(userTypes,"用户权限对应用户类型不能为空");
        String userType = StringUtils.join(userTypes,",");
        sysPermissionDto.setUserType(userType);
        RestResponse<SysPermissionDto> restResponse = sysPermissionRemoteService.updatePermission(getAccessToken(),sysPermissionDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"更新成功");
        return "redirect:menuPermissionList?menuId="+sysPermissionDto.getMenuId();
    }

    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, Long id,Long menuId){
        Assert.notNull(id,"权限id不能为空");
        RestResponse<Boolean> restResponse = sysPermissionRemoteService.deletePermissionById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:menuPermissionList?menuId="+menuId;
    }
}
