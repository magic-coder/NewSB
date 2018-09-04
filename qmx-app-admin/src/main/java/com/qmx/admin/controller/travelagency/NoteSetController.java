package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.NoteSetRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.message.sms.dto.SmsTemplateDto;
import com.qmx.coreservice.api.message.sms.query.SmsTemplateQueryVo;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.travelagency.api.dto.NoteSetDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by earnest on 2018/3/30 0030.
 */
@Controller("/taNoteSet")
@RequestMapping("/taNoteSet")
public class NoteSetController extends BaseController {
    @Autowired
    private NoteSetRemoteService noteSetRemoteService;
    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    @RequestMapping("/add")
    public String add(ModelMap model, NoteSetDto dto) {
        SysUserDto userDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (userDto.getUserType() == SysUserType.supplier || userDto.getUserType() == SysUserType.employee) {


            SmsTemplateQueryVo smsTemplateQueryVo = new SmsTemplateQueryVo();
            smsTemplateQueryVo.setPageSize(100);
            smsTemplateQueryVo.setModuleId(955693948670648321L);
            RestResponse<PageDto<SmsTemplateDto>> restResponse = smsTemplateRemoteService.findSupplierAuthPage(getAccessToken(), smsTemplateQueryVo);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            RestResponse<NoteSetDto> response = noteSetRemoteService.getBySupplier(getAccessToken());
            if (!response.success()) {
                throw new BusinessException(response.getErrorMsg());
            }
            model.addAttribute("smsTemplates", restResponse.getData().getRecords());
            model.addAttribute("dto", response.getData());
            return "/travelagency/noteset/add";
        } else {
            RestResponse<PageDto<NoteSetDto>> restResponse = noteSetRemoteService.findList(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            model.addAttribute("dto", dto);
            model.addAttribute("page", restResponse.getData());
            return "/travelagency/noteset/list";
        }
    }

    @ResponseBody
    @RequestMapping("/save")
    public JSONObject save(NoteSetDto dto) {
        JSONObject object = new JSONObject();
        RestResponse<NoteSetDto> restResponse = noteSetRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "设置失败！" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "设置成功！");
            //object.put("onteId", restResponse.getData().getId());
        }
        return object;
    }
}
