package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.UserWithdrawInfoRemoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.http.HttpServletRequest;

/**
 * @Author liubin
 * @Description 用户提现收款信息
 * @Date Created on 2018/1/23 9:57.
 * @Modified By
 */
@Deprecated
@Controller
@RequestMapping("/userWithdrawInfo")
public class UserWithdrawInfoController extends BaseController {

    @Autowired
    private UserWithdrawInfoRemoteService userWithdrawInfoRemoteService;

    /**
     * 绑定银行卡
     * @return
     */
    @RequestMapping(path = "/bindBankCard",method = RequestMethod.POST)
    public String bindBankCard(HttpServletRequest request){
        return "/user/user_withdraw_info/bind_bank_card";
    }

    /**
     * 绑定支付宝
     * @param request
     * @return
     */
    @RequestMapping(path = "/bindAlipay",method = RequestMethod.POST)
    public String bindAlipay(HttpServletRequest request){
        return "/user/user_withdraw_info/bind_alipay";
    }

    /**
     * 绑定微信
     * @param request
     * @return
     */
    @RequestMapping(path = "/bindWxpay",method = RequestMethod.POST)
    public String bindWxpay(HttpServletRequest request){
        return "/user/user_withdraw_info/bind_wxpay";
    }

    /**
     * 执行绑定银行卡
     * @return
     */
    @RequestMapping(path = "/doBindBankCard",method = RequestMethod.POST)
    public String doBindBankCard(HttpServletRequest request){
        return "/user/user_withdraw_info/bind_bank_card";
    }

    /**
     * 执行绑定支付宝
     * @param request
     * @return
     */
    @RequestMapping(path = "/doBindAlipay",method = RequestMethod.POST)
    public String doBindAlipay(HttpServletRequest request){
        return "/user/user_withdraw_info/bind_alipay";
    }

    /**
     * 执行绑定微信
     * @param request
     * @return
     */
    @RequestMapping(path = "/doBindWxpay",method = RequestMethod.POST)
    public String doBindWxpay(HttpServletRequest request){
        return "/user/user_withdraw_info/bind_wxpay";
    }



}
