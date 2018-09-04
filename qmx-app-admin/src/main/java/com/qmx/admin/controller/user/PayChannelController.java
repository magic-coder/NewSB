package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysPayChannelRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.pay.dto.SysPayChannelDto;
import com.qmx.coreservice.api.pay.enumerate.PayPlatEnum;
import com.qmx.coreservice.api.pay.query.SysPayChannelVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @Author liubin
 * @Description 支付渠道管理
 * @Date Created on 2017/12/29 16:35.
 * @Modified By
 */
@Controller
@RequestMapping("/payChannel")
public class PayChannelController extends BaseController {

    @Autowired
    private SysPayChannelRemoteService sysPayChannelRemoteService;

    /**
     * 添加
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(ModelMap model) {
        model.addAttribute("payPlats", PayPlatEnum.values());
        return "/sys_common/pay_channel/add";
    }

    /**
     * 保存
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysPayChannelDto sysPayChannelDto) {
        Assert.notNull(sysPayChannelDto,"支付渠道信息不能为空");
        Assert.notNull(sysPayChannelDto.getChannelNo(),"支付渠道标识不能为空");
        Assert.notNull(sysPayChannelDto.getChannelName(),"支付渠道名称不能为空");
        Assert.notNull(sysPayChannelDto.getDescription(),"支付渠道描述不能为空");
        Assert.notNull(sysPayChannelDto.getPayPlat(),"支付平台不能为空");
        RestResponse<SysPayChannelDto> restResponse = sysPayChannelRemoteService.createPayChannel(getAccessToken(),sysPayChannelDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 编辑
     */
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, ModelMap model) {
        Assert.notNull(id,"Id不能为空");
        RestResponse<SysPayChannelDto> restResponse = sysPayChannelRemoteService.queryById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("payPlats", PayPlatEnum.values());
        model.addAttribute("dto", restResponse.getData());
        return "/sys_common/pay_channel/edit";
    }

    /**
     * 更新
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(SysPayChannelDto sysPayChannelDto) {
        Assert.notNull(sysPayChannelDto,"支付渠道信息不能为空");
        Assert.notNull(sysPayChannelDto.getId(),"支付渠道id不能为空");
        Assert.notNull(sysPayChannelDto.getChannelNo(),"支付渠道标识不能为空");
        Assert.notNull(sysPayChannelDto.getChannelName(),"支付渠道名称不能为空");
        Assert.notNull(sysPayChannelDto.getDescription(),"支付渠道描述不能为空");
        Assert.notNull(sysPayChannelDto.getPayPlat(),"支付平台不能为空");
        RestResponse<SysPayChannelDto> restResponse = sysPayChannelRemoteService.updatePayChannel(getAccessToken(),sysPayChannelDto);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 列表
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(ModelMap model, SysPayChannelVo sysPayChannelVo) {
        RestResponse<PageDto<SysPayChannelDto>> restResponse = sysPayChannelRemoteService.findPage(getAccessToken(),sysPayChannelVo);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("payPlats",PayPlatEnum.values());
        model.addAttribute("queryDto",sysPayChannelVo);
        model.addAttribute("page", restResponse.getData());
        return "/sys_common/pay_channel/list";
    }

    /**
     * 删除
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public String delete(Long id) {
        Assert.notNull(id,"Id不能为空");
        RestResponse<Boolean> restResponse = sysPayChannelRemoteService.deletePayChannel(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
