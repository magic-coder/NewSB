package com.qmx.admin.interceptor;
import com.qmx.admin.service.LoginUserInfoService;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.user.dto.SysUserChargeInfoDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * @Author liubin
 * @Description 消息通知拦截器
 * @Date Created on 2018/1/10 18:38.
 * @Modified By
 */
public class MessageNotifyInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(MessageNotifyInterceptor.class);

    @Autowired
    private LoginUserInfoService loginUserInfoService;

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        try{
            String uri = request.getRequestURI();
            if(uri.startsWith("/error")){
                return super.preHandle(request, response, handler);
            }
            SysUserChargeInfoDTO userChargeInfoDTO = loginUserInfoService.findUserChargeInfo();
            if(userChargeInfoDTO != null){
                Integer canUseDays = DateUtil.daysBetween(new Date(),userChargeInfoDTO.getAccountCanUseEnd());
                if(canUseDays != null && canUseDays < 0){
                    request.setAttribute("noticeMsg","这是网页弹窗提示");
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return true;
    }
}
