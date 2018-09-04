package com.qmx.admin.controller.wx;

import com.qmx.admin.remoteapi.wx.WxExportcouponCodeRemoteService;
import com.qmx.admin.controller.common.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxExportcouponCode")
public class WxExportcouponCodeController extends BaseController {

    @Autowired
    private WxExportcouponCodeRemoteService wxExportcouponCodeRemoteService;
}
