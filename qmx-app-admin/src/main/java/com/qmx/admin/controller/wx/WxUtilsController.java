package com.qmx.admin.controller.wx;

import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.Base64Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.ByteArrayOutputStream;

@Controller
@RequestMapping("/wxutils")
public class WxUtilsController {
    /**
     * 二维码
     *
     * @param url
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getqrcode")
    public String getqrcode(String url) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        QRCodeUtil.encode(url, 320, 320, out);
        byte[] tempbyte = out.toByteArray();
        String base64Url = Base64Util.encodeToString(tempbyte);
        String qrcodestr = "data:image/png;base64," + base64Url;
        return qrcodestr;
    }
}
