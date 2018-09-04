package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysAuthorityRemoteService;
import com.qmx.admin.remoteapi.core.SysPermissionRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.shiro.ShiroLoginRealm;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.api.support.LoginInfo;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.coreservice.api.user.dto.*;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 权限管理
 * Created by liubin on 2017/9/29 11:18.
 */
@Controller
@RequestMapping("/authority")
public class AuthorityController extends BaseController {

    //@Autowired
    //private SysRoleRemoteService sysRoleRemoteService;
    @Autowired
    private SysPermissionRemoteService sysPermissionRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    //@Autowired
    //private SysMenuRemoteService sysMenuRemoteService;
    //@Autowired
    //private SysModuleRemoteService sysModuleRemoteService;
    @Autowired
    private SysAuthorityRemoteService authorityRemoteService;

    @RequestMapping("/edit")
    public String edit(HttpServletRequest request,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<UserAuthorityDTO> restResponse = authorityRemoteService.findAuthorityInfo(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        UserAuthorityDTO userAuthorityDTO = restResponse.getData();
        SysUserDto sysUserDto = userAuthorityDTO.getUserDto();
        List<SysModuleDto> modulesWithMenu = userAuthorityDTO.getModuleDtoList();
        List<SysMenuDto> menuList = userAuthorityDTO.getMenuDtoList();
        List<SysRoleDto> roleDtoList = userAuthorityDTO.getRoleDtoList();
        //用户菜单信息
        List<Long> menuIds = InstanceUtil.newArrayList();
        //用户权限信息
        //List<String> permissions = InstanceUtil.newArrayList();
        List<Long> permissionIds = InstanceUtil.newArrayList();

        for (SysMenuDto dto : menuList) {
            menuIds.add(dto.getId());
            List<SysPermissionDto> permissionDtos = dto.getPermissions();
            if(permissionDtos != null){
                for (SysPermissionDto dto2 : permissionDtos) {
                    //permissions.add(dto2.getPermission());
                    permissionIds.add(dto2.getId());
                }
            }
        }

        request.setAttribute("moduleList",modulesWithMenu);
        request.setAttribute("userInfo",sysUserDto);
        //request.setAttribute("menuList",menusRespone.getData());
        request.setAttribute("roleList",roleDtoList);
        request.setAttribute("menuIds",menuIds);
        //request.setAttribute("permissions",permissions);
        request.setAttribute("permissionIds",permissionIds);
        return "/user/authority/edit";
    }


    @RequestMapping("/update")
    public String update(HttpServletRequest request,Long id,Long[] roles,Long[] menus,Long[] authorities){
        Assert.notNull(id,"用户id不能为空");
        RestResponse<Boolean> restResponse = sysPermissionRemoteService.updateUserMenuRoleAndPermission(getAccessToken(),id,roles,menus,authorities);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //更新权限后更新权限缓存
        RestResponse<SysUserDto> userResponse = sysUserRemoteService.findById(id);
        if(!userResponse.success()){
            throw new BusinessException(userResponse.getErrorMsg());
        }
        SysUserDto userDto = userResponse.getData();
        Boolean isEmployee = userDto.getUserType() == SysUserType.employee;
        LoginInfo loginInfo = new LoginInfo(userDto.getId(), userDto.getAccount(), userDto.getUserType(), isEmployee, userDto.getMemberId(),userDto.getSupplierId(),userDto.getGroupSupplierId(),userDto.getPassword());
        PrincipalCollection principalCollection = new SimplePrincipalCollection(loginInfo,shiroLoginRealm.getName());
        shiroLoginRealm.clearCachedAuthorizationInfo(principalCollection);
        //shiroLoginRealm.clearCachedAuthenticationInfo(principalCollection);

        //页面跳转
        String type = userDto.getUserType().name();
        if("distributor2".equals(type)){
            type = "distributor";
        }else if("group_supplier".equals(type)){
            type = "supplier";
        }
        return "redirect:../"+type+"/list";
    }

    @Autowired
    private ShiroLoginRealm shiroLoginRealm;
}
