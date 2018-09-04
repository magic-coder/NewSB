package com.qmx.admin.shiro;
import com.alibaba.fastjson.JSONObject;
import com.netflix.hystrix.exception.HystrixRuntimeException;
import com.qmx.admin.remoteapi.core.LoginRemoteService;
import com.qmx.admin.remoteapi.core.SysPermissionRemoteService;
import com.qmx.admin.remoteapi.core.SysRoleRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.LoginTypeEnum;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.api.support.LoginInfo;
import com.qmx.base.core.utils.DataUtil;
import com.qmx.base.core.utils.WebUtil;
import com.qmx.coreservice.api.user.dto.*;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.session.data.redis.RedisOperationsSessionRepository;

import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class ShiroLoginRealm extends AuthorizingRealm {

    private static final Logger logger = LoggerFactory.getLogger(ShiroLoginRealm.class);

    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private LoginRemoteService loginRemoteService;
    @Autowired
    private SysRoleRemoteService sysRoleRemoteService;
    //@Autowired
    //private SysPermissionRemoteService sysPermissionRemoteService;
    //@Autowired
    //private RedisOperationsSessionRepository sessionRepository;
    /**
     * 认证信息.(身份验证)
     * @param token
     * @return
     * @throws AuthenticationException
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        ShiroLoginToken authenticationToken = (ShiroLoginToken) token;
        try{

            String username = authenticationToken.getUsername();
            String password = new String(authenticationToken.getPassword());

            RestResponse<TokenInfo> loginResult = loginRemoteService.login(username,password,authenticationToken.getLoginType());
            if(loginResult == null){
                logger.warn("USER [{}] GET TOKEN ERROR", username);
                throw new AuthenticationException("用户名或密码错误");
            }

            if(!loginResult.success()){
                logger.warn("USER [{}] GET TOKEN ERROR:[{}]", username,loginResult);
                throw new AuthenticationException(loginResult.getErrorMsg());
            }

            TokenInfo tokenInfo = loginResult.getData();
            RestResponse<SysUserDto> resp = sysUserRemoteService.findByAccount(tokenInfo.getToken(),username);
            SysUserDto userDto = resp.getData();
            if (resp == null) {
                logger.warn("获取用户信息失败: {}",username);
                throw new AuthenticationException("获取用户信息失败，请稍后重试");
            }
            if (!resp.success() || userDto == null) {
                logger.warn("No user: {}",username);
                logger.warn("login error: {}",resp.getErrorMsg());
                throw new AuthenticationException(resp.getErrorMsg());
            }
            //其他判断（角色，是否启用等）
            if(userDto.getLocked()){
                throw new LockedAccountException();
            }

            //判断登录类型，取出相应密码
            String userPwd = userDto.getPassword();
            if(authenticationToken.getLoginType() == LoginTypeEnum.EMAIL){
                userPwd = userDto.getEmailLoginPwd();
            }else if(authenticationToken.getLoginType() == LoginTypeEnum.PHONE){
                userPwd = userDto.getPhoneLoginPwd();
            }
            //密码判断
            if(userPwd.equalsIgnoreCase(password)){
                //先比较原密码
            }else if (!DigestUtils.md5Hex(password).equals(userPwd)) {
                //登录失败处理
                logger.warn("USER [{}] PASSWORD IS WRONG: {}", username, password);
                throw new IncorrectCredentialsException();
            }
            //登录成功处理（获取token）
            //认证成功保存信息
            Boolean isEmployee = userDto.getUserType() == SysUserType.employee;
            LoginInfo loginInfo = new LoginInfo(userDto.getId(), username, userDto.getUserType(), isEmployee, userDto.getMemberId(),userDto.getSupplierId(),userDto.getGroupSupplierId(),userDto.getPassword(),authenticationToken.getLoginType());
            loginInfo.setEmailLoginPwd(userDto.getEmailLoginPwd());
            loginInfo.setPhoneLoginPwd(userDto.getPhoneLoginPwd());
            loginInfo.setAccess_token(tokenInfo.getToken());
            loginInfo.setTokenExp(tokenInfo.getExp());
            WebUtil.saveCurrentUser(loginInfo);
            //loginSessionService.saveSessions(userDto.getAccount());
            return new SimpleAuthenticationInfo(loginInfo, password, getName());
        }catch (IncorrectCredentialsException e){
            throw e;
        }catch (LockedAccountException e){
            throw e;
        }catch (AuthenticationException e){
            throw e;
        }catch (HystrixRuntimeException e){
            logger.warn(e.getMessage(),e);
            throw new AuthenticationException("系统服务异常，请稍后重试。");
        }catch (Exception e){
            throw new AuthenticationException("登录失败："+e.getMessage());
        }
    }


    /**
     * 此方法调用  hasRole,hasPermission的时候才会进行回调.
     *
     * 权限信息.(授权):
     * 1、如果用户正常退出，缓存自动清空；
     * 2、如果用户非正常退出，缓存自动清空；
     * 3、如果我们修改了用户的权限，而用户不退出系统，修改的权限无法立即生效。
     * （需要手动编程进行实现；放在service进行调用）
     * 在权限修改后调用realm中的方法，realm已经由spring管理，所以从spring中获取realm实例，
     * 调用clearCached方法；
     * :Authorization 是授权访问控制，用于对用户进行的操作授权，证明该用户是否允许进行当前操作，如访问某个链接，某个资源文件等。
     * @param principalCollection
     * @return
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        LoginInfo principal = (LoginInfo) principalCollection.getPrimaryPrincipal();
        if (principal != null) {
            SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
            String access_token = principal.getAccess_token();
            if(DataUtil.isNotEmpty(access_token)){
                RestResponse<RolesAndPermissionsDTO> restResponse = sysRoleRemoteService.findRolesAndPermissions(access_token,principal.getId());
                if(restResponse != null && restResponse.success()){
                    RolesAndPermissionsDTO rolesAndPermissionsDTO = restResponse.getData();
                    List<SysRoleDto> sysRoleDtoList = rolesAndPermissionsDTO.getRoleDtoList();
                    //设置角色
                    if(sysRoleDtoList != null){
                        for (SysRoleDto dto : sysRoleDtoList) {
                            if(DataUtil.isNotEmpty(dto.getCode())){
                                authorizationInfo.addRole(dto.getCode());
                            }
                        }
                    }
                    authorizationInfo.addRole(principal.getUserType().name());
                    List<SysPermissionDto> sysPermissionDtoList = rolesAndPermissionsDTO.getPermissionDtoList();
                    //设置权限
                    if(sysPermissionDtoList != null){
                        for (SysPermissionDto dto : sysPermissionDtoList){
                            if(DataUtil.isNotEmpty(dto.getPermission())){
                                authorizationInfo.addStringPermission(dto.getPermission());
                            }
                        }
                    }
                }else {
                    logger.warn("获取权限失败:"+ JSONObject.toJSONString(restResponse));
                }
            }
            return authorizationInfo;
        }
        return null;
    }

    @Override
    public void clearCachedAuthorizationInfo(PrincipalCollection principals) {
        super.clearCachedAuthorizationInfo(principals);
    }

    @Override
    public void clearCachedAuthenticationInfo(PrincipalCollection principals) {
        super.clearCachedAuthenticationInfo(principals);
    }

    @Override
    public void clearCache(PrincipalCollection principals) {
        super.clearCache(principals);
    }

    public void clearAllCachedAuthorizationInfo() {
        getAuthorizationCache().clear();
    }

    public void clearAllCachedAuthenticationInfo() {
        getAuthenticationCache().clear();
    }

    public void clearAllCache() {
        clearAllCachedAuthenticationInfo();
        clearAllCachedAuthorizationInfo();
    }
}