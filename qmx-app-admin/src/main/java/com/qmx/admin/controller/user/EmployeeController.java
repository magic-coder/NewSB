package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.DeptRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysDeptDto;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 员工管理
 * Created by liubin on 2017/9/23 14:46.
 */
@Controller
@RequestMapping("/employee")
public class EmployeeController extends BaseController {

    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private DeptRemoteService deptRemoteService;

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response){
        RestResponse<List<SysDeptDto>> restResponse = deptRemoteService.findAllListByMemberId(getAccessToken());
        if(!restResponse.success()){
            new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("depts",restResponse.getData());
        return "/user/employee/add";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request,
                       HttpServletResponse response,
                       UserQueryVo userQueryVo){
        userQueryVo.setUserType(SysUserType.employee);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(),userQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("userQueryVo",userQueryVo);
        request.setAttribute("page",restResponse.getData());
        return "/user/employee/list";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, HttpServletResponse response,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysUserDto> menuResp = sysUserRemoteService.findById(id);
        if(!menuResp.success()){
            throw new BusinessException(menuResp.getErrorMsg());
        }
        RestResponse<List<SysDeptDto>> restResponse = deptRemoteService.findAllListByMemberId(getAccessToken());
        if(!restResponse.success()){
            new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("depts",restResponse.getData());
        request.setAttribute("userInfo",menuResp.getData());
        return "/user/employee/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(HttpServletRequest request, HttpServletResponse response,
                       SysUserDto sysUserDto,RedirectAttributes redirectAttributes){
        Assert.notNull(sysUserDto,"用户信息不能为空");
        Assert.hasLength(sysUserDto.getAccount(),"账号不能为空");
        //Assert.hasLength(sysUserDto.getPassword(),"密码不能为空");
        Assert.hasLength(sysUserDto.getUsername(),"用户名不能为空");
        Assert.notNull(sysUserDto.getAreaId(),"地区不能为空");
        sysUserDto.setUserType(SysUserType.employee);
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.createUser(getAccessToken(),sysUserDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(HttpServletRequest request, HttpServletResponse response,
                         SysUserDto sysUserDto,RedirectAttributes redirectAttributes){
        Assert.notNull(sysUserDto,"用户信息不能为空");
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.updateUser(getAccessToken(),sysUserDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"更新成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response,
                         Long id,RedirectAttributes redirectAttributes){
        Assert.notNull(id,"用户id不能为空");
        RestResponse<Boolean> restResponse = sysUserRemoteService.deleteUser(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"删除成功");
        return "redirect:list";
    }
}
