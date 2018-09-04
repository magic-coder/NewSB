package com.qmx.admin.controller.tickets;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.tickets.BookRuleRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.tickets.api.dto.SysBookRuleDTO;
import com.qmx.tickets.api.dto.SysConsumeRuleDTO;
import com.qmx.tickets.api.query.SysBookRuleVO;
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
 * @Description 预定规则管理
 * @Date Created on 2018/2/2 14:35.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/bookRule")
public class BookRuleController extends BaseController {

    @Autowired
    private BookRuleRemoteService bookRuleRemoteService;

    /**
     * 预定规则json列表
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
        SysBookRuleVO sysBookRuleVO = new SysBookRuleVO();
        sysBookRuleVO.setPageIndex(page);
        sysBookRuleVO.setPageSize(row);
        sysBookRuleVO.setName(q);
        RestResponse<PageDto<SysBookRuleDTO>> restResponse = bookRuleRemoteService.findPage(getAccessToken(), sysBookRuleVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        PageDto<SysBookRuleDTO> pageDto = restResponse.getData();
        for (SysBookRuleDTO dto : pageDto.getRecords()) {
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
    public String list(HttpServletRequest request, SysBookRuleVO sysBookRuleVO) {
        RestResponse<PageDto<SysBookRuleDTO>> restResponse = bookRuleRemoteService.findPage(getAccessToken(), sysBookRuleVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", sysBookRuleVO);
        request.setAttribute("page", restResponse.getData());
        return "/tickets/book_rule/list";
    }

    /**
     * 添加页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request) {
        return "/tickets/book_rule/add";
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
        RestResponse<SysBookRuleDTO> restResponse = bookRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/tickets/book_rule/edit";
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
        RestResponse<SysBookRuleDTO> restResponse = bookRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("dto", restResponse.getData());
        return "/tickets/book_rule/view";
    }

    /**
     * 保存
     *
     * @param request
     * @param sysBookRuleDTO
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(
            HttpServletRequest request,
            SysBookRuleDTO sysBookRuleDTO) {
        Assert.notNull(sysBookRuleDTO, "预定规则信息不能为空");
        RestResponse<SysBookRuleDTO> restResponse = bookRuleRemoteService.saveBookRule(getAccessToken(), sysBookRuleDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 更新
     *
     * @param request
     * @param sysBookRuleDTO
     * @return
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(
            HttpServletRequest request,
            SysBookRuleDTO sysBookRuleDTO) {
        Assert.notNull(sysBookRuleDTO, "预定规则信息不能为空");
        RestResponse<SysBookRuleDTO> restResponse = bookRuleRemoteService.updateBookRule(getAccessToken(), sysBookRuleDTO);
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
        RestResponse<Boolean> restResponse = bookRuleRemoteService.deleteBookRule(getAccessToken(), new Long[]{id});
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

}