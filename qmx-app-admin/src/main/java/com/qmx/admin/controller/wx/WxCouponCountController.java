package com.qmx.admin.controller.wx;


import com.qmx.admin.remoteapi.wx.WxCouponCountRemoteService;
import com.qmx.admin.controller.common.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxCouponCount")
public class WxCouponCountController extends BaseController {

    @Autowired
    private WxCouponCountRemoteService wxCouponCountRemoteService;
}
