package com.qmx.admin.utils;

import com.qmx.tickets.api.dto.SysPassengerInfoDTO;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author liubin
 * @Description 游客信息工具类
 * @Date Created on 2017/12/8 14:41.
 * @Modified By
 */
public class PassengerInfoUtil {

    public static List<SysPassengerInfoDTO> getPassengerInfos(HttpServletRequest request, int quantity) {
        List<SysPassengerInfoDTO> list = new ArrayList<>();
        for(int i = 1;i <= quantity;i++) {
            SysPassengerInfoDTO passengerInfo = new SysPassengerInfoDTO();
            String name = request.getParameter("name_"+i);
            String pinyin = request.getParameter("pinyin_"+i);
            String mobile = request.getParameter("phone_"+i);
            String credentialsType = request.getParameter("credentialsType_"+i);
            String credentials = request.getParameter("credentials_"+i);
            String define1 = request.getParameter("define1_"+i);
            String define2 = request.getParameter("define2_"+i);
            passengerInfo.setName(name);
            passengerInfo.setPinyin(pinyin);
            passengerInfo.setMobile(mobile);
            passengerInfo.setCredentials(credentials);
            passengerInfo.setCredentialsType(credentialsType);
            //passengerInfo.setOrder(i);
            passengerInfo.setDefined1(define1);
            passengerInfo.setDefined2(define2);
            list.add(passengerInfo);
        }
        return list;
    }
}
