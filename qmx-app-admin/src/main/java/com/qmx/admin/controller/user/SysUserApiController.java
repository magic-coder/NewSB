package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysOrderSourceRemoteService;
import com.qmx.admin.remoteapi.core.SysUserApiRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysOrderSourceDTO;
import com.qmx.coreservice.api.user.dto.SysUserApiDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.APIPlatEnum;
import com.qmx.coreservice.api.user.enumerate.APPTypeEnum;
import com.qmx.coreservice.api.user.enumerate.PayMethodEnum;
import com.qmx.coreservice.api.user.query.SysUserApiVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author liubin
 * @Description 系统用户api服务
 * @Date Created on 2018/2/9 15:17.
 * @Modified By
 */
@Controller
@RequestMapping("/userApi")
public class SysUserApiController extends BaseController {

    @Autowired
    private SysUserApiRemoteService sysUserApiRemoteService;
    //@Autowired
    //private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysOrderSourceRemoteService sysOrderSourceRemoteService;

    /**
     * 查看景区接口信息
     * @param request
     * @param sightId
     * @return
     */
    @RequestMapping(value = "/apiInfo", method = RequestMethod.GET)
    public String apiInfo(HttpServletRequest request,Long sightId,Long userId){
        RestResponse<SysUserApiDTO> restResponse = null;
        if(userId != null){
            restResponse = sysUserApiRemoteService.findUserApiInfo(getAccessToken(),userId);
        }else {
            Assert.notNull(sightId,"sightId和userId不能同时为空");
            restResponse = sysUserApiRemoteService.findSightApiInfo(getAccessToken(),sightId);
        }
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("apiInfo",restResponse.getData());
        return "/user/user_api/api_info";
    }

    /**
     * 获取用户系统用户api分页
     *
     * @param request
     * @param sysUserApiVO
     * @return
     */
    @RequestMapping(path = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request, SysUserApiVO sysUserApiVO) {
        sysUserApiVO.setAppType(APPTypeEnum.USER);
        RestResponse<PageDto<SysUserApiDTO>> restResponse = sysUserApiRemoteService.findPage(getAccessToken(), sysUserApiVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysUserApiVO);
        request.setAttribute("apiPlats", APIPlatEnum.values());
        request.setAttribute("page", restResponse.getData());
        return "/user/user_api/list";
    }

    /**
     * 根据id获取系统用户api
     *
     * @return
     */
    @RequestMapping(path = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request) {
        request.setAttribute("apiPlats", APIPlatEnum.values());

        List<PayMethodEnum> list = new ArrayList<>();
        list.add(PayMethodEnum.OFFLINE_PAY);
        list.add(PayMethodEnum.DEPOSIT);
        list.add(PayMethodEnum.DEPOSIT_CREDIT);
        request.setAttribute("payMethods", list);

        RestResponse<List<SysOrderSourceDTO>> listRestResponse = sysOrderSourceRemoteService.findSysOtaModuleId(getAccessToken(),null);
        if(!listRestResponse.success()){
            throw new BusinessException(listRestResponse.getErrorMsg());
        }
        request.setAttribute("orderSources",listRestResponse.getData());
        return "/user/user_api/add";
    }

    /**
     * 添加系统用户接口
     *
     * @param sysUserApiDTO
     * @return
     */
    @RequestMapping(path = "/save", method = RequestMethod.POST)
    public String save(SysUserApiDTO sysUserApiDTO) {
        Assert.notNull(sysUserApiDTO, "系统接口用户信息不能为空");
        Assert.notNull(sysUserApiDTO.getUserId(), "系统接口用户id不能为空");
        Assert.notNull(sysUserApiDTO.getPayMethod(), "系统接口用户支付方式不能为空");
        Assert.notNull(sysUserApiDTO.getOrderSourceId(), "系统接口用户订单来源id不能为空");

        RestResponse<SysUserApiDTO> restResponse = sysUserApiRemoteService.createUserApi(getAccessToken(), sysUserApiDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 根据id获取系统用户api
     *
     * @param id
     * @return
     */
    @RequestMapping(path = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysUserApiDTO> restResponse = sysUserApiRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("payMethods", PayMethodEnum.values());
        request.setAttribute("dto", restResponse.getData());
        RestResponse<List<SysOrderSourceDTO>> listRestResponse = sysOrderSourceRemoteService.findSysOtaModuleId(getAccessToken(),null);
        if(!listRestResponse.success()){
            throw new BusinessException(listRestResponse.getErrorMsg());
        }
        request.setAttribute("orderSources",listRestResponse.getData());
        return "/user/user_api/edit";
    }

    /**
     * 修改系统用户接口
     *
     * @param sysUserApiDTO
     * @return
     */
    @RequestMapping(path = "/update", method = {RequestMethod.POST})
    public String update(SysUserApiDTO sysUserApiDTO) {
        Assert.notNull(sysUserApiDTO, "系统接口用户信息不能为空");
        Assert.notNull(sysUserApiDTO.getId(), "系统接口用户id不能为空");
        Assert.notNull(sysUserApiDTO.getOrderSourceId(), "系统接口用户订单来源id不能为空");
        RestResponse<SysUserApiDTO> restResponse = sysUserApiRemoteService.updateUserApi(getAccessToken(), sysUserApiDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 通过id删除用户api
     *
     * @param id
     * @return
     */
    @RequestMapping(path = "/delete", method = {RequestMethod.POST})
    public String delete(Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = sysUserApiRemoteService.delete(getAccessToken(), new Long[]{id});
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}