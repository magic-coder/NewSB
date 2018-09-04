package com.qmx.admin.controller.tickets;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.tickets.RefundRuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.tickets.api.dto.SysBookRuleDTO;
import com.qmx.tickets.api.dto.SysRefundRuleDTO;
import com.qmx.tickets.api.query.SysRefundRuleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author liubin
 * @Description 归口规则
 * @Date Created on 2018/2/2 14:48.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/refundRule")
public class RefundRuleController extends BaseController {

    @Autowired
    private RefundRuleRemoteService refundRuleRemoteService;

    /**
     * 退款规则json列表
     *
     * @param q
     * @param page
     * @param row
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/listForJson", method = RequestMethod.POST)
    public Object listForJson(@RequestParam(defaultValue = "") String q,
                              @RequestParam(defaultValue = "1") Integer page,
                              @RequestParam(defaultValue = "10") Integer row) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> rows = new ArrayList<>();
        SysRefundRuleVO sysRefundRuleVO = new SysRefundRuleVO();
        sysRefundRuleVO.setPageIndex(page);
        sysRefundRuleVO.setPageSize(row);
        sysRefundRuleVO.setName(q);
        RestResponse<PageDto<SysRefundRuleDTO>> restResponse = refundRuleRemoteService.findPage(getAccessToken(), sysRefundRuleVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        PageDto<SysRefundRuleDTO> pageDto = restResponse.getData();
        for (SysRefundRuleDTO dto : pageDto.getRecords()) {
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
    public String list(HttpServletRequest request, SysRefundRuleVO sysRefundRuleVO) {
        RestResponse<PageDto<SysRefundRuleDTO>> restResponse = refundRuleRemoteService.findPage(getAccessToken(), sysRefundRuleVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysRefundRuleVO);
        request.setAttribute("page", restResponse.getData());
        return "/tickets/refund_rule/list";
    }

    /**
     * 添加页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request) {
        return "/tickets/refund_rule/add";
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
        RestResponse<SysRefundRuleDTO> restResponse = refundRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/tickets/refund_rule/edit";
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
        RestResponse<SysRefundRuleDTO> restResponse = refundRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/tickets/refund_rule/view";
    }

    /**
     * 保存
     * @param sysRefundRuleDTO
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysRefundRuleDTO sysRefundRuleDTO) {
        Assert.notNull(sysRefundRuleDTO, "预定规则信息不能为空");
        RestResponse<SysRefundRuleDTO> restResponse = refundRuleRemoteService.saveRefundRule(getAccessToken(), sysRefundRuleDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 更新
     *
     * @param request
     * @param response
     * @param sysRefundRuleDTO
     * @return
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(
            HttpServletRequest request, HttpServletResponse response,
            SysRefundRuleDTO sysRefundRuleDTO) {
        Assert.notNull(sysRefundRuleDTO, "预定规则信息不能为空");
        RestResponse<SysRefundRuleDTO> restResponse = refundRuleRemoteService.updateRefundRule(getAccessToken(), sysRefundRuleDTO);
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
        RestResponse<Boolean> restResponse = refundRuleRemoteService.deleteRefundRule(getAccessToken(), new Long[]{id});
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

}