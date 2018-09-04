package com.qmx.admin.shiro;
import com.qmx.base.core.exception.LoginException;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.ExpiredCredentialsException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 登录辅助类
 * Created by liubin on 2017/8/7.
 */
public class ShiroLoginUtil {

    private static final Logger logger = LoggerFactory.getLogger(ShiroLoginUtil.class);

    private ShiroLoginUtil() {
    }

    /** 用户登录 */
    public static final Boolean login(ShiroLoginToken token) {
        Subject subject = SecurityUtils.getSubject();
        try {
            subject.login(token);
            return subject.isAuthenticated();
        } catch (ExpiredCredentialsException e) {
            throw new LoginException("验证码错误");
        }catch (UnknownAccountException e){
            throw new LoginException("账号不存在");
        }catch (IncorrectCredentialsException e){
            throw new LoginException("密码不正确");
        }catch (Exception e){
            throw new LoginException(e.getMessage());
        }
    }

    /** 判断是否登录*/
    public static final Boolean isLogin() {
        Subject subject = SecurityUtils.getSubject();
        try {
            return subject.isAuthenticated();
        } catch (Exception e) {
            logger.error(e.getMessage());
            return false;
        }
    }

    /** 判断rememberMe*/
    public static final Boolean isRemembered() {
        Subject subject = SecurityUtils.getSubject();
        try {
            return subject.isRemembered();
        } catch (Exception e) {
            logger.error(e.getMessage());
            return false;
        }
    }

}
