package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxCouponActivityRemoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxCouponActivity")
public class WxCouponActivityController extends BaseController {

    @Autowired
    private WxCouponActivityRemoteService wxCouponActivityRemoteService;
}
