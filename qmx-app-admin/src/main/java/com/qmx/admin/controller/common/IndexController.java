package com.qmx.admin.controller.common;
import com.qmx.admin.interceptor.MessageNotifyInterceptor;
import com.qmx.admin.remoteapi.core.*;
import com.qmx.admin.service.LoginUserInfoService;
import com.qmx.admin.shiro.ShiroLoginToken;
import com.qmx.admin.shiro.ShiroLoginUtil;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.LoginTypeEnum;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.api.support.LoginInfo;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.security.AESCoder;
import com.qmx.base.core.security.RSACoder;
import com.qmx.base.core.utils.AccountValidatorUtil;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.base.core.utils.RequestUtils;
import com.qmx.base.core.utils.WebUtil;
import com.qmx.coreservice.api.user.dto.SysMessageDTO;
import com.qmx.coreservice.api.user.dto.SysUserChargeInfoDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.web.session.HttpServletSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * @Author liubin
 * @Description
 * @Date Created on 2017/11/28 14:36.
 * @Modified By
 */
@Controller
//@RequestMapping("/common")
public class IndexController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(IndexController.class);
    @Autowired
    private SysUserRemoteService userService;
    @Autowired
    private LoginRemoteService loginRemoteService;
    @Autowired
    private SysMessageRemoteService sysMessageRemoteService;
    @Autowired
    private UserChargeInfoRemoteService userChargeInfoRemoteService;
    @Autowired
    private SmsRemoteService smsRemoteService;
    @Autowired
    private LoginUserInfoService loginUserInfoService;

    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 EEE", Locale.CHINA);

    /*@RequestMapping("/")
    public String index(HttpServletRequest request, HttpServletResponse response, ModelMap model){
        return "redirect:main";
    }*/

    /**
     * 检测用户名是否合法
     * @param username
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkUserName")
    public RestResponse<Boolean> checkUserName(String username){
        Assert.notNull(username,"用户名不能为空");
        if(AccountValidatorUtil.isUsername(username)){
            return RestResponse.ok(Boolean.TRUE);
        }
        return RestResponse.fail("用户名只能以字母、数字、‘-’和‘_’组成,并且只能以字母开头,长度6-20位");
    }

    /**
     * 主页
     * @param request
     * @return
     */
    @RequestMapping("/homePage")
    public String homePage(HttpServletRequest request){


        HttpSession httpSession = request.getSession();
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        //用户信息
        SysUserDto sysUserDto = null;//(SysUserDto)httpSession.getAttribute("homeUserInfo");
        SysUserDto currentMember = null;//(SysUserDto)httpSession.getAttribute("homeMemberInfo");
        SysMessageDTO sysMessageDTO = (SysMessageDTO)httpSession.getAttribute("session_SysMessage");
        Date lastUpdateTime = (Date) httpSession.getAttribute("smsLastUpdatTime");//短信最近更新时间

        if(currentMember == null){
            currentMember = getCurrentMember();
            httpSession.setAttribute("homeMemberInfo",currentMember);
        }

        if(lastUpdateTime == null){
            lastUpdateTime = new Date();
        }

        if(sysMessageDTO == null){
            //消息信息
            RestResponse<SysMessageDTO> restResponse = sysMessageRemoteService.findLastMessage(loginInfo.getAccess_token());
            if(restResponse.success()){
                sysMessageDTO = restResponse.getData();
                httpSession.setAttribute("session_SysMessage",sysMessageDTO);
            }else{
                logger.warn("获取消息信息失败："+ JSONUtil.toJson(restResponse));
            }
        }

        if(sysUserDto == null){
            sysUserDto  = getCurrentUser();
            if(sysUserDto != null){
                httpSession.setAttribute("homeUserInfo",sysUserDto);
            }

            if(sysUserDto.getUserType() == SysUserType.supplier || sysUserDto.getUserType() == SysUserType.group_supplier) {
                //费用信息
                SysUserChargeInfoDTO userChargeInfoDTO = loginUserInfoService.findUserChargeInfo();
                if (userChargeInfoDTO != null) {
                    request.setAttribute("userChargeInfo", userChargeInfoDTO);
                }
                lastUpdateTime = new Date();
                httpSession.setAttribute("smsLastUpdatTime", lastUpdateTime);
            }

            if(sysUserDto.getUserType() == SysUserType.supplier || sysUserDto.getUserType() == SysUserType.group_supplier || sysUserDto.getUserType() == SysUserType.admin){
                    //短信数量
                RestResponse<Long> smsCountResponse = smsRemoteService.findSendSmsCount(getAccessToken());
                if (smsCountResponse.success()) {
                    Long smsCount = smsCountResponse.getData();
                    if (smsCount == null) {
                        smsCount = 0L;
                    }
                    request.setAttribute("smsCount", smsCount);
                } else {
                    logger.warn("获取短信信息失败：" + JSONUtil.toJson(smsCountResponse));
                }
            }
        }

        request.setAttribute("lastSysMessage",sysMessageDTO);
        request.setAttribute("dateTime",sdf.format(new Date()));
        request.setAttribute("lastUpdateTime",lastUpdateTime);
        request.setAttribute("homeUserInfo",sysUserDto);
        request.setAttribute("homeMemberInfo",currentMember);
        return "/common/home";
    }

    /**
     * 修改密码
     * @return
     */
    @RequestMapping("/modifyUserPwd")
    public String modifyUserPwd(HttpServletRequest request){
        //LoginInfo loginInfo = WebUtil.getCurrentUser();
        request.setAttribute("dateTime",sdf.format(new Date()));
        return "/user/user_info/modify_pwd";
    }

    /**
     * 执行修改密码
     * @param verifyCode
     * @param newPwd
     * @return
     */
    @RequestMapping("/doModifyUserPwd")
    public String doModifyUserPwd(String verifyCode,String newPwd){
        Assert.hasText(verifyCode,"验证码不能为空");
        Assert.hasText(newPwd,"新密码不能为空");
        newPwd = DigestUtils.md5Hex(newPwd);
        RestResponse<Boolean> restResponse = userService.modifyUserPassword(getAccessToken(),verifyCode,newPwd);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SecurityUtils.getSubject().logout();//退出重新登录
        return "redirect:/";
    }

    /**
     * 切换登录账号
     * @param request
     * @param account
     * @return
     */
    @RequestMapping("/changeAccount")
    public String changeAccount(HttpServletRequest request,String account){
        Assert.hasText(account,"账号不能为空");
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if(loginInfo != null){
            String requestSessionId = request.getRequestedSessionId();
            String password = null;
            if(loginInfo.getLoginType() == LoginTypeEnum.EMAIL){
                password = loginInfo.getEmailLoginPwd();
            }else if(loginInfo.getLoginType() == LoginTypeEnum.PHONE){
                password = loginInfo.getPhoneLoginPwd();
            }else {
                //不处理
                return "redirect:/";
            }
            //执行登录
            ShiroLoginToken token = new ShiroLoginToken(account, password, requestSessionId, "sss", false, RequestUtils.getIpAddr(request), requestSessionId,LoginTypeEnum.EMAIL);
            ShiroLoginUtil.login(token);
        }
        return "redirect:/";
    }

    @RequestMapping("/")
    public String main(HttpServletRequest request,ModelMap model){
        //获取用户信息
        super.queryUserInfo(model);
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if(loginInfo != null){
            SysUserDto sysUserDto = getCurrentUser();
            //如果是邮箱登录才能切换
            if(sysUserDto != null && loginInfo.getLoginType() == LoginTypeEnum.EMAIL){
                //暂时邮箱（因为邮箱必填）
                String account = sysUserDto.getEmail();
                String password = sysUserDto.getEmailLoginPwd();
                RestResponse<List<SysUserDto>> restResponse = loginRemoteService.findBindUserList(account,password);
                if(restResponse != null && restResponse.success()){
                    List<SysUserDto> userDtoList = restResponse.getData();
                    //数量为1的是自己
                    if(!userDtoList.isEmpty() && userDtoList.size() != 1){
                        model.addAttribute("bindUserList",userDtoList);
                    }
                }else{
                    logger.warn("获取登录信息失败："+ JSONUtil.toJson(restResponse));
                }
            }
        }

        //获取菜单信息
        //super.queryUserMenus(model);
        super.queryUserModuleMenus(request);
        //获取消息/公告
        checkMessage(request,loginInfo.getAccess_token());
        //获取账户余额信息

        return "/common/main";
    }

    /**
     * 检查消息
     * @param request
     * @param accessToken
     */
    private void checkMessage(HttpServletRequest request,String accessToken){
        //检查消息
        RestResponse<SysMessageDTO> restResponse = sysMessageRemoteService.findLastUnRead(accessToken);
        if(restResponse.success()){
            SysMessageDTO sysMessageDTO = restResponse.getData();
            if(sysMessageDTO != null){
                System.out.println(JSONUtil.toJson(sysMessageDTO));
                request.setAttribute("sysMessage",sysMessageDTO);
            }
        }else{
            logger.warn("获取用户信息失败："+ JSONUtil.toJson(restResponse));
        }
    }

    /**
     * 修改邮箱页面
     * @param request
     * @return
     */
    @RequestMapping("/modifyUserEmail")
    public String modifyUserEmail(HttpServletRequest request){
        return "/user/user_info/modify_email";
    }

    /**
     * 修改邮箱页面（原邮箱验证成功后跳转新页面）
     * @return
     */
    @RequestMapping(value = "/modifyUserEmailVerify",method = RequestMethod.POST)
    public String modifyUserEmailVerify(String verifyCode){
        Assert.notNull(verifyCode,"验证码不能为空");
        RestResponse<Boolean> restResponse = userService.modifyUserEmailVerify(getAccessToken(),verifyCode);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "/user/user_info/modify_email_new";
    }

    /**
     * 执行修改邮箱
     * @return
     */
    @RequestMapping(value = "/doModifyUserEmailVerify",method = RequestMethod.POST)
    public String doModifyUserEmailVerify(String email,String verifyCode,String newPwd,Boolean updateAll){
        Assert.notNull(email,"邮箱不能为空");
        Assert.notNull(verifyCode,"验证码不能为空");
        if(updateAll == null){
            updateAll =  false;
        }
        RestResponse<Boolean> restResponse = userService.doModifyNewUserEmail(getAccessToken(),verifyCode,email,newPwd,updateAll);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:/homePage";
    }
}
