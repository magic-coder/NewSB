package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysNotifyConfigRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.enumerate.NotifyLevelEnum;
import com.qmx.coreservice.api.message.enumerate.NotifyTypeEnum;
import com.qmx.coreservice.api.user.dto.SysNotifyConfigDTO;
import com.qmx.coreservice.api.user.query.SysNotifyConfigVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;

/**
 * @Author liubin
 * @Description 系统通知配置
 * @Date Created on 2018/1/12 16:57.
 * @Modified By
 */
@Controller
@RequestMapping("/notifyConfig")
public class NotifyConfigController extends BaseController {

    @Autowired
    private SysNotifyConfigRemoteService sysNotifyConfigRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request,
                       SysNotifyConfigVO sysNotifyConfigVO, ModelMap model){
        RestResponse<PageDto<SysNotifyConfigDTO>> restResponse = sysNotifyConfigRemoteService.findPage(getAccessToken(),sysNotifyConfigVO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("notifyTypes",NotifyTypeEnum.values());
        request.setAttribute("notifyLevels", NotifyLevelEnum.values());
        model.addAttribute("queryDto",sysNotifyConfigVO);
        model.addAttribute("page",restResponse.getData());
        return "/sys_common/notify_config/list";
    }

    @RequestMapping("/add")
    public String add(HttpServletRequest request, HttpServletResponse response){
        request.setAttribute("notifyTypes",NotifyTypeEnum.values());
        request.setAttribute("notifyLevels", NotifyLevelEnum.values());
        return "/sys_common/notify_config/add";
    }

    @RequestMapping("/edit")
    public String edit(HttpServletRequest request,Long id, ModelMap model){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysNotifyConfigDTO> restResponse = sysNotifyConfigRemoteService.findById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //request.setAttribute("notifyTypes",NotifyTypeEnum.values());
        //request.setAttribute("notifyLevels", NotifyLevelEnum.values());
        model.addAttribute("dto",restResponse.getData());
        return "/sys_common/notify_config/edit";
    }

    @RequestMapping(value = "/update",method = RequestMethod.POST)
    public String update(HttpServletRequest request, HttpServletResponse response,
                         SysNotifyConfigDTO sysNotifyConfigDTO,RedirectAttributes redirectAttributes){
        Assert.notNull(sysNotifyConfigDTO,"通知信息不能为空");
        Assert.notNull(sysNotifyConfigDTO.getId(),"id不能为空");
        sysNotifyConfigDTO = verifyDto(sysNotifyConfigDTO);
        RestResponse<SysNotifyConfigDTO> restResponse = sysNotifyConfigRemoteService.updateSysNotifyConfig(getAccessToken(),sysNotifyConfigDTO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/save",method = RequestMethod.POST)
    public String save(HttpServletRequest request,SysNotifyConfigDTO sysNotifyConfigDTO,RedirectAttributes redirectAttributes){
        Assert.notNull(sysNotifyConfigDTO,"模块信息不能为空");
        Assert.notNull(sysNotifyConfigDTO.getNotifyType(),"通知类型不能为空");
        Assert.notNull(sysNotifyConfigDTO.getNotifyLevel(),"系统通知级别不能为空");
        //如果是账号过期
        if(sysNotifyConfigDTO.getNotifyType() == NotifyTypeEnum.ACCOUNT_EXPIRED_NOTIFY){
            Assert.notNull(sysNotifyConfigDTO.getAdvanceDays(),"过期提前提醒天数不能为空");
            Assert.notNull(sysNotifyConfigDTO.getAdvanceDays() >=0 ,"过期提前提醒天数非法："+sysNotifyConfigDTO.getAdvanceDays());
        }else{
            sysNotifyConfigDTO.setAdvanceDays(0);
            Assert.notNull(sysNotifyConfigDTO.getNotifyAmount(),"系统通知金额不能为空");
            Assert.notNull(sysNotifyConfigDTO.getNotifyAmount().compareTo(BigDecimal.ZERO) >= 0,"系统通知金额非法");
        }
        sysNotifyConfigDTO = verifyDto(sysNotifyConfigDTO);
        RestResponse<SysNotifyConfigDTO> restResponse = sysNotifyConfigRemoteService.addSysNotifyConfig(getAccessToken(),sysNotifyConfigDTO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping("/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response
            ,Long id,RedirectAttributes redirectAttributes){
        Assert.notNull(id,"id不能为空");
        RestResponse<Boolean> restResponse = sysNotifyConfigRemoteService.deleteSysNotifyConfigById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"删除成功");
        return "redirect:list";
    }

    private SysNotifyConfigDTO verifyDto(SysNotifyConfigDTO sysNotifyConfigDTO){
        //Assert.notNull(sysNotifyConfigDTO,"系统通知信息");
        //Assert.notNull(sysNotifyConfigDTO.getId(),"id不能为空");

        //邮件通知
        Assert.notNull(sysNotifyConfigDTO.getEmailNotify(),"是否邮件通知不能为空");
        if(sysNotifyConfigDTO.getEmailNotify()){
            Assert.notNull(sysNotifyConfigDTO.getEmailNotifyCount(),"系统邮件通知次数不能为空");
            Assert.notNull(sysNotifyConfigDTO.getEmailNotifyCount() >=0 ,"系统邮件通知次数非法："+sysNotifyConfigDTO.getEmailNotifyCount());
        }else{
            sysNotifyConfigDTO.setEmailNotifyCount(0);
        }
        //系统站点通知
        Assert.notNull(sysNotifyConfigDTO.getSiteNotify(),"是否系统站点通知不能为空");
        if(sysNotifyConfigDTO.getSiteNotify()){
            Assert.notNull(sysNotifyConfigDTO.getSiteNotifyCount(),"系统站点通知不能为空");
            Assert.notNull(sysNotifyConfigDTO.getSiteNotifyCount() >= 0,"系统站点通知次数非法："+sysNotifyConfigDTO.getSiteNotifyCount());
        }else{
            sysNotifyConfigDTO.setSiteNotifyCount(0);
        }
        //短信通知
        Assert.notNull(sysNotifyConfigDTO.getSmsNotify(),"是否短信通知不能为空");
        if(sysNotifyConfigDTO.getSmsNotify()){
            Assert.notNull(sysNotifyConfigDTO.getSmsNotifyCount(),"系统短信通知次数不能为空");
            Assert.notNull(sysNotifyConfigDTO.getSmsNotifyCount(),"系统短信通知次数非法:"+sysNotifyConfigDTO.getSmsNotifyCount());
        }else{
            sysNotifyConfigDTO.setSmsNotifyCount(0);
        }
        return sysNotifyConfigDTO;
    }
}
