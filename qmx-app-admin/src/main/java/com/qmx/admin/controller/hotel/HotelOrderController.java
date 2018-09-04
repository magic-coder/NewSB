package com.qmx.admin.controller.hotel;

import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.hotel.HotelInfoRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelOrderRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelRefundsRemoteService;
import com.qmx.admin.utils.ExcelUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.hotel.api.dto.*;
import com.qmx.hotel.api.enumerate.OrderLogTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.*;

/**
 * Created by zcl on 2017/10/12.
 */
@Controller
@RequestMapping("/hotel/hotelOrder")
public class HotelOrderController extends BaseController {
    @Autowired
    private HotelOrderRemoteService hotelOrderRemoteService;
    @Autowired
    private HotelInfoRemoteService hotelInfoRemoteService;
    @Autowired
    private HotelRefundsRemoteService hotelRefundsRemoteService;

    /**
     * 订单列表
     *
     * @param hotelOrderDto 订单信息
     * @param model         返回数据模型
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(HotelOrderDto hotelOrderDto, ModelMap model) {
        RestResponse<PageDto<HotelOrderDto>> restResponse = hotelOrderRemoteService.findList(getAccessToken(), hotelOrderDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", hotelOrderDto);
        model.addAttribute("page", restResponse.getData());
        return "/hotel/hotelorder/list";
    }

    /**
     * 订单展示页面,通过订单id查询
     *
     * @param hotelOrderDto 订单数据
     * @param model         数据模型
     * @return 订单预览页面
     */
    @RequestMapping(value = "/disPlay")
    public String disPlay(HotelOrderDto hotelOrderDto, ModelMap model) {
        Assert.notNull(hotelOrderDto.getId(), "订单id不能为空");
        //订单日志
        RestResponse<List<HotelOrderLogDto>> hotelOrderLogDtoRest = hotelOrderRemoteService.findOrderLog(getAccessToken(), hotelOrderDto);
        //订单价格
        RestResponse<List<HotelOrderPriceDto>> hotelOrderPriceDtoRest = hotelOrderRemoteService.findHotelOrderPrice(getAccessToken(), hotelOrderDto);
        //订单
        RestResponse<HotelOrderDto> hotelOrderDtoRest = hotelOrderRemoteService.findOrder(getAccessToken(), hotelOrderDto);
        //退款单
        RestResponse<HotelRefundsDto> restResponse = hotelRefundsRemoteService.getRefundsByOrderId(getAccessToken(), hotelOrderDtoRest.getData().getId());

        if (!hotelOrderLogDtoRest.success()) {
            throw new BusinessException(hotelOrderLogDtoRest.getErrorMsg());
        }
        if (!hotelOrderPriceDtoRest.success()) {
            throw new BusinessException(hotelOrderPriceDtoRest.getErrorMsg());
        }
        if (!hotelOrderDtoRest.success()) {
            throw new BusinessException(hotelOrderDtoRest.getErrorMsg());
        }
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        Map map = new HashMap();
        model.addAttribute("logList", hotelOrderLogDtoRest.getData());
        model.addAttribute("dto", hotelOrderDtoRest.getData());
        model.addAttribute("priceList", hotelOrderPriceDtoRest.getData());
        model.addAttribute("sysUserDto", map);
        model.addAttribute("type", OrderLogTypeEnum.values());
        model.addAttribute("refunds", restResponse.getData());
        return "/hotel/hotelorder/disPlay";
    }

    /**
     * 修改页面
     *
     * @param hotelOrderDto 数据传输模型
     * @param model         数据模型
     * @return 返回到订单修改页面
     */
    @RequestMapping(value = "/edit")
    public String edit(HotelOrderDto hotelOrderDto, Model model) {
        Assert.notNull(hotelOrderDto.getId(), "订单id不能为空");
        RestResponse<HotelOrderDto> restResponse = hotelOrderRemoteService.findOrder(getAccessToken(), hotelOrderDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("hotelOrderDto", restResponse.getData());
        model.addAttribute("productName", hotelOrderDto.getProductName());
        return "/hotel/hotelorder/edit";
    }

    /**
     * 更新订单
     *
     * @param hotelOrderDto 更新的信息
     * @return
     */
    @RequestMapping(value = "/saveEdit")
    public String update(HotelOrderDto hotelOrderDto, RedirectAttributes model) {
        Assert.notNull(hotelOrderDto.getId(), "订单id不能为空");
        RestResponse restResponse = hotelOrderRemoteService.updateOrder(hotelOrderDto, getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addFlashAttribute("msg", "操作成功");
        return "redirect:list";
    }

    /**
     * 修改订单支付状态
     *
     * @param hotelOrderDto
     * @param model
     * @return
     */
    @RequestMapping(value = "/changePay")
    public String changePay(HotelOrderDto hotelOrderDto, RedirectAttributes model) {
        RestResponse restResponse = hotelOrderRemoteService.changeOrderPayState(hotelOrderDto, getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addFlashAttribute("msg", restResponse.getData());
        return "redirect:list";
    }

    /**
     * 跳转到添加页面
     *
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(HotelInfoDto hotelInfoDto, Model model) {
        //查询酒店信息
        RestResponse<PageDto<HotelInfoDto>> dtoRestResponse = hotelInfoRemoteService.findList(getAccessToken(), hotelInfoDto);
        model.addAttribute("dto", dtoRestResponse.getData().getRecords());
        return "/hotel/hotelorder/add";
    }

    /**
     * 创建订单
     *
     * @param hotelOrderDto
     * @param orderDataStr  json格式日期和价格：{{"date":2011-11-11,"price":200}}
     * @param orderDateStr  json格式日期：{"date":2011-11-11}
     * @param model
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(HotelOrderDto hotelOrderDto, String orderDataStr, String orderDateStr, RedirectAttributes model) {
        Assert.notNull(hotelOrderDto.getProductId(), "产品id不能为空");
        Assert.notNull(orderDataStr, "订单数据不能为空");
        Assert.notNull(orderDateStr, "订单日期不能为空");
        //生成订单,返回订单的生成状态
        RestResponse<Boolean> restResponse = hotelOrderRemoteService.addOrder(hotelOrderDto, orderDataStr, orderDateStr, getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addFlashAttribute("msg", "订单创建成功");
        return "redirect:list";
    }

    /**
     * 删除订单
     *
     * @param ids 订单的ids数组
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/delete")
    public String delete(String ids) {
        RestResponse<Boolean> restResponse = hotelOrderRemoteService.deleteOrder(ids, getAccessToken());
        if (restResponse.success()) {
            return "1";
        } else {
            return "0";
        }
    }


    /**
     * 退款申请
     *
     * @param hotelOrderDto
     * @return
     */
    @RequestMapping(value = "/refundsOrder")
    public String refundsOrder(HotelOrderDto hotelOrderDto, RedirectAttributes model) {
        Assert.notNull(hotelOrderDto.getId(), "订单id不能为空");
        RestResponse<String> response = hotelOrderRemoteService.refunds(getAccessToken(), hotelOrderDto);
        if (!response.success()) {
            model.addFlashAttribute("msg", "系统内部错误");
        } else {
            model.addFlashAttribute("msg", response.getData());
        }
        return "redirect:list";
    }

    /**
     * 查询要退款的订单数据
     *
     * @param hotelOrderDto
     * @return 返回查询订单的退款信息
     */
    @ResponseBody
    @RequestMapping(value = "/getRefundsOrderByOrderId")
    public Object getRefundsOrderByOrderId(HotelOrderDto hotelOrderDto) {
        Assert.notNull(hotelOrderDto.getId(), "订单id不能为空");
        //根据订单id做查询
        RestResponse<HotelOrderDto> restResponse = hotelOrderRemoteService.findOrder(getAccessToken(), hotelOrderDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return restResponse.getData();
    }

    /**
     * 导出订单
     *
     * @param response
     */
    @ResponseBody
    @RequestMapping(value = "/export")
    public void export(HttpServletResponse response, HotelOrderDto dto) {
        RestResponse<List<HotelOrderDto>> restResponse = hotelOrderRemoteService.exportOrder(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        try {
            OutputStream out = response.getOutputStream();
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("酒店订单", "UTF-8") + ".xls");
            Collection<Object[]> collection = new ArrayList<>();
            for (HotelOrderDto hotelOrderDto : restResponse.getData()) {
                Object[] objects = new Object[11];
                objects[0] = hotelOrderDto.getContactName();
                objects[1] = hotelOrderDto.getContactPhone();
                objects[2] = hotelOrderDto.getProductName();
                objects[3] = hotelOrderDto.getRoomNumber();
                objects[4] = hotelOrderDto.getPayment();
                objects[5] = hotelOrderDto.getPaymentStatus();
                objects[6] = hotelOrderDto.getStatus();
                objects[7] = hotelOrderDto.getRefundState();
                objects[8] = hotelOrderDto.getCheckIn();
                objects[9] = hotelOrderDto.getCheckOut();
                objects[10] = hotelOrderDto.getCreateTime();
                collection.add(objects);
            }
            ExcelUtils.export(collection, "酒店订单", new String[]{"客户姓名", "客户电话", "产品名称",
                            "房间数量", "总金额", "支付状态", "订单状态", "退款状态", "入住时间", "离店时间", "订房日期"},
                    new int[]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, restResponse.getData().size(), out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
