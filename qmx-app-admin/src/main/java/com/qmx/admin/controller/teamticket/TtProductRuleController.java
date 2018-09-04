package com.qmx.admin.controller.teamticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtProductRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtProductRuleRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtProductRuleUserRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.teamticket.api.dto.TtProductDto;
import com.qmx.teamticket.api.dto.TtProductRuleDto;
import com.qmx.teamticket.api.dto.TtProductRuleUserDto;
import com.qmx.teamticket.api.enumerate.UserProductType;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/ttproductrule")
public class TtProductRuleController extends BaseController {
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TtProductRemoteService ttProductRemoteService;
    @Autowired
    private TtProductRuleRemoteService ttProductRuleRemoteService;
    @Autowired
    private TtProductRuleUserRemoteService ttProductRuleUserRemoteService;

    @RequestMapping(value = "/list")
    public String list(TtProductRuleDto dto, ModelMap model) {
        RestResponse<PageDto<TtProductRuleDto>> restResponse = ttProductRuleRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductrule/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap model) {
        model.addAttribute("types", UserProductType.values());
        return "/teamticket/ttproductrule/add";
    }

    @RequestMapping(value = "/save")
    public String save(TtProductRuleDto dto, HttpServletRequest request) {
        String[] memberIds = request.getParameterValues("memberId");
        List<TtProductRuleUserDto> userids = new ArrayList<>();
        for (int i = 0; i < memberIds.length; i++) {
            TtProductRuleUserDto ruleUserDto = new TtProductRuleUserDto();
            ruleUserDto.setMemberId(Long.parseLong(memberIds[i]));
            userids.add(ruleUserDto);
        }
        dto.setUserids(userids);

        RestResponse<TtProductRuleDto> restResponse = ttProductRuleRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        RestResponse<TtProductRuleDto> restResponse = ttProductRuleRemoteService.findById(id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        TtProductRuleDto dto = restResponse.getData();
        List<TtProductRuleUserDto> userDtos = dto.getUserids();
        for (TtProductRuleUserDto userDto : userDtos) {
            SysUserDto sysUser = sysUserRemoteService.findById(userDto.getMemberId()).getData();
            userDto.setAccount(sysUser.getAccount());
            userDto.setUsername(sysUser.getUsername());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("types", UserProductType.values());
        return "/teamticket/ttproductrule/edit";
    }

    @RequestMapping(value = "/update")
    public String update(TtProductRuleDto dto, HttpServletRequest request) {
        String[] memberIds = request.getParameterValues("memberId");
        String[] ruleUserIds = request.getParameterValues("ruleUserId");
        List<TtProductRuleUserDto> userids = new ArrayList<>();
        if (memberIds != null && memberIds.length > 0) {
            for (int i = 0; i < memberIds.length; i++) {
                TtProductRuleUserDto ruleUserDto = new TtProductRuleUserDto();
                if (StringUtils.isNotEmpty(ruleUserIds[i])) {
                    ruleUserDto.setId(Long.parseLong(ruleUserIds[i]));
                }
                ruleUserDto.setMemberId(Long.parseLong(memberIds[i]));
                userids.add(ruleUserDto);
            }
            dto.setUserids(userids);
        }

        RestResponse<TtProductRuleDto> restResponse = ttProductRuleRemoteService.updateDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list.jhtml";
    }

    /**
     * 删除
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public JSONObject delete(Long id) {
        JSONObject json = new JSONObject();
        RestResponse restResponse = ttProductRuleRemoteService.deleteDto(getAccessToken(), id);
        if (!restResponse.success()) {
            json.put("state", "errer");
            json.put("msg", "删除失败！" + restResponse.getErrorMsg());
        } else {
            json.put("state", "success");
            json.put("msg", "删除成功！");
        }
        return json;
    }

    @ResponseBody
    @RequestMapping(value = "/deleteRuleUser")
    public Boolean deleteRuleUser(Long id) {
        try {
            RestResponse restResponse = ttProductRuleUserRemoteService.deleteDto(getAccessToken(), id);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            return Boolean.TRUE;
        } catch (Exception e) {
            return Boolean.FALSE;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/findByMemberId")
    public JSONObject findByMemberId(Long productId) {
        SysUserDto userDto = getCurrentUser();
        JSONObject json = new JSONObject();
        RestResponse<TtProductRuleDto> restResponse = ttProductRuleRemoteService.findByMemberId(productId, userDto.getId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        TtProductRuleDto ruleUserDto = restResponse.getData();
        json.put("price", ruleUserDto.getPrice());
        json.put("size", ruleUserDto.getSize());
        return json;
    }

    @RequestMapping(value = "/getProducts")
    public String getProducts(TtProductDto dto, ModelMap model) {
        RestResponse<PageDto<TtProductDto>> restResponse = ttProductRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductrule/productlist";
    }

    @RequestMapping(value = "/getUser", method = {RequestMethod.GET, RequestMethod.POST})
    public String listDistributorForAuthorize(Long productId, UserQueryVo dto, ModelMap model) {
        //通过产品ID查询已有该产品规则的员工
        List<TtProductRuleUserDto> ruleUsers = ttProductRuleUserRemoteService.findByProductId(productId).getData();
        //保存当前页码
        Integer pageIndex = dto.getPageIndex();
        //设置页码为1查询全部员工
        dto.setUserType(SysUserType.employee);

        SysUserDto sysUser = getCurrentUser();
        if (sysUser.getUserType() == SysUserType.supplier) {
            dto.setMemberId(sysUser.getId());
        } else if (sysUser.getUserType() == SysUserType.employee) {
            dto.setMemberId(sysUser.getMemberId());
        } else if (sysUser.getUserType() == SysUserType.admin) {
        } else {
            dto.setMemberId(sysUser.getId());
        }

        dto.setPageIndex(1);
        dto.setPageSize(999);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), dto);
        //end

        PageDto<SysUserDto> page = restResponse.getData();
        List<SysUserDto> records = page.getRecords();
        //保存新数据
        List<SysUserDto> newrecords = new ArrayList<>();
        if (records != null && records.size() > 0) {
            for (SysUserDto userDto : records) {
                boolean ok = true;
                if (ruleUsers != null && ruleUsers.size() > 0) {
                    for (TtProductRuleUserDto ruleUser : ruleUsers) {
                        if (userDto.getId().equals(ruleUser.getMemberId())) {
                            ok = false;
                            continue;
                        }
                    }
                }
                if (ok) {
                    newrecords.add(userDto);
                }
            }
            page.getRecords().clear();
            page.setPages(newrecords.size() / 10);
            page.setPageSize(10);
            page.setHasNext(true);
            page.setHasPrevious(true);
            page.setTotal(newrecords.size());
            page.setPageIndex(pageIndex);
            if (newrecords.size() > 0) {
                if ((10 * (pageIndex - 1)) > page.getTotal()) {
                    pageIndex = 1;
                    page.setPageIndex(pageIndex);
                }
                if (10 * pageIndex > page.getTotal()) {
                    page.setRecords(newrecords.subList(10 * (pageIndex - 1), page.getTotal()));
                } else {
                    page.setRecords(newrecords.subList(10 * (pageIndex - 1), 10 * pageIndex));
                }
            }
        }
        model.addAttribute("productId", productId);
        model.addAttribute("dto", dto);
        model.addAttribute("page", page);
        return "/teamticket/ttproductrule/userlist";
    }
}
