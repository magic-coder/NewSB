package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysMenuRemoteService;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.admin.remoteapi.core.SysRoleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.InstanceUtil;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.coreservice.api.user.dto.*;
import com.qmx.coreservice.api.user.query.RoleQueryVo;
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
 * 角色管理
 * Created by liubin on 2017/9/27 10:22.
 */
@Controller
@RequestMapping("/role")
public class RoleController extends BaseController {

    @Autowired
    private SysRoleRemoteService sysRoleRemoteService;
    //@Autowired
    //private SysPermissionRemoteService sysPermissionRemoteService;
    @Autowired
    private SysMenuRemoteService sysMenuRemoteService;
    @Autowired
    private SysModuleRemoteService sysModuleRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request,RoleQueryVo roleQueryVo){

        RestResponse<PageDto<SysRoleDto>> restResponse = sysRoleRemoteService.findPage(getAccessToken(),roleQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("roleQueryVo",roleQueryVo);
        request.setAttribute("page",restResponse.getData());
        return "/user/role/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request){
        List<SysUserType> list = new ArrayList<>();
        list.add(SysUserType.admin);
        list.add(SysUserType.group_supplier);
        list.add(SysUserType.supplier);
        list.add(SysUserType.distributor);
        list.add(SysUserType.distributor2);
        request.setAttribute("currentMember",getCurrentMember());
        request.setAttribute("userTypes",list);
        return "/user/role/add";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysRoleDto> deptResp = sysRoleRemoteService.findRoleById(id);
        if(!deptResp.success()){
            throw new BusinessException(deptResp.getErrorMsg());
        }
        List<SysUserType> list = new ArrayList<>();
        list.add(SysUserType.admin);
        list.add(SysUserType.group_supplier);
        list.add(SysUserType.supplier);
        list.add(SysUserType.distributor);
        list.add(SysUserType.distributor2);
        request.setAttribute("currentMember",getCurrentMember());
        request.setAttribute("userTypes",list);
        request.setAttribute("roleInfo",deptResp.getData());
        return "/user/role/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysRoleDto sysRoleDto,RedirectAttributes redirectAttributes){
        Assert.notNull(sysRoleDto,"角色信息不能为空");
        //Assert.hasLength(sysRoleDto.getCode(),"角色编码不能为空");
        Assert.hasLength(sysRoleDto.getRoleName(),"角色名称不能为空");
       // Assert.notNull(sysRoleDto.getSys(),"是否内置不能为空");
        //Assert.notNull(sysRoleDto.getEnable(),"是否启用不能为空");
        RestResponse<SysRoleDto> restResponse = sysRoleRemoteService.createRole(getAccessToken(),sysRoleDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(SysRoleDto sysRoleDto,RedirectAttributes redirectAttributes){
        Assert.notNull(sysRoleDto,"角色信息不能为空");
        Assert.notNull(sysRoleDto.getId(),"id不能为空");
        //Assert.hasLength(sysRoleDto.getCode(),"角色编码不能为空");
        Assert.hasLength(sysRoleDto.getRoleName(),"角色名称不能为空");
        //Assert.notNull(sysRoleDto.getSys(),"是否内置不能为空");
        //Assert.notNull(sysRoleDto.getEnable(),"是否启用不能为空");
        RestResponse<SysRoleDto> restResponse = sysRoleRemoteService.updateRole(getAccessToken(),sysRoleDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"更新成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id,RedirectAttributes redirectAttributes){
        Assert.notNull(id,"菜单id不能为空");
        RestResponse<Boolean> restResponse = sysRoleRemoteService.deleteRoleById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"删除成功");
        return "redirect:list";
    }

    @RequestMapping("/editRolePermission")
    public String editRolePermission(HttpServletRequest request,Long id){
        Assert.notNull(id,"角色id不能为空");

        RestResponse<EditRolePermissionDTO> restResponse = sysRoleRemoteService.queryEditRolePermission(getAccessToken(),id);
        if(restResponse == null || !restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        EditRolePermissionDTO rolePermissionDTO = restResponse.getData();
        List<SysModuleDto> moduleList = rolePermissionDTO.getModuleListWithMenu();
        SysRoleDto sysRoleDto = rolePermissionDTO.getRoleDto();
        List<Long> menuIds = rolePermissionDTO.getRoleMenuIds();
        List<Long> permissionIds = rolePermissionDTO.getRolePermissionIds();
        request.setAttribute("moduleList",moduleList);
        request.setAttribute("roleInfo",sysRoleDto);
        request.setAttribute("menuIds",menuIds);
        request.setAttribute("permissionIds",permissionIds);
        return "/user/role/editRolePermission";
    }

    /**
     * 树形转list
     * @param menus
     * @return
     */
    private List<SysMenuDto> setMenu2NoLevel(List<SysMenuDto> menus){
        List<SysMenuDto> result = InstanceUtil.newArrayList();
        for (SysMenuDto sysMenu : menus) {
            List<SysMenuDto> sysMenuDtos = sysMenu.getMenuBeans();
            if(sysMenuDtos != null && !sysMenuDtos.isEmpty()){
                List<SysMenuDto> temp = getChildMenu(sysMenuDtos);
                if(temp != null){
                    result.addAll(temp);
                }
            }
            result.add(sysMenu);
        }
        return result;
    }

    /**
     * 递归获取子菜单
     * @param menus
     * @return
     */
    private List<SysMenuDto> getChildMenu(List<SysMenuDto> menus) {
        if (menus != null) {
            List<SysMenuDto> newMenus = new ArrayList<>(menus);
            for (SysMenuDto sysMenu : menus) {
                List<SysMenuDto> sysMenuDtos = sysMenu.getMenuBeans();
                if(sysMenuDtos != null && !sysMenuDtos.isEmpty()){
                    List<SysMenuDto> list = getChildMenu(sysMenuDtos);
                    if(list != null && !list.isEmpty()){
                        newMenus.addAll(list);
                        //menus.addAll(list);
                    }
                }
                //menus.add(sysMenu);
            }
            return newMenus;
        }
        return null;
    }

    @RequestMapping("/updateRolePermission")
    public String updateRolePermission(
            Long id,Long[] authorities,Long[] menus){
        Assert.notNull(id,"角色id不能为空");
        RestResponse<Boolean> restResponse = sysRoleRemoteService.updateRolePermissions(getAccessToken(),id,menus,authorities,true);
        if(restResponse == null || !restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
