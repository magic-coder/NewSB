package com.qmx.admin.controller.wx;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationInfoRemoteService;
import com.qmx.admin.controller.common.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxAuthorizationInfo")
public class WxAuthorizationInfoController extends BaseController  {

    @Autowired
    private WxAuthorizationInfoRemoteService wxAuthorizationInfoRemoteService;

}
