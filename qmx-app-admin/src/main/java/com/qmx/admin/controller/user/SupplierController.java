package com.qmx.admin.controller.user;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserApiRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserApiDTO;
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
 * 供应商管理
 * Created by liubin on 2017/9/23 14:46.
 */
@Controller
@RequestMapping("/supplier")
public class SupplierController extends BaseController {

    @Autowired
    private SysUserRemoteService sysUserRemoteService;


    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("currentMember", getCurrentMember());
        return "/user/supplier/add";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(
            HttpServletRequest request,UserQueryVo userQueryVo) {
        if (userQueryVo.getUserType() != null) {
            if (userQueryVo.getUserType() == SysUserType.group_supplier || userQueryVo.getUserType() == SysUserType.supplier) {
            } else {
                userQueryVo.setUserType(SysUserType.supplier);
            }
        } else {
            userQueryVo.setUserType(SysUserType.supplier);
        }
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("userQueryVo", userQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/user/supplier/list";
    }

    /**
     * 票型下拉菜单
     *
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
        userQueryVo.setUserType(SysUserType.supplier);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        PageDto<SysUserDto> pageDto = restResponse.getData();
        for (SysUserDto userDto : pageDto.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", userDto.getId() + "");
            map.put("name", userDto.getUsername());
            map.put("username", userDto.getAccount());
            rows.add(map);
        }
        result.put("total", pageDto.getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    /**
     * 获取供应商列表(用于特殊供应商获取普通供应商)
     *
     * @param q
     * @param page
     * @param row
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/listSpecialForJson", method = RequestMethod.POST)
    public Object listSpecialForJson(@RequestParam(defaultValue = "") String q,
                                     @RequestParam(defaultValue = "1") Integer page,
                                     @RequestParam(defaultValue = "10") Integer row) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> rows = new ArrayList<>();
        UserQueryVo userQueryVo = new UserQueryVo();
        userQueryVo.setPageIndex(page);
        userQueryVo.setPageSize(row);
        userQueryVo.setUserType(SysUserType.supplier);
        userQueryVo.setSupplierFlag(Boolean.TRUE);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        PageDto<SysUserDto> pageDto = restResponse.getData();
        for (SysUserDto userDto : pageDto.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", userDto.getId() + "");
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
    public String edit(HttpServletRequest request, HttpServletResponse response, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysUserDto> menuResp = sysUserRemoteService.findById(id);
        if (!menuResp.success()) {
            throw new BusinessException(menuResp.getErrorMsg());
        }
        request.setAttribute("currentMember", getCurrentMember());
        request.setAttribute("userInfo", menuResp.getData());
        return "/user/supplier/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysUserDto sysUserDto, RedirectAttributes redirectAttributes) {
        Assert.notNull(sysUserDto, "用户信息不能为空");
        Assert.hasLength(sysUserDto.getAccount(), "账号不能为空");
        //Assert.hasLength(sysUserDto.getPassword(),"密码不能为空");
        Assert.hasLength(sysUserDto.getUsername(), "用户名不能为空");
        Assert.notNull(sysUserDto.getAreaId(), "地区不能为空");
        SysUserDto currentMember = getCurrentMember();
        if (currentMember.getUserType() == SysUserType.admin) {
            Assert.notNull(sysUserDto.getUserType(), "添加用户类型不能为空");
            if (sysUserDto.getUserType() != SysUserType.group_supplier &&
                    sysUserDto.getUserType() != SysUserType.supplier) {
                throw new BusinessException("用户类型错误:" + sysUserDto.getUserType());
            }
        } else if (currentMember.getUserType() == SysUserType.group_supplier) {
            sysUserDto.setUserType(SysUserType.supplier);//设置供应商
        } else {
            throw new BusinessException("当前用户类型不允许添加供应商");
        }
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.createUser(getAccessToken(), sysUserDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME, "保存成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(HttpServletRequest request, HttpServletResponse response,
                         SysUserDto sysUserDto, RedirectAttributes redirectAttributes) {
        Assert.notNull(sysUserDto, "用户信息不能为空");
        RestResponse<SysUserDto> restResponse = sysUserRemoteService.updateUser(getAccessToken(), sysUserDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME, "更新成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response,
                         Long id, RedirectAttributes redirectAttributes) {
        Assert.notNull(id, "用户id不能为空");
        RestResponse<Boolean> restResponse = sysUserRemoteService.deleteUser(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME, "删除成功");
        return "redirect:list";
    }
}
