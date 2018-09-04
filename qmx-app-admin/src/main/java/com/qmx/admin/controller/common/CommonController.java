package com.qmx.admin.controller.common;
import com.qmx.admin.remoteapi.core.SysAreaRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.constants.Constants;
import com.qmx.base.core.jcaptcha.JCaptchaUtil;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import com.qmx.coreservice.api.user.dto.SysAreaDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxAuthorizationDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 公共controller
 * Created by liubin on 2017/8/29.
 */
@Controller
@RequestMapping("/common")
public class CommonController extends BaseController {

    @Autowired
    private SysAreaRemoteService sysAreaRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private RedisTemplate<String,String> redisTemplate;
    @Value("${com.qmx.app.siteHost:http://qmx028.com}")
    private String siteHost;

    /**
     * 获取openId成功回调
     * @param request
     * @param openid
     * @return
     */
    @RequestMapping(value = "/getWxOpenId2")
    public String doGetWxOpenId2(HttpServletRequest request,String userId,String openid){
        if(!StringUtils.isEmpty(userId) && !StringUtils.isEmpty(openid)){
            request.setAttribute("openid",openid);
            redisTemplate.boundValueOps("WX-USER-OPENID:"+userId).set(openid);
        }
        return "/common/get_openid_success";
    }

    /**
     * 检测openID是否获取成功
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/checkWxOpenId")
    public String checkWxOpenId(){
        SysUserDto currentUser = getCurrentMember();
        if(currentUser != null){
            String result = redisTemplate.boundValueOps("WX-USER-OPENID:"+currentUser.getId()).get();
            return result;
        }
        return null;
    }


    @RequestMapping(value = "/getWxOpenId")
    public String getWxOpenId(HttpServletRequest request) {
        SysUserDto currentUser = getCurrentUser();
        if(currentUser != null){
            RestResponse<WxAuthorizationDto> restResponse = wxAuthorizationRemoteService.findByMId(currentUser.getSupplierId());
            if (restResponse.success()) {
                WxAuthorizationDto wxAuthorizationDto = restResponse.getData();
                if(wxAuthorizationDto != null){
                    String url = siteHost+"/common/getWxOpenId2?userId="+currentUser.getId();
                    RestResponse<String> restResponse1 = wxAuthorizationRemoteService.getRedirectUri(wxAuthorizationDto.getAuthorizerAppid(),url);
                    String codeUrl = restResponse1.getData();
                    if (codeUrl != null) {
                        ByteArrayOutputStream out = new ByteArrayOutputStream();
                        QRCodeUtil.encode(codeUrl, 220, 220, out);
                        byte[] tempbyte = out.toByteArray();
                        String base64Url = Base64Util.encodeToString(tempbyte);
                        request.setAttribute("codeUrl", "data:image/png;base64," + base64Url);
                    }
                }
            }
        }
        return "/common/get_openid_page";
    }




    @ResponseBody
    @RequestMapping("/area")
    public RestResponse<Map<String, String>> getArea(String parentId){
        RestResponse<List<SysAreaDTO>> restResponse = sysAreaRemoteService.findByAreaId(parentId);
        if(!restResponse.success()){
            return RestResponse.fail(restResponse.getErrorMsg());
        }
        List<SysAreaDTO> areaDTOList = restResponse.getData();
        Map<String,String> result = new HashMap<>();
        for (SysAreaDTO sysAreaDTO: areaDTOList) {
            result.put(sysAreaDTO.getAreaId(),sysAreaDTO.getName());
        }
        return RestResponse.ok(result);
    }

    /**
     * <b>Summary: </b>
     *     query 是否需要验证码
     * @param request
     * @param response
     * @return true需要，false不需要
     */
    @ResponseBody
    @RequestMapping(value = "/needCaptcha")
    public RestResponse<Boolean> needCaptcha(HttpServletRequest request, HttpServletResponse response) {
        try {
            Object obj = request.getSession().getAttribute(Constants.PASSWORD_ERROR_COUNT);
            Integer count = (obj == null) ? 0 : (Integer)obj;
            return RestResponse.ok(count > 2);
        }catch (Exception e) {
            return RestResponse.ok(true);
        }
    }

    /**
     * 验证码
     */
    @RequestMapping(value = "/captcha", method = RequestMethod.GET)
    public void image(String captchaId, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            JCaptchaUtil.buildImage(request, response);
        }catch (Exception e) {
        }
    }

    /**
     * 错误提示
     */
    @RequestMapping("/error")
    public String error() {
        return "/error";
    }
}
