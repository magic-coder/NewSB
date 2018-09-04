package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxExportcouponRemoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxExportcoupon")
public class WxExportcouponController extends BaseController {

    @Autowired
    private WxExportcouponRemoteService wxExportcouponRemoteService;
}
