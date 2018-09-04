package com.qmx.admin.controller.travelagency;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.travelagency.AchievementsBillRemoteService;
import com.qmx.admin.remoteapi.travelagency.AchievementsInfoRemoteService;
import com.qmx.admin.remoteapi.travelagency.AchievementsRemoteService;
import com.qmx.admin.remoteapi.travelagency.OrderRemoteService;
import com.qmx.admin.utils.ExcelUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.travelagency.api.dto.AchievementsBillDto;
import com.qmx.travelagency.api.dto.AchievementsDto;
import com.qmx.travelagency.api.dto.AchievementsInfoDto;
import com.qmx.travelagency.api.dto.OrderDto;
import com.qmx.travelagency.api.enumerate.TaOfflinePayType;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by earnest on 2018/3/14 0014.
 */
@Controller("/taAchievementsInfo")
@RequestMapping("/taAchievementsInfo")
public class AchievementsInfoController extends BaseController {

    @Autowired
    private AchievementsInfoRemoteService achievementsInfoRemoteService;
    @Autowired
    private AchievementsRemoteService achievementsRemoteService;
    @Autowired
    private AchievementsBillRemoteService achievementsBillRemoteService;
    @Autowired
    private OrderRemoteService orderRemoteService;

    @RequestMapping(value = "/list")
    public String list(AchievementsDto dto, ModelMap model) {
        dto.setGroup(Boolean.TRUE);
        RestResponse<PageDto<AchievementsDto>> restResponse = achievementsRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/achievementsinfo/list";
    }

    @RequestMapping(value = "/view")
    public String mangerList(AchievementsInfoDto dto, ModelMap model) {
        RestResponse<PageDto<AchievementsInfoDto>> restResponse = achievementsInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/achievementsinfo/view";
    }

    /**
     * 待结算列表
     *
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping(value = "/settleList")
    public String settleList(AchievementsInfoDto dto, ModelMap model) {
        //默认查询未结算的绩效信息
        dto.setSettleAccounts(Boolean.FALSE);
        RestResponse<PageDto<AchievementsInfoDto>> restResponse = achievementsInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/travelagency/achievementsinfo/settlelist";
    }

    /**
     * 创建账单
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("/createBill")
    public String createBill(HttpServletRequest request, String[] ids, AchievementsBillDto dto, ModelMap model) {
        // String[] ids = request.getParameterValues("ids");
        RestResponse<AchievementsBillDto> restResponse = achievementsBillRemoteService.returnBill(getAccessToken(), dto, ids);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        String str = StringUtils.join(ids, ",");
        model.addAttribute("ids", str);
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/travelagency/achievementsinfo/createbill";
    }


    /**
     * 结算绩效,保存账单
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/settle")
    public JSONObject settle(AchievementsBillDto dto, HttpServletRequest request) {
        String strings = request.getParameter("ids");
        String[] ids = strings.split(",");
        JSONObject object = new JSONObject();
        RestResponse<AchievementsBillDto> restResponse = achievementsBillRemoteService.createDto(getAccessToken(), dto, ids);
        if (!restResponse.success()) {
            object.put("state", "error");
            object.put("msg", "结算失败" + restResponse.getErrorMsg());
        } else {
            object.put("state", "success");
            object.put("msg", "结算成功");
        }
        return object;
    }

    /**
     * 账单列表
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/billList")
    public String billList(AchievementsBillDto dto, ModelMap model) {
        RestResponse<PageDto<AchievementsBillDto>> restResponse = achievementsBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/travelagency/achievementsinfo/billlist";
    }

    /**
     * 导出景区全部员工的绩效信息
     *
     * @param response
     */
    @ResponseBody
    @RequestMapping(value = "/exportTotal")
    public void exportTotal(HttpServletResponse response, AchievementsDto dto) {
        dto.setGroup(Boolean.TRUE);
        RestResponse<PageDto<AchievementsDto>> restResponse = achievementsRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<AchievementsDto> infoDtoList = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("旅行社员工绩效", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (AchievementsDto infoDto : infoDtoList) {
                Object[] objects = new Object[4];
                objects[0] = infoDto.getMemberName();
                objects[1] = infoDto.getTotalAmount();
                objects[2] = infoDto.getIssuedAmount();
                objects[3] = infoDto.getUnissuedAmount();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "旅行社员工绩效", new String[]{"员工", "历史绩效总额", "已发放绩效总额",
                            "待发放绩效总额"},
                    new int[]{0, 1, 2, 3}, infoDtoList.size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 导出账单
     *
     * @param response
     * @param dto
     */
    @ResponseBody
    @RequestMapping(value = "/exportBill")
    public void exportBill(HttpServletResponse response, AchievementsBillDto dto) {
        RestResponse<PageDto<AchievementsBillDto>> restResponse = achievementsBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<AchievementsBillDto> billDtos = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("旅行社绩效账单", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (AchievementsBillDto achievementsBillDto : billDtos) {
                String channelNo = null;
                if (!StringUtils.isEmpty(achievementsBillDto.getChannelNo())) {
                    channelNo = TaOfflinePayType.valueOf(achievementsBillDto.getChannelNo()).getTitle();
                }

                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(achievementsBillDto.getCreateTime());
                Object[] objects = new Object[6];
                objects[0] = achievementsBillDto.getSn();
                objects[1] = channelNo;
                objects[2] = achievementsBillDto.getAmount();
                objects[3] = date;
                objects[4] = achievementsBillDto.getCreateName();
                objects[5] = achievementsBillDto.getRemark();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "旅行社绩效账单", new String[]{"编号", "支出方式", "支出金额",
                            "结算时间", "操作人", "备注"},
                    new int[]{0, 1, 2, 3, 4, 5}, billDtos.size(), out);
            out.flush();
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 导出绩效明细
     *
     * @param response
     */
    @ResponseBody
    @RequestMapping(value = "/export")
    public void export(HttpServletResponse response, AchievementsInfoDto dto) {
        RestResponse<PageDto<AchievementsInfoDto>> restResponse = achievementsInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<AchievementsInfoDto> infoDtoList = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("旅行社绩效明细", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (AchievementsInfoDto infoDto : infoDtoList) {
                //下单时间
                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(infoDto.getCreateTime());
                //消费时间
                String consume;
                if (infoDto.getConsumeTime() == null) {
                    consume = "/";
                } else {
                    consume = infoDto.getConsumeTime();
                }
                String settle;
                if (infoDto.getSettleAccounts()) {
                    settle = "已结算";
                } else {
                    settle = "未结算";
                }
                Object[] objects = new Object[9];
                objects[0] = infoDto.getMemberName();
                objects[1] = infoDto.getSn();
                objects[2] = infoDto.getTaName();
                objects[3] = date;
                objects[4] = consume;
                objects[5] = infoDto.getProductName();
                objects[6] = infoDto.getType();
                objects[7] = infoDto.getAmount();
                objects[8] = settle;
                collection.add(objects);
            }
            ExcelUtils.export(collection, "旅行社绩效明细", new String[]{"员工", "订单编号", "旅行社",
                            "下单时间", "消费时间", "绩效产品", "绩效方式", "绩效金额", "是否结算"},
                    new int[]{0, 1, 2, 3, 4, 5, 6, 7, 8}, infoDtoList.size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
