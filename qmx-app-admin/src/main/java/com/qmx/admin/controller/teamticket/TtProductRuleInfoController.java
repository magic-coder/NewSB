package com.qmx.admin.controller.teamticket;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.teamticket.TtAchievementsBillRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtOderInfoRemoteService;
import com.qmx.admin.remoteapi.teamticket.TtProductRuleUserRemoteService;
import com.qmx.admin.utils.ExcelUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.teamticket.api.dto.TtAchievementsBillDto;
import com.qmx.teamticket.api.dto.TtOrderInfoDto;
import com.qmx.teamticket.api.dto.TtProductRuleUserDto;
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
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by earnest on 2018/5/21 0021.
 */
@Controller("/ttproductruleinfo")
@RequestMapping("/ttproductruleinfo")
public class TtProductRuleInfoController extends BaseController {
    @Autowired
    private TtProductRuleUserRemoteService ttProductRuleUserRemoteService;
    @Autowired
    private TtOderInfoRemoteService ttOderInfoRemoteService;
    @Autowired
    private TtAchievementsBillRemoteService ttAchievementsBillRemoteService;


    @RequestMapping(value = "/list")
    public String list(TtProductRuleUserDto dto, ModelMap model) {
        RestResponse<PageDto<TtProductRuleUserDto>> restResponse = ttProductRuleUserRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductruleinfo/list";
    }

    @RequestMapping(value = "/settleList")
    public String settleList(TtOrderInfoDto dto, ModelMap model) {
        //默认查询未结算的绩效信息
        dto.setSettleAccounts(Boolean.FALSE);
        RestResponse<PageDto<TtOrderInfoDto>> restResponse = ttOderInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductruleinfo/settlelist";
    }

    /**
     * 创建账单
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("/createBill")
    public String createBill(HttpServletRequest request, String[] ids, TtAchievementsBillDto dto, ModelMap model) {
        // String[] ids = request.getParameterValues("ids");
        RestResponse<TtAchievementsBillDto> restResponse = ttAchievementsBillRemoteService.returnBill(getAccessToken(), dto, ids);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        String str = StringUtils.join(ids, ",");
        model.addAttribute("ids", str);
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/teamticket/ttproductruleinfo/createbill";
    }

    /**
     * 结算绩效,保存账单
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/settle")
    public JSONObject settle(TtAchievementsBillDto dto, HttpServletRequest request) {
        String strings = request.getParameter("ids");
        String[] ids = strings.split(",");
        JSONObject object = new JSONObject();
        RestResponse<TtAchievementsBillDto> restResponse = ttAchievementsBillRemoteService.createDto(getAccessToken(), dto, ids);
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
    public String billList(TtAchievementsBillDto dto, ModelMap model) {
        RestResponse<PageDto<TtAchievementsBillDto>> restResponse = ttAchievementsBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("type", TaOfflinePayType.values());
        return "/teamticket/ttproductruleinfo/billlist";
    }

    @RequestMapping(value = "/view")
    public String mangerList(TtOrderInfoDto dto, ModelMap model) {
        RestResponse<PageDto<TtOrderInfoDto>> restResponse = ttOderInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/teamticket/ttproductruleinfo/view";
    }

    /**
     * 导出景区全部员工的绩效信息
     *
     * @param response
     */
    @ResponseBody
    @RequestMapping(value = "/exportTotal")
    public void exportTotal(HttpServletResponse response, TtProductRuleUserDto dto) {
        RestResponse<PageDto<TtProductRuleUserDto>> restResponse = ttProductRuleUserRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<TtProductRuleUserDto> infoDtoList = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("大客户员工绩效", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (TtProductRuleUserDto userDto : infoDtoList) {
                Object[] objects = new Object[4];
                objects[0] = userDto.getAccount();
                objects[1] = userDto.getTotalAmount();
                objects[2] = userDto.getIssuedAmount();
                objects[3] = userDto.getUnissuedAmount();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "大客户员工绩效", new String[]{"员工", "历史绩效总额", "已发放绩效总额",
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
    public void exportBill(HttpServletResponse response, TtAchievementsBillDto dto) {
        RestResponse<PageDto<TtAchievementsBillDto>> restResponse = ttAchievementsBillRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<TtAchievementsBillDto> billDtos = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("大客户绩效账单", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (TtAchievementsBillDto ttAchievementsBillDto : billDtos) {
                String channelNo = null;
                if (!StringUtils.isEmpty(ttAchievementsBillDto.getChannelNo())) {
                    channelNo = TaOfflinePayType.valueOf(ttAchievementsBillDto.getChannelNo()).getTitle();
                }

                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(ttAchievementsBillDto.getCreateTime());
                Object[] objects = new Object[6];
                objects[0] = ttAchievementsBillDto.getSn();
                objects[1] = channelNo;
                objects[2] = ttAchievementsBillDto.getAmount();
                objects[3] = date;
                objects[4] = ttAchievementsBillDto.getCreateName();
                objects[5] = ttAchievementsBillDto.getRemark();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "大客户绩效账单", new String[]{"编号", "支出方式", "支出金额",
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
    public void export(HttpServletResponse response, TtOrderInfoDto dto) {
        RestResponse<PageDto<TtOrderInfoDto>> restResponse = ttOderInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<TtOrderInfoDto> infoDtoList = restResponse.getData().getRecords();
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("大客户绩效明细", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (TtOrderInfoDto infoDto : infoDtoList) {
                //下单时间
                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(infoDto.getTtOrderDto().getCreateTime());
                //消费时间
                /*String consume;
                if (infoDto.getConsumeTime() == null) {
                    consume = "/";
                } else {
                    consume = infoDto.getConsumeTime();
                }*/
                String settle;
                if (infoDto.getSettleAccounts()) {
                    settle = "已结算";
                } else {
                    settle = "未结算";
                }
                Object[] objects = new Object[8];
                objects[0] = infoDto.getMemberName();
                objects[1] = infoDto.getTtOrderDto().getSn();
                objects[2] = date;
                objects[3] = date;
                objects[4] = infoDto.getProductName();
                objects[5] = infoDto.getType().getTitle();
                objects[6] = infoDto.getNumber();
                objects[7] = settle;
                collection.add(objects);
            }
            ExcelUtils.export(collection, "大客户绩效明细", new String[]{"员工", "订单编号",
                            "下单时间", "消费时间", "绩效产品", "绩效方式", "绩效金额", "是否结算"},
                    new int[]{0, 1, 2, 3, 4, 5, 6, 7}, infoDtoList.size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
