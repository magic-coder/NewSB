package com.qmx.admin.utils;

import com.alibaba.fastjson.JSONObject;

import javax.servlet.http.HttpServletRequest;

public class AreaUtils {
    public static String getArea(HttpServletRequest request) {
        String province = RequestUtils.getString(request, "province", "");
        String city = RequestUtils.getString(request, "city", "");
        String county = RequestUtils.getString(request, "county", "");
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("province", province);
        jsonObject.put("city", city);
        jsonObject.put("county", county);
        return jsonObject.toString();
    }
}
