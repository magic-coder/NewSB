package com.qmx.admin.controller.wx;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxQrcodeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxQrcodeDto;
import com.qmx.wxbasics.api.enumerate.QrcodeType;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;

@Controller
@RequestMapping("/wxQrcode")
public class WxQrcodeController extends BaseController {

    @Autowired
    private WxQrcodeRemoteService wxQrcodeRemoteService;
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;

    /**
     * 列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(WxQrcodeDto dto, ModelMap model) {
        RestResponse<PageDto<WxQrcodeDto>> restResponse = wxQrcodeRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("QrcodeType", QrcodeType.values());
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/wx/wxqrcode/list";
    }

    /**
     * 增加
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        model.addAttribute("QrcodeType", QrcodeType.values());
        return "/wx/wxqrcode/add";
    }

    /**
     * 保存/跟新
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(WxQrcodeDto dto) {
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        dto.setAuthorizationId(aid);
        if (dto.getId() == null) {
            RestResponse<WxQrcodeDto> restResponse = wxQrcodeRemoteService.createQrcode(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        } else {
            RestResponse<WxQrcodeDto> restResponse = wxQrcodeRemoteService.updateQrcode(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        }


        return "redirect:list";
    }

    /**
     * 删除
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        RestResponse restResponse = wxQrcodeRemoteService.deleteQrcode(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 下载
     *
     * @param url
     * @param request
     * @param response
     */
    @RequestMapping(value = "/download", method = RequestMethod.GET)
    public void download(String url, HttpServletRequest request, HttpServletResponse response) {
        try {
            String filename = request.getParameter("filename");
            //获得请求文件名
            if (StringUtils.isEmpty(filename)) {
                filename = "temp.jpg";
            }
            response.setContentType("image/jpg");
            response.setHeader("Content-Disposition", "attachment;filename=" + filename);
            URL image = new URL(url);
            URLConnection con = image.openConnection();
            InputStream is = con.getInputStream();
            byte[] bs = new byte[1024];
            int len;
            OutputStream out = response.getOutputStream();
            while ((len = is.read(bs)) != -1) {
                out.write(bs, 0, len);
            }
            out.close();
            is.close();
        } catch (Exception e) {
            //e.printStackTrace();
        }
    }

}
