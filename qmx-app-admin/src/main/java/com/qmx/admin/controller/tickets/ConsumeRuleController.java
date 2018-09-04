package com.qmx.admin.controller.tickets;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.tickets.ConsumeRuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.tickets.api.dto.SysConsumeRuleDTO;
import com.qmx.tickets.api.query.SysConsumeRuleVO;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author liubin
 * @Description 检票规则
 * @Date Created on 2018/2/2 14:48.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/consumeRule")
public class ConsumeRuleController extends BaseController {

    @Autowired
    private ConsumeRuleRemoteService consumeRuleRemoteService;

    /**
     * 检票规则json列表
     *
     * @param q
     * @param page
     * @param row
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/listForJson", method = RequestMethod.POST)
    public Object listForJson(
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer row) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> rows = new ArrayList<>();
        SysConsumeRuleVO sysConsumeRuleVO = new SysConsumeRuleVO();
        sysConsumeRuleVO.setPageIndex(page);
        sysConsumeRuleVO.setPageSize(row);
        sysConsumeRuleVO.setName(q);
        RestResponse<PageDto<SysConsumeRuleDTO>> restResponse = consumeRuleRemoteService.findPage(getAccessToken(), sysConsumeRuleVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        PageDto<SysConsumeRuleDTO> pageDto = restResponse.getData();
        for (SysConsumeRuleDTO dto : pageDto.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", dto.getId() + "");
            map.put("sn", dto.getSn());
            map.put("name", dto.getName());
            rows.add(map);
        }
        result.put("total", pageDto.getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    /**
     * 列表
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request, SysConsumeRuleVO sysConsumeRuleVO) {
        RestResponse<PageDto<SysConsumeRuleDTO>> restResponse = consumeRuleRemoteService.findPage(getAccessToken(), sysConsumeRuleVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysConsumeRuleVO);
        request.setAttribute("page", restResponse.getData());
        return "/tickets/consume_rule/list";
    }

    /**
     * 添加页面
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add() {
        return "/tickets/consume_rule/add";
    }

    /**
     * 编辑页面
     *
     * @param request
     * @param id
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysConsumeRuleDTO> restResponse = consumeRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/tickets/consume_rule/edit";
    }

    /**
     * 预览
     * @param request
     * @param id
     * @return
     */
    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public String view(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysConsumeRuleDTO> restResponse = consumeRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/tickets/consume_rule/view";
    }

    /**
     * 保存
     * @param sysConsumeRuleDTO
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysConsumeRuleDTO sysConsumeRuleDTO, Long[] checkTicketMemberIds,
            String isSupplierCheck) {
        Assert.notNull(sysConsumeRuleDTO, "检票规则信息不能为空");
        String checkMembers = StringUtils.join(checkTicketMemberIds, ",");
        SysUserDto currentMember = getCurrentMember();
        Long supplierId = currentMember.getSupplierId();
        if(currentMember.getUserType() == SysUserType.supplier){
            supplierId = currentMember.getId();
        }
        if (isSupplierCheck != null) {
            checkMembers += "," + supplierId;
        }
        sysConsumeRuleDTO.setCheckMembers(checkMembers);
        RestResponse<SysConsumeRuleDTO> restResponse = consumeRuleRemoteService.saveConsumeRule(getAccessToken(), sysConsumeRuleDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 更新
     *
     * @param request
     * @param sysConsumeRuleDTO
     * @return
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(
            HttpServletRequest request, SysConsumeRuleDTO sysConsumeRuleDTO, Long[] checkTicketMemberIds,
            String isSupplierCheck) {
        Assert.notNull(sysConsumeRuleDTO, "检票规则信息不能为空");
        Assert.notNull(sysConsumeRuleDTO.getId(), "检票规则id不能为空");
        String checkMembers = StringUtils.join(checkTicketMemberIds, ",");
        if (isSupplierCheck != null) {
            checkMembers += "," + sysConsumeRuleDTO.getSupplierId();
        }
        sysConsumeRuleDTO.setCheckMembers(checkMembers);
        RestResponse<SysConsumeRuleDTO> restResponse = consumeRuleRemoteService.updateConsumeRule(getAccessToken(), sysConsumeRuleDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 删除
     *
     * @param request
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = consumeRuleRemoteService.deleteConsumeRule(getAccessToken(), new Long[]{id});
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}