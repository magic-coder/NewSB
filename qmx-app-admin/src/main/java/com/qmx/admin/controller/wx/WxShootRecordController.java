package com.qmx.admin.controller.wx;


import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxShootRecordRemoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/wxShootRecord")
public class WxShootRecordController extends BaseController {

    @Autowired
    private WxShootRecordRemoteService wxShootRecordRemoteService;
}
