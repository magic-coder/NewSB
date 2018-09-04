package com.qmx.admin.controller.wx;


import com.qmx.admin.remoteapi.wx.WxCouponNumRemoteService;
import com.qmx.admin.controller.common.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxCouponNum")
public class WxCouponNumController extends BaseController {

    @Autowired
    private WxCouponNumRemoteService wxCouponNumRemoteService;
}
