package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 分销商管理
 * Created by liubin on 2017/9/23 14:46.
 */
@Controller
@RequestMapping("/distributor")
public class DistributorController extends BaseController {

    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response){
        return "/user/distributor/add";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request,
                       HttpServletResponse response,
                       UserQueryVo userQueryVo){
        //SysUserDto sysUserDto = getCurrentMember();
        userQueryVo.setUserType(SysUserType.distributor);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(),userQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("userQueryVo",userQueryVo);
        request.setAttribute("page",restResponse.getData());
        return "/user/distributor/list";
    }

    /**
     * 用户接口下拉菜单
     * @param q
     * @param page
     * @param row
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/listForJson", method = RequestMethod.POST)
    public Object listForJson(@RequestParam(defaultValue = "") String q,
                              @RequestParam(defaultValue = "1") Integer page,
                              @RequestParam(defaultValue = "10") Integer row) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> rows = new ArrayList<>();
        UserQueryVo userQueryVo = new UserQueryVo();
        userQueryVo.setPageIndex(page);
        userQueryVo.setPageSize(row);
        userQueryVo.setUserType(SysUserType.distributor);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(),userQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        PageDto<SysUserDto> pageDto = restResponse.getData();
        for (SysUserDto userDto : pageDto.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", userDto.getId()+"");
            map.put("name", userDto.getUsername());
            map.put("username", userDto.getAccount());
            rows.add(map);
        }
        result.put("total", pageDto.getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, HttpServletResponse response,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysUserDto> menuResp = sysUserRemoteService.findById(id);
        if(!menuResp.success()){
            throw new BusinessException(menuResp.getErrorMsg());
        }
        request.setAttribute("userInfo",menuResp.getData());
        return "/user/distributor/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(HttpServletRequest request, HttpServletResponse response,
                       SysUserDto sysUserDto,RedirectAttributes redirectAttributes){
        Assert.notNull(sysUserDto,"用户信息不能为空");
        Assert.hasLength(sysUserDto.getAccount(),"账号不能为空");
        //Assert.hasLength(sysUserDto.getPassword(),"密码不能为空");
        Assert.hasLength(sysUserDto.getUsername(),"用户名不能为空");
        Assert.notNull(sysUserDto.getAreaId(),"地区不能为空");

        SysUserDto sysUserMember = getCurrentMember();
        if(sysUserMember.getUserType() == SysUserType.admin){
            throw new BusinessException("管理员暂不支持添加分销商");
        }else if(sysUserMember.getUserType() == SysUserType.group_supplier){
            throw new BusinessException("集团供应商暂不支持添加分销商");
        }else if(sysUserMember.getUserType() == SysUserType.distributor ||
                sysUserMember.getUserType() == SysUserType.supplier){
            sysUserDto.setUserType(SysUserType.distributor);//设置供应商
        }else {
            throw new BusinessException("不允许添加的用户类型");
        }

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
