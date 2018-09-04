package com.qmx.admin.controller.hotel;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.hotel.HotelRefundsRemoteService;
import com.qmx.admin.utils.ExcelUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.hotel.api.dto.HotelRefundsDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by zcl on 2017/10/25.
 */
@Controller
@RequestMapping("/hotel/hotelRefunds")
public class HotelOrderRefundsController extends BaseController {
    @Autowired
    private HotelRefundsRemoteService hotelRefundsRemoteService;

    /**
     * 退款列表
     *
     * @param hotelRefundsDto 退款单
     * @param model
     * @param cTime           申请时间
     * @param uTime           结束时间
     * @return
     */
    @RequestMapping("/list")
    public String list(HotelRefundsDto hotelRefundsDto, ModelMap model, String cTime, String uTime) {
        RestResponse<PageDto<HotelRefundsDto>> restResponse = hotelRefundsRemoteService.findList(getAccessToken(), hotelRefundsDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("hotelRefundsDto", hotelRefundsDto);
        model.addAttribute("page", restResponse.getData());
        return "/hotel/hotelrefunds/list";
    }

    /**
     * 通过id查询退款信息并展示该退款信息
     *
     * @param dto 退款信息
     * @return 返回退款信息
     */
    @RequestMapping("/disPlay")
    public String disPlay(HotelRefundsDto dto, ModelMap modelMap) {
        Assert.notNull(dto.getId(), "退款信息所属id不能为空");
        //查询退款信息
        RestResponse<HotelRefundsDto> response = hotelRefundsRemoteService.findOrderRefunds(getAccessToken(), dto);
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        modelMap.addAttribute("dto", response.getData());
        return "/hotel/hotelrefunds/display";
    }

    /**
     * 更新订单的退款状态和退款单中的退款状态（是否同意退款）
     *
     * @param dto
     * @return 返回退款状态
     */
    @RequestMapping(value = "/update")
    public String update(HotelRefundsDto dto, RedirectAttributes model) {
        Assert.notNull(dto.getId(), "退款信息id不能为空");
        //更新退款状态
        RestResponse<Boolean> response = hotelRefundsRemoteService.updateOrderRefunds(getAccessToken(), dto);
        if (!response.success()) {
            model.addFlashAttribute("msg", "操作失败");
        } else {
            model.addFlashAttribute("msg", "操作成功");
        }
        return "redirect:list";
    }

    /**
     * 导出退款数据
     *
     * @param response
     */
    @ResponseBody
    @RequestMapping(value = "export")
    public void export(HttpServletResponse response) {
        RestResponse<List<HotelRefundsDto>> restResponse = hotelRefundsRemoteService.exportRefunds(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" +
                    URLEncoder.encode("酒店订单", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (HotelRefundsDto hotelRefundsDto : restResponse.getData()) {
                Object[] objects = new Object[11];
                objects[0] = hotelRefundsDto.getOrderSn();
                objects[1] = "";//退款方式
                objects[2] = hotelRefundsDto.getCreateTime();
                objects[3] = hotelRefundsDto.getUpdateTime();
                objects[4] = hotelRefundsDto.getContactName();
                objects[5] = hotelRefundsDto.getContactMobile();
                objects[6] = hotelRefundsDto.getProductName();
                objects[7] = hotelRefundsDto.getQuantity();
                objects[8] = hotelRefundsDto.getAmount();
                objects[9] = hotelRefundsDto.getState();
                objects[10] = hotelRefundsDto.getMemo();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "退款数据表", new String[]{"订单编号", "退款方式", "申请时间",
                            "结束时间", "姓名", "联系电话", "产品名称", "退款数量", "退款金额", "退款状态", "备注"},
                    new int[]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, restResponse.getData().size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
