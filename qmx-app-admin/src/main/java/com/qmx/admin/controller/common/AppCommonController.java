package com.qmx.admin.controller.common;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @Author liubin
 * @Description 公共Controller
 * @Date Created on 2017/11/28 14:36.
 * @Modified By
 */
//@Controller
//@RequestMapping("/common")
public class AppCommonController extends BaseController {
    private static final Logger logger = LoggerFactory.getLogger(AppCommonController.class);
    @Autowired
    private SysUserRemoteService userService;


}
