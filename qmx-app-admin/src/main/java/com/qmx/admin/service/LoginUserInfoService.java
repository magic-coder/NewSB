package com.qmx.admin.service;

import com.qmx.admin.constants.AdminConstants;
import com.qmx.admin.remoteapi.core.SysMenuRemoteService;
import com.qmx.admin.remoteapi.core.SysModuleRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.core.UserChargeInfoRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.api.support.LoginInfo;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.base.core.utils.WebUtil;
import com.qmx.coreservice.api.user.dto.SysMenuDto;
import com.qmx.coreservice.api.user.dto.SysModuleDto;
import com.qmx.coreservice.api.user.dto.SysUserChargeInfoDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * @Author liubin
 * @Description 登录用户服务
 * @Date Created on 2018/5/14 16:43.
 * @Modified By
 */
@Service
public class LoginUserInfoService {

    private static final Logger logger = LoggerFactory.getLogger(LoginUserInfoService.class);

    @Autowired
    private UserChargeInfoRemoteService userChargeInfoRemoteService;
    @Autowired
    private SysUserRemoteService userRemoteService;
    @Autowired
    private RedisTemplate<String,Object> redisTemplate;
    @Autowired
    private SysMenuRemoteService sysMenuRemoteService;
    @Autowired
    private SysModuleRemoteService sysModuleRemoteService;

    private static Integer timeout = 10;//缓存时间10分钟

    /**
     * 获取当前登录用户信息
     * @return
     */
    public SysUserDto getCurrentUser(){
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if(loginInfo != null){
            Long userId = loginInfo.getId();
            String cacheKey = AdminConstants.CACHE_NAMESPACE+"currentLoginUserInfo:"+userId;
            SysUserDto userDto = (SysUserDto) redisTemplate.boundValueOps(cacheKey).get();
            if(userDto == null){
                RestResponse<SysUserDto> restResponse = userRemoteService.findById(userId);
                if(restResponse.success()){
                    SysUserDto sysUserDto = restResponse.getData();
                    if(sysUserDto != null){
                        redisTemplate.boundValueOps(cacheKey).set(sysUserDto,timeout, TimeUnit.MINUTES);
                    }
                    return restResponse.getData();
                }
            }
            return userDto;
        }
        return null;
    }

    /**
     * 获取当前登录用户（非员工）信息
     * @return
     */
    public SysUserDto getCurrentMember(){
        SysUserDto currentUser = this.getCurrentUser();
        if(currentUser != null && currentUser.getUserType() == SysUserType.employee){
            Long userId = currentUser.getMemberId();
            String cacheKey = AdminConstants.CACHE_NAMESPACE+"currentLoginUserInfo:"+userId;
            SysUserDto userDto = (SysUserDto) redisTemplate.boundValueOps(cacheKey).get();
            if(userDto == null){
                RestResponse<SysUserDto> restResponse = userRemoteService.findById(userId);
                if(restResponse.success()){
                    SysUserDto sysUserDto = restResponse.getData();
                    if(sysUserDto != null){
                        redisTemplate.boundValueOps(cacheKey).set(sysUserDto,timeout, TimeUnit.MINUTES);
                    }
                    return restResponse.getData();
                }
            }
        }
        return currentUser;
    }

    /**
     * 获取当前用户供应商信息（一般分销商使用）
     * @return
     */
    public SysUserDto getCurrentSupplier(){
        SysUserDto currentMember = this.getCurrentMember();
        if(currentMember != null && currentMember.getUserType() == SysUserType.distributor){
            Long userId = currentMember.getSupplierId();
            String cacheKey = AdminConstants.CACHE_NAMESPACE+"currentLoginUserInfo:"+userId;
            SysUserDto userDto = (SysUserDto) redisTemplate.boundValueOps(cacheKey).get();
            if(userDto == null){
                RestResponse<SysUserDto> restResponse = userRemoteService.findById(userId);
                if(restResponse.success()){
                    SysUserDto sysUserDto = restResponse.getData();
                    if(sysUserDto != null){
                        redisTemplate.boundValueOps(cacheKey).set(sysUserDto,timeout, TimeUnit.MINUTES);
                    }
                    return restResponse.getData();
                }
            }
        }
        return currentMember;
    }

    /**
     * 获取用户计费信息
     * @return
     */
    public SysUserChargeInfoDTO findUserChargeInfo(){
        SysUserDto currentSupplier = getCurrentSupplier();
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        if(currentSupplier != null && loginInfo != null &&
                (currentSupplier.getUserType() == SysUserType.supplier || currentSupplier.getUserType() == SysUserType.group_supplier)){
            Long userId = currentSupplier.getId();
            String cacheKey = AdminConstants.CACHE_NAMESPACE+"userChargeInfo:" + userId;
            SysUserChargeInfoDTO userChargeInfoDTO = (SysUserChargeInfoDTO)redisTemplate.boundValueOps(cacheKey).get();
            if(userChargeInfoDTO == null){
                RestResponse<SysUserChargeInfoDTO> restResponse = userChargeInfoRemoteService.findUserChargeInfo(loginInfo.getAccess_token(),userId);
                if(restResponse.success()){
                    SysUserChargeInfoDTO sysUserChargeInfoDTO = restResponse.getData();
                    if(sysUserChargeInfoDTO != null){
                        redisTemplate.boundValueOps(cacheKey).set(userChargeInfoDTO,timeout,TimeUnit.MINUTES);
                    }
                    return sysUserChargeInfoDTO;
                }else{
                    logger.warn("获取用户信息失败："+ JSONUtil.toJson(restResponse));
                }
            }
        }

        return null;
    }

    /**
     * 查询用户模块列表
     * @return
     */
    public List<SysModuleDto> findUserModules(){
        //1.获取用户模块
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        Assert.notNull(loginInfo,"获取登录信息失败");
        String cacheKey = AdminConstants.CACHE_NAMESPACE+"userUserModules:" + loginInfo.getId();
        List<SysModuleDto> moduleDtoList = (List<SysModuleDto>)redisTemplate.boundValueOps(cacheKey).get();
        if(moduleDtoList == null){
            RestResponse<List<SysModuleDto>> moduleResponse = sysModuleRemoteService.queryModulesByUserId(loginInfo.getAccess_token(),loginInfo.getId());
            if(!moduleResponse.success()){
                throw new BusinessException(moduleResponse.getErrorMsg());
            }
            moduleDtoList = moduleResponse.getData();
            if(moduleDtoList != null){
                redisTemplate.boundValueOps(cacheKey).set(moduleDtoList,timeout,TimeUnit.MINUTES);
            }
        }
        return moduleDtoList;
    }

    /**
     * 查询用户菜单信息
     * @param moduleId
     * @return
     */
    public List<SysMenuDto> findByUserModule(Long moduleId){
        Long[] moduleIds = new Long[]{moduleId};
        //1.获取用户模块
        LoginInfo loginInfo = WebUtil.getCurrentUser();
        Assert.notNull(loginInfo,"获取登录信息失败");
        //3.获取菜单信息
        String cacheKey = AdminConstants.CACHE_NAMESPACE+"userModuleMenus:" + loginInfo.getId()+":"+moduleId;
        List<SysMenuDto> menuDtoList = (List<SysMenuDto>)redisTemplate.boundValueOps(cacheKey).get();
        if(menuDtoList == null){
            RestResponse<List<SysMenuDto>> authorizes = sysMenuRemoteService.queryByModuleAndUserId(loginInfo.getAccess_token(),moduleIds);
            if(authorizes != null && authorizes.success()){
                menuDtoList = authorizes.getData();
                if(menuDtoList != null){
                    redisTemplate.boundValueOps(cacheKey).set(menuDtoList,timeout,TimeUnit.MINUTES);
                }
            }else{
                throw new BusinessException(authorizes.getErrorMsg());
            }
        }
        return menuDtoList;
    }
}
