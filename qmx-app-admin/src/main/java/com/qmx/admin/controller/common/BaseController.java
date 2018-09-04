package com.qmx.admin.controller.common;
import com.qmx.admin.remoteapi.core.*;
import com.qmx.admin.service.LoginUserInfoService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.api.support.LoginInfo;
import com.qmx.base.core.DateEditor;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.base.core.utils.RequestUtils;
import com.qmx.base.core.utils.WebUtil;
import com.qmx.coreservice.api.user.dto.SysMenuDto;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.dto.TokenInfo;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Base64;
import java.util.Date;
import java.util.List;

/**
 * controller基类
 * Created by liubin on 2017/8/24.
 */
public class BaseController {

    private static final Logger logger = LoggerFactory.getLogger(BaseController.class);

    /** 错误视图 */
    protected static final String ERROR_VIEW = "/common/error";

    /** 消息key */
    protected static final String MESSAGE_KEY = "content";

    /** 瞬时消息*/
    protected static final String FLASH_MESSAGE_ATTRIBUTE_NAME = "flash_message_attribute_name";

    @Autowired
    private SysUserRemoteService userService;
    @Autowired
    private LoginRemoteService loginRemoteService;
    @Autowired
    private SysMenuRemoteService sysMenuRemoteService;
    @Autowired
    private SysModuleRemoteService sysModuleRemoteService;
    @Autowired
    private LoginUserInfoService loginUserInfoService;

    /**
     * 数据绑定
     *
     * @param binder
     *            WebDataBinder
     */
    @InitBinder
    protected void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(Date.class, new DateEditor());
        //SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));

    }
    /**
     * 获取当前登录用户
     * @return
     */
    protected SysUserDto getCurrentUser(){
        return loginUserInfoService.getCurrentUser();
    }

    /**
     * 获取当前member(非员工)
     * @return
     */
    protected SysUserDto getCurrentMember(){
        return loginUserInfoService.getCurrentMember();
    }

    protected void queryUserInfo(ModelMap model){
        SysUserDto userDto = loginUserInfoService.getCurrentUser();
        if(userDto != null){
            model.addAttribute("userInfo",userDto);
        }
    }

    /**
     * 获取当前模块（session中模块）
     * @return
     */
    protected Long getCurrentModuleId(HttpServletRequest request){
        //设置当前模块
        Long currentId = RequestUtils.getLong(request,"m",null);
        //如果参数没传，从session中获取
        if(currentId == null){
            SysModuleDto currSysModuleDto = (SysModuleDto)request.getSession().getAttribute("currentModule");
            if(currSysModuleDto != null){
                currentId = currSysModuleDto.getId();
            }
        }
        return currentId;
    }

    /**
     * 获取当前登录用户的模块信息
     * @param request
     * @return
     */
    protected List<SysModuleDto> getUserModuleList(HttpServletRequest request){
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if(loginInfo == null){
            throw new BusinessException("登录信息失效");
        }
        List<SysModuleDto> currSysModuleDto = (List<SysModuleDto>)request.getSession().getAttribute("userModules");
        if(currSysModuleDto == null){
            RestResponse<List<SysModuleDto>> moduleResponse = sysModuleRemoteService.queryModulesByUserId(getAccessToken(),loginInfo.getId());
            if(!moduleResponse.success()){
                throw new BusinessException(moduleResponse.getErrorMsg());
            }
            currSysModuleDto = moduleResponse.getData();
        }
        return currSysModuleDto;
    }

    /**
     * 添加瞬时消息
     *
     * @param redirectAttributes
     *            RedirectAttributes
     * @param message
     *            消息
     */
    protected void addFlashMessage(RedirectAttributes redirectAttributes, String message) {
        if (redirectAttributes != null && message != null) {
            redirectAttributes.addFlashAttribute("flashMessage", message);
        }
    }

    protected void queryUserModuleMenus(HttpServletRequest request){

        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if(loginInfo == null){
            throw new BusinessException("登录信息失效");
        }
        //1.获取用户模块
        List<SysModuleDto> sysModuleDtos = loginUserInfoService.findUserModules();
        //为空不处理
        if(sysModuleDtos == null || sysModuleDtos.isEmpty()){
            return;
        }
        request.setAttribute("modules",sysModuleDtos);
        //存放当前用户模块信息
        request.getSession().setAttribute("userModules",sysModuleDtos);

        Long[] moduleIds = null;
        SysModuleDto sysModuleDto = null;

        //当前模块
        Long currentId = getCurrentModuleId(request);
        if(currentId != null){
            RestResponse<SysModuleDto> restResponse = sysModuleRemoteService.getModuleById(getAccessToken(),currentId);
            if(!restResponse.success()){
                throw new BusinessException(restResponse.getErrorMsg());
            }
            sysModuleDto = restResponse.getData();
            moduleIds = new Long[]{currentId};
        }else{
            moduleIds = new Long[sysModuleDtos.size()];
            for (int i = 0;i < moduleIds.length;i++) {
                Long moduleId = sysModuleDtos.get(i).getId();
                moduleIds[i] = moduleId;
                if(moduleId.equals(1L)){
                    //优先选择这个模块
                    sysModuleDto = sysModuleDtos.get(i);
                }
            }
            if(sysModuleDto == null){
                sysModuleDto = sysModuleDtos.get(0);
            }
            moduleIds = new Long[]{sysModuleDto.getId()};
        }
        //2.设置当前module到session中信息
        request.getSession().setAttribute("currentModule",sysModuleDto);
        request.setAttribute("currentModule",sysModuleDto);
        //3.获取菜单信息
        List<SysMenuDto> menuDtoList = loginUserInfoService.findByUserModule(moduleIds[0]);
        request.setAttribute("menus",menuDtoList);
    }

    //获取当前登录Token信息
    protected String getAccessToken(){
        String prefix = "【获取AccessToken】";
        //logger.info(prefix+"获取登录用户信息");
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if(loginInfo == null){
            logger.debug(prefix+"获取登录信息失败");
            Assert.notNull(loginInfo,"获取登录信息失败");
            return null;
        }
        return loginInfo.getAccess_token();
    }
}
