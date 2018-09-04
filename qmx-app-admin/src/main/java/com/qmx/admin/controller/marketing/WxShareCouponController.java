package com.qmx.admin.controller.marketing;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.marketing.WxShareCouponRemoteService;
import com.qmx.base.api.dto.RestResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
@RequestMapping("/WxShareCoupon")
public class WxShareCouponController extends BaseController {

    @Autowired
    private WxShareCouponRemoteService wxShareCouponRemoteService;

    /**
     * 核销
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/closureById")
    public Map<String, Object> closureById(Long id){
        RestResponse<Map<String, Object>> restResponse = wxShareCouponRemoteService.closure(getAccessToken(),id);
        return restResponse.getData();
    }
}
