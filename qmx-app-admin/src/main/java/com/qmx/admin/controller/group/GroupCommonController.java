package com.qmx.admin.controller.group;

import com.qmx.admin.controller.common.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/group")
public class GroupCommonController extends BaseController {
    @RequestMapping(value = "/{path}")
    public String list(@PathVariable String path, ModelMap model) {
        return "/group/" + path;
    }

    @RequestMapping(value = "/{path}/add")
    public String add(@PathVariable String path, ModelMap model) {
        return "/group/" + path + "add";
    }
}
