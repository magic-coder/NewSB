package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.DeptRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysDeptDto;
import com.qmx.coreservice.api.user.query.DeptQueryVo;
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
 * 部门管理
 * Created by liubin on 2017/9/20 18:35.
 */
@Controller
@RequestMapping("/dept")
public class DeptController extends BaseController {

    @Autowired
    private DeptRemoteService deptRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, HttpServletResponse response, DeptQueryVo deptQueryVo){

        RestResponse<PageDto<SysDeptDto>> restResponse = deptRemoteService.findPage(getAccessToken(),deptQueryVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("deptQueryVo",deptQueryVo);
        request.setAttribute("page",restResponse.getData());
        return "/user/dept/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response){
        RestResponse<List<SysDeptDto>> restResponse = deptRemoteService.findAllListByMemberId(getAccessToken());
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("deptList",restResponse.getData());
        return "/user/dept/add";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, HttpServletResponse response,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysDeptDto> deptResp = deptRemoteService.getDeptById(getAccessToken(),id);
        if(!deptResp.success()){
            throw new BusinessException(deptResp.getErrorMsg());
        }
        //RestResponse<List<SysDeptDto>> restResponse = deptRemoteService.findAllListByMemberId(getAccessToken());
        //if(!restResponse.success()){
        //    throw new BusinessException(restResponse.getErrorMsg());
       // }
        //request.setAttribute("deptList",restResponse.getData());
        request.setAttribute("deptInfo",deptResp.getData());
        return "/user/dept/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(HttpServletRequest request, HttpServletResponse response,
                       SysDeptDto sysDeptDto,RedirectAttributes redirectAttributes){
        Assert.notNull(sysDeptDto,"部门不能为空");
        Assert.notNull(sysDeptDto.getDeptName(),"部门名称不能为空");
        RestResponse<SysDeptDto> restResponse = deptRemoteService.createDept(getAccessToken(),sysDeptDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(HttpServletRequest request, HttpServletResponse response,
                         SysDeptDto sysDeptDto,RedirectAttributes redirectAttributes){
        Assert.notNull(sysDeptDto,"部门不能为空");
        Assert.notNull(sysDeptDto.getDeptName(),"部门名称不能为空");
        RestResponse<SysDeptDto> restResponse = deptRemoteService.updateDept(getAccessToken(),sysDeptDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"更新成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response,
                         Long id,RedirectAttributes redirectAttributes){
        Assert.notNull(id,"菜单id不能为空");
        RestResponse<Boolean> restResponse = deptRemoteService.deleteDeptById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"删除成功");
        return "redirect:list";
    }

}
