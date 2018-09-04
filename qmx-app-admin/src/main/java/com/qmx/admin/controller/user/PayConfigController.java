package com.qmx.admin.controller.user;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysMchPayConfigRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.coreservice.api.pay.constant.PayConstant;
import com.qmx.coreservice.api.pay.dto.SysMchPayConfigDto;
import com.qmx.coreservice.api.pay.enumerate.PayPlatEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @Author liubin
 * @Description 支付配置管理
 * @Date Created on 2017/12/29 16:35.
 * @Modified By
 */
@Controller
@RequestMapping("/payConfig")
public class PayConfigController extends BaseController {

    @Autowired
    private SysMchPayConfigRemoteService sysMchPayConfigRemoteService;
    //@Autowired
    //private SysPayChannelRemoteService sysPayChannelRemoteService;

    /**
     * 支付宝配置
     */
    @RequestMapping(value = "/editAliPay", method = RequestMethod.GET)
    public String editAliPay(ModelMap model) {
        RestResponse<SysMchPayConfigDto> restResponse = sysMchPayConfigRemoteService.findCurrentConfig(getAccessToken(), PayConstant.PAY_CHANNEL_ALIPAY_PC);
        if(!restResponse.success()){
            throw new RuntimeException(restResponse.getErrorMsg());
        }
        SysMchPayConfigDto sysMchPayConfig = restResponse.getData();
        if(sysMchPayConfig != null && StringUtils.hasText(sysMchPayConfig.getParams())){
            String params = sysMchPayConfig.getParams();
            JSONObject jsonObject = JSONObject.parseObject(params);
            model.addAttribute("appid",jsonObject.getString("appid"));
            model.addAttribute("private_key",jsonObject.getString("private_key"));
            model.addAttribute("alipay_public_key",jsonObject.getString("alipay_public_key"));
        }
        model.addAttribute("payPlats", PayPlatEnum.values());
        return "/sys_common/pay_config/alipay/edit_new";
    }

    /**
     * 更新支付宝配置
     */
    @RequestMapping(value = "/updateAliPay", method = RequestMethod.POST)
    public String updateAliPay(String appid,String private_key,String public_key) {
        Assert.hasText(appid,"appid不能为空");
        Assert.hasText(private_key,"private_key不能为空");
        Assert.hasText(public_key,"public_key不能为空");
        //String alipay_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoTHAYzrYzITRaMZcJjO6Wxbu7C7kNoorXnOLmKI74ukbMMJvzZTE3d1ivwEp+qrNwPcG3Z0I2Z3y2FAtPr0ZarzVxcl+UljGDEwhxq7FrwSGFW6cpGwW9cWZ9KnBa2hOs0gTML8HdIajqbYu7tKWXTCrl8Sl38lZRpTV3nCYNKmTRVG8IhI58aYrG5agF0mZSyRSg6TWZmE/t1vdGIRNdjEAZa0X9Khilk6W5hcVXaOn2vB6/KE6mqG4hw/myZA3jbYn8Ue7kxn+NbYlL4muFQ4j79K5JKj+7kgEo9GmBSCKw8/tmYQmni0UDa7WLE0feZru5/+mky5hgk7RHCtVPwIDAQAB";
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("appid",appid);
        jsonObject.put("alipay_public_key",public_key);
        jsonObject.put("private_key",private_key);
        jsonObject.put("isSandbox","0");
        RestResponse<Boolean> restResponse = sysMchPayConfigRemoteService.updateByPlatWithCurrentUser(getAccessToken(), PayPlatEnum.ALIPAY,jsonObject.toJSONString());
        if(!restResponse.success()){
            throw new RuntimeException(restResponse.getErrorMsg());
        }
        return "redirect:editAliPay";
    }

    /**
     * 微信配置
     */
    @RequestMapping(value = "/editWxPay", method = RequestMethod.GET)
    public String editWxPay(ModelMap model) {
        RestResponse<SysMchPayConfigDto> restResponse = sysMchPayConfigRemoteService.findCurrentConfig(getAccessToken(), PayConstant.PAY_CHANNEL_WX_NATIVE);
        if(!restResponse.success()){
            throw new RuntimeException(restResponse.getErrorMsg());
        }
        SysMchPayConfigDto sysMchPayConfig = restResponse.getData();
        if(sysMchPayConfig != null && StringUtils.hasText(sysMchPayConfig.getParams())){
            String params = sysMchPayConfig.getParams();
            JSONObject jsonObject = JSONObject.parseObject(params);
            model.addAttribute("mchId",jsonObject.getString("mchId"));
            model.addAttribute("appId",jsonObject.getString("appId"));
            model.addAttribute("key",jsonObject.getString("key"));
            model.addAttribute("certLocalPath",jsonObject.getString("certLocalPath"));
        }
        model.addAttribute("payPlats", PayPlatEnum.values());
        return "/sys_common/pay_config/wxpay/edit";
    }

    /**
     * 更新微信支付配置
     */
    @RequestMapping(value = "/updateWxPay", method = RequestMethod.POST)
    public String updateWxPay(String mchId,String appId,String key,String certLocalPath) {
        Assert.hasText(mchId,"mchId不能为空");
        Assert.hasText(appId,"appId不能为空");
        Assert.hasText(key,"key不能为空");
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("mchId",mchId);
        jsonObject.put("appId",appId);
        jsonObject.put("key",key);
        if(StringUtils.hasText(certLocalPath)){
            jsonObject.put("certLocalPath",certLocalPath);
        }
        RestResponse<Boolean> restResponse = sysMchPayConfigRemoteService.updateByPlatWithCurrentUser(getAccessToken(), PayPlatEnum.WXPAY,jsonObject.toJSONString());
        if(!restResponse.success()){
            throw new RuntimeException(restResponse.getErrorMsg());
        }
        return "redirect:editWxPay";
    }

    /**
     * 列表
     */
    /*@RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(ModelMap model, SysMchPayConfigDto sysMchPayConfigDto) {
        return "/user/pay_config/list";
    }*/

    /**
     * 删除
     */
    /*@RequestMapping(value = "/delete", method = RequestMethod.POST)
    public String delete(Long id) {
        Assert.notNull(id,"Id不能为空");
        *//*RestResponse<Boolean> restResponse = sysDictRemoteService.deleteDictById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }*//*
        return "redirect:list";
    }*/
}
