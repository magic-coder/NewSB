package com.qmx.admin.shiro;

import com.qmx.base.api.enumerate.LoginTypeEnum;
import org.apache.shiro.authc.UsernamePasswordToken;

/**
 * 登录token
 * Created by Administrator on 2017/8/7.
 */
public class ShiroLoginToken extends UsernamePasswordToken {
    private static final long serialVersionUID = 5898441540965086534L;

    /**  */
    private String appKey;

    /**  */
    private String privateKey;

    /** 验证码ID */
    private String captchaId;

    /** 验证码 */
    private String captcha;

    /** 登陆方式 */
    private LoginTypeEnum loginType;

    /**  */
    private String sessionId;

    /**
     * @param username
     *            用户名
     * @param password
     *            密码
     * @param captchaId
     *            验证码ID
     * @param captcha
     *            验证码
     * @param rememberMe
     *            记住我
     * @param host
     *            IP
     */
    public ShiroLoginToken(String username, String password, String captchaId, String captcha, boolean rememberMe, String host, String sessionId) {
        this(username,password,captchaId,captcha,rememberMe,host,sessionId,LoginTypeEnum.ACCOUNT);
    }
    public ShiroLoginToken(String username, String password, String captchaId, String captcha, boolean rememberMe, String host, String sessionId,LoginTypeEnum loginType) {
        super(username, password, rememberMe);
        this.captchaId = captchaId;
        this.captcha = captcha;
        this.setHost(host);
        this.loginType = loginType;
        this.sessionId = sessionId;
    }

    public ShiroLoginToken(String username, String password, boolean rememberMe, String host, String sessionId) {
        this(username, password, rememberMe, host, sessionId,LoginTypeEnum.ACCOUNT);
    }
    public ShiroLoginToken(String username, String password, boolean rememberMe, String host, String sessionId,LoginTypeEnum loginType) {
        super(username, password, rememberMe);
        this.setHost(host);
        this.loginType = loginType;
        this.sessionId = sessionId;
    }

    /**
     *
     * @param appKey
     * @param privateKey
     */
    /*public ShiroLoginToken(String username, String appKey, String privateKey, String host, String sessionId) {
        super(username, privateKey, false);
        this.appKey = appKey;
        this.privateKey = privateKey;
        this.setHost(host);
        this.loginType = "app";
        this.sessionId = sessionId;
    }*/

    /**
     * 获取验证码ID
     *
     * @return 验证码ID
     */
    public String getCaptchaId() {
        return captchaId;
    }

    /**
     * 设置验证码ID
     *
     * @param captchaId
     *            验证码ID
     */
    public void setCaptchaId(String captchaId) {
        this.captchaId = captchaId;
    }

    /**
     * 获取验证码
     *
     * @return 验证码
     */
    public String getCaptcha() {
        return captcha;
    }

    /**
     * 设置验证码
     *
     * @param captcha
     *            验证码
     */
    public void setCaptcha(String captcha) {
        this.captcha = captcha;
    }

    public String getAppKey() {
        return appKey;
    }

    public void setAppKey(String appKey) {
        this.appKey = appKey;
    }

    public String getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    public LoginTypeEnum getLoginType() {
        return loginType;
    }

    public void setLoginType(LoginTypeEnum loginType) {
        this.loginType = loginType;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
}
