package com.qmx.admin.controller.common;

import com.qmx.admin.remoteapi.core.EmailRemoteService;
import com.qmx.admin.remoteapi.core.LoginRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.shiro.ShiroLoginToken;
import com.qmx.admin.shiro.ShiroLoginUtil;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.LoginTypeEnum;
import com.qmx.base.api.support.LoginInfo;
import com.qmx.base.core.constants.Constants;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.base.core.jcaptcha.JCaptchaUtil;
import com.qmx.base.core.utils.AccountValidatorUtil;
import com.qmx.base.core.utils.RequestUtils;
import com.qmx.base.core.utils.WebUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.util.SavedRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 登录controller
 * Created by liubin on 2017/8/23.
 */
@Controller
@RequestMapping("/login")
public class LoginRegisterController {

    private static Logger logger = LoggerFactory.getLogger(LoginRegisterController.class);

    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private LoginRemoteService loginRemoteService;
    @Autowired
    private EmailRemoteService emailRemoteService;

    /**
     * 进入登录页面
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method = RequestMethod.GET)
    public Object login(ModelMap model, HttpServletRequest request) {
        try {
            Subject subject = SecurityUtils.getSubject();
            //如果用户没有登录，跳转到登陆页面
            if (!subject.isAuthenticated()) {
                //登录失败时跳转到登陆页面
                model.addAttribute("needCaptcha", needCaptcha(request));
                model.addAllAttributes(RequestUtils.getRequestMap(request));
                return "/login/login";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "/";
    }

    @RequestMapping("/loginVerify")
    public String beforeLoginVerify(HttpServletRequest request,
                                    String account, String password,
                                    boolean rememberMe, String captcha) {
        //try {
        Subject subject = SecurityUtils.getSubject();
        //如果用户没有登录，跳转到登陆页面
        if (!subject.isAuthenticated()) {

            Assert.hasLength(account, "登录账号不能为空");
            Assert.hasLength(password, "登录密码不能为空");
            Boolean emailFlag = AccountValidatorUtil.isEmail(account);
            Boolean phoneFlag = AccountValidatorUtil.isMobile(account);

            if (emailFlag || phoneFlag) {
                String loginType = "EMAIL";
                String accountType = "邮箱";
                if (!emailFlag) {
                    loginType = "PHONE";
                    accountType = "手机";
                }
                password = DigestUtils.md5Hex(password);
                RestResponse<List<SysUserDto>> restResponse = loginRemoteService.findBindUserList(account, password);
                if (!restResponse.success()) {
                    throw new BusinessException(restResponse.getErrorMsg());
                }
                List<SysUserDto> userDtoList = restResponse.getData();
                if (userDtoList != null && !userDtoList.isEmpty()) {
                    request.setAttribute("userList", userDtoList);
                    request.setAttribute("rememberMe", rememberMe);
                    request.setAttribute("loginType", loginType);
                    request.setAttribute("captcha", captcha);
                    return "/login/login_type_list";
                } else {
                    request.setAttribute("errMsg", "密码错误或该" + accountType + "未绑定账号");
                    return "/login/login";
                }
            } else {
                RestResponse<SysUserDto> restResponse = loginRemoteService.findUserInfo(account, password);
                if (!restResponse.success()) {
                    throw new BusinessException(restResponse.getErrorMsg());
                }
                SysUserDto userDto = restResponse.getData();
                //如果没绑定
                if (userDto != null && !userDto.getBindEmail()) {
                    request.setAttribute("userInfo", userDto);
                    return "/login/login_bind_email";
                }
            }
            //rememberMe暂时false
            return doSubmitLogin(request, account, password, false, captcha, LoginTypeEnum.ACCOUNT);
        }
        return "/";
    }

    /**
     * 发送绑定邮件验证码
     *
     * @param request
     * @param account
     * @param captcha
     * @param email
     * @return
     */
    @ResponseBody
    @RequestMapping(path = "/sendBindEmailVerifyCode", method = RequestMethod.POST)
    public RestResponse sendBindEmailVerifyCode(HttpServletRequest request, String account, String captcha, String email) {

        if (!StringUtils.hasText(account)) {
            return RestResponse.fail("账号不能为空");
        }
        if (!StringUtils.hasText(captcha)) {
            return RestResponse.fail("验证码不能为空");
        }
        if (!StringUtils.hasText(email)) {
            return RestResponse.fail("邮箱不能为空");
        }

        if (!JCaptchaUtil.validateResponse(request, captcha)) {
            return RestResponse.fail("验证码错误");
        }

        RestResponse restResponse = emailRemoteService.sendBindUserEmailVerify(account, email);
        if (!restResponse.success()) {
            return RestResponse.fail(restResponse.getErrorMsg());
        }
        //判断是否需要填邮箱密码
        RestResponse<Boolean> pwdResponse = loginRemoteService.mobileOrEmailBinned(email);
        if (!pwdResponse.success()) {
            return RestResponse.fail(pwdResponse.getErrorMsg());
        }
        //成功页面
        return RestResponse.ok(!pwdResponse.getData());
    }

    /**
     * 绑定邮箱
     *
     * @param account
     * @param verifyCode
     * @param email
     * @return
     */
    @RequestMapping(path = "/bindUserEmail", method = RequestMethod.POST)
    public String bindUserEmail(String account, String verifyCode, String email, String newPwd) {
        Assert.notNull(account, "账号不能为空");
        Assert.notNull(verifyCode, "邮箱验证码不能为空");
        Assert.notNull(email, "邮箱不能为空");
        String newPassword = DigestUtils.md5Hex(newPwd);
        RestResponse restResponse = sysUserRemoteService.bindUserEmail(verifyCode, account, email, newPassword);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:bindEmailSuccess";
    }

    /**
     * 判断是否需要密码
     * @param email
     * @return
     */
    /*@ResponseBody
    @RequestMapping(path = "/needEmailPwd",method = RequestMethod.POST)
    public Boolean needEmailPwd(String email){
        //判断是否需要填邮箱密码
        RestResponse<Boolean> pwdResponse = loginRemoteService.needMobileOrEmailPwd(email);
        if (!pwdResponse.success()) {
           throw new BusinessException(pwdResponse.getErrorMsg());
        }
        return pwdResponse.getData();
    }*/


    /**
     * 绑定成功跳转页面
     *
     * @return
     */
    @RequestMapping(path = "/bindEmailSuccess")
    public String bindEmailSuccess() {
        return "/login/bind_email_success";
    }

    /**
     * 忘记密码
     *
     * @return
     */
    @RequestMapping(path = "/forgetPassword")
    public String forgetPassword() {
        return "/login/forget_pwd";
    }

    @ResponseBody
    @RequestMapping(path = "/sendForgetPwdEmailVerifyCode", method = RequestMethod.POST)
    public RestResponse sendForgetPwdEmailVerifyCode(HttpServletRequest request, String captcha, String email) {

        if (!StringUtils.hasText(captcha)) {
            return RestResponse.fail("验证码不能为空");
        }
        if (!StringUtils.hasText(email)) {
            return RestResponse.fail("邮箱不能为空");
        }
        if (!JCaptchaUtil.validateResponse(request, captcha)) {
            return RestResponse.fail("验证码错误");
        }
        RestResponse restResponse = emailRemoteService.sendForgetPwdEmailVerify(email);
        if (!restResponse.success()) {
            return RestResponse.fail(restResponse.getErrorMsg());
        }
        //成功页面
        return RestResponse.ok();
    }

    /**
     * 发送修改密码邮件
     *
     * @param request
     * @param captcha
     * @param email
     * @return
     */
    @ResponseBody
    @RequestMapping(path = "/sendModifyPwdEmailVerifyCode", method = RequestMethod.POST)
    public RestResponse sendModifyPwdEmailVerifyCode(HttpServletRequest request, String captcha, String email) {

        if (!StringUtils.hasText(captcha)) {
            return RestResponse.fail("验证码不能为空");
        }
        if (!JCaptchaUtil.validateResponse(request, captcha)) {
            return RestResponse.fail("验证码错误");
        }
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if (loginInfo == null) {
            throw new BusinessException("登录信息失效，请重新登录。");
        }
        RestResponse restResponse = emailRemoteService.sendModifyPwdEmailVerify(loginInfo.getAccess_token());
        if (!restResponse.success()) {
            return RestResponse.fail(restResponse.getErrorMsg());
        }
        //成功页面
        return RestResponse.ok();
    }

    /**
     * 发送修改邮箱验证码（如果email为空则发送验证码到原来的邮箱）
     *
     * @param request
     * @param captcha
     * @param email
     * @return
     */
    @ResponseBody
    @RequestMapping(path = "/sendModifyEmailVerifyCode", method = RequestMethod.POST)
    public RestResponse sendModifyEmailVerifyCode(HttpServletRequest request, String captcha, String email) {

        if (!StringUtils.hasText(captcha)) {
            return RestResponse.fail("验证码不能为空");
        }
        if (!JCaptchaUtil.validateResponse(request, captcha)) {
            return RestResponse.fail("验证码错误");
        }
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if (loginInfo == null) {
            throw new BusinessException("登录信息失效，请重新登录。");
        }
        RestResponse restResponse = null;
        if (StringUtils.hasText(email)) {
            restResponse = emailRemoteService.sendModifyBindNewEmailVerify(loginInfo.getAccess_token(), email);
        } else {
            restResponse = emailRemoteService.sendModifyBindEmailVerify(loginInfo.getAccess_token());
        }
        if (!restResponse.success()) {
            return RestResponse.fail(restResponse.getErrorMsg());
        }

        if(StringUtils.hasText(email)){
            //判断当前邮箱是否已绑定
            RestResponse<Boolean> pwdResponse = loginRemoteService.mobileOrEmailBinned(email);
            if (!pwdResponse.success()) {
                return RestResponse.fail(pwdResponse.getErrorMsg());
            }
            return RestResponse.ok(!pwdResponse.getData());//true表示已绑定过不需要密码，取反表示需要
        }
        //成功
        return RestResponse.ok();
    }

    /**
     * 通过邮箱修改密码
     *
     * @param verifyCode
     * @param email
     * @param newPwd
     * @return
     */
    @RequestMapping(path = "/updateUserPwdByEmail", method = RequestMethod.POST)
    public String updateUserPwdByEmail(String verifyCode, String email, String newPwd) {
        Assert.notNull(verifyCode, "邮箱验证码不能为空");
        Assert.notNull(email, "邮箱不能为空");
        Assert.hasText(newPwd, "新密码不能为空");
        String newPwd2 = DigestUtils.md5Hex(newPwd);
        RestResponse restResponse = sysUserRemoteService.updateUserPwdByEmail(verifyCode, email, newPwd2);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:updatePwdSuccess";
    }

    /**
     * 密码修改成功跳转页面
     *
     * @return
     */
    @RequestMapping(path = "/updatePwdSuccess")
    public String updatePwdSuccess() {
        return "/login/update_pwd_success";
    }


    /**
     * 执行登录操作(暂时默认邮件登录提交页面)
     *
     * @param request
     * @param account
     * @param password
     * @param rememberMe
     * @return
     */
    @RequestMapping(value = "/submitLogin", method = RequestMethod.POST)
    public String submitLogin(HttpServletRequest request,
                              String account, String password,
                              boolean rememberMe, String captcha) {
        /*try {
            doLogin(request, account, password, rememberMe, captcha);
        } catch (Exception e) {
            logger.warn(e.getMessage());
            setLoginErrorCount(request);
            request.setAttribute("errMsg", e.getMessage());
            return "/login/login";
        }
        //登录成功清除密码错误次数信息
        clearLoginErrorInfo(request);
        //成功页面
        return "redirect:/";*/
        return doSubmitLogin(request, account, password, rememberMe, captcha, LoginTypeEnum.EMAIL);
    }

    private String doSubmitLogin(HttpServletRequest request,
                                 String account, String password,
                                 boolean rememberMe, String captcha, LoginTypeEnum loginType) {
        try {
            doLogin(request, account, password, rememberMe, captcha, loginType);
        } catch (Exception e) {
            logger.warn(e.getMessage());
            setLoginErrorCount(request);
            request.setAttribute("errMsg", e.getMessage());
            return "/login/login";
        }
        //登录成功清除密码错误次数信息
        clearLoginErrorInfo(request);

        /**
         * 判断登录成功后，是否需要跳转到登录之前的页面
         */
        Subject subject = SecurityUtils.getSubject();
        if (subject.isAuthenticated()) {
            Session session = subject.getSession(false);
            if (session != null) {
                SavedRequest savedRequest = (SavedRequest) session.getAttribute("shiroSavedRequest");
                String requestURI = savedRequest.getRequestURI();
                if (requestURI.contains("/ta/m/")) {
                    return "redirect:" + requestURI;
                }
            }
        }

        //成功页面
        return "redirect:/";
    }

    /*@ResponseBody
    @RequestMapping(path = "/ajaxLogin", method = RequestMethod.POST)
    public RestResponse ajaxLogin(HttpServletRequest request,
                                  String username, String password,
                                  boolean rememberMe, String captcha) throws Exception{
        try{
            doLogin(request,username,password,rememberMe,captcha);
        }catch (Exception e){
            logger.warn("登录出错："+e.getMessage());
            setLoginErrorCount(request);
            return RestResponse.fail(e.getMessage());
        }
        //登录成功清除密码错误次数信息
        clearLoginErrorInfo(request);
        //成功页面
        return RestResponse.ok();
    }*/


    /**
     * 注册
     *
     * @param account
     * @param password
     * @param confirmPassword
     * @param phoneCode
     * @param pwdLevel
     * @param request
     * @param httpResponse
     * @return
     */
    @RequestMapping(path = "/submitRegister", method = RequestMethod.POST)
    @ResponseBody
    public RestResponse<String> submitRegister(
            String account, String password, String confirmPassword, String phoneCode,
            String pwdLevel, HttpServletRequest request, HttpServletResponse httpResponse) {
        return RestResponse.fail("暂未实现");
    }

    /**
     * 判断邮箱或者手机号是否已经被注册
     */
    @RequestMapping(path = "/checkRegister", method = RequestMethod.POST)
    @ResponseBody
    public RestResponse checkLogin(String account) {
        return RestResponse.fail("暂未实现");
    }

    private void doLogin(HttpServletRequest request, String username,
                         String password, Boolean rememberMe, String captcha, LoginTypeEnum loginType) {
        //验证码判断
        if (needCaptcha(request)) {
            Assert.notNull(captcha, "验证码不能为空");
            if (!JCaptchaUtil.validateResponse(request, captcha)) {
                throw new ValidationException("验证码错误");
            }
        }
        //其他判断
        Assert.notNull(username, "username不能为空");
        Assert.notNull(password, "password不能为空");
        Assert.notNull(loginType, "登录类型不能为空");
        Assert.notNull(rememberMe, "rememberMe不能为空");
        ShiroLoginToken token = new ShiroLoginToken(username, password, request.getRequestedSessionId(), "sss", rememberMe, RequestUtils.getIpAddr(request), request.getRequestedSessionId(), loginType);
        //执行登录
        ShiroLoginUtil.login(token);
    }


    /**
     * 清除密码错误次数信息
     *
     * @param request
     */
    private void clearLoginErrorInfo(HttpServletRequest request) {
        request.getSession().removeAttribute(Constants.PASSWORD_ERROR_COUNT);
    }

    /**
     * 判断是否需要验证码、
     * 默认密码输错2次后就需要
     *
     * @param request
     * @return
     */
    private Boolean needCaptcha(HttpServletRequest request) {
        try {
            Object obj = request.getSession().getAttribute(Constants.PASSWORD_ERROR_COUNT);
            Integer count = (obj == null) ? 0 : (Integer) obj;
            return count > 2;
            //return false;
        } catch (Exception e) {
            return true;
        }
        //return false;
    }

    /**
     * 设置密码错误次数
     *
     * @param request
     */
    private void setLoginErrorCount(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();
            Object obj = session.getAttribute(Constants.PASSWORD_ERROR_COUNT);
            int count = obj == null ? 1 : ((Integer) obj + 1);
            session.setAttribute(Constants.PASSWORD_ERROR_COUNT, count);
        } catch (Exception e) {
        }

    }
}
