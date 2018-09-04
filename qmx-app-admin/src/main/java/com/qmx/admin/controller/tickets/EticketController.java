package com.qmx.admin.controller.tickets;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysOrderSourceRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.tickets.EticketRemoteService;
import com.qmx.admin.remoteapi.tickets.SightRemoteService;
import com.qmx.admin.remoteapi.tickets.TicketsOrderServiceRemoteService;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysOrderSourceDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.enumerate.PayMethodEnum;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.tickets.api.dto.SysEticketDTO;
import com.qmx.tickets.api.dto.SysOrderDTO;
import com.qmx.tickets.api.dto.SysSightDTO;
import com.qmx.tickets.api.enumerate.*;
import com.qmx.tickets.api.query.SysEticketVO;
import com.qmx.tickets.api.query.SysOrderVO;
import com.qmx.tickets.api.query.SysSightVO;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author liubin
 * @Description 电子票
 * @Date Created on 2017/12/11 14:53.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/eticket")
public class EticketController extends BaseController {

    @Autowired
    private EticketRemoteService eticketRemoteService;
    @Autowired
    private SightRemoteService sightRemoteService;
    @Autowired
    private SysOrderSourceRemoteService orderSourceRemoteService;
    @Autowired
    private TicketsOrderServiceRemoteService orderServiceRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    /**
     * 列表
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(HttpServletRequest request, SysOrderVO sysOrderVO) {
        //long s = System.currentTimeMillis();
        String snAndName = RequestUtils.getString(request, "snAndName", null);
        if (StringUtils.isNumeric(snAndName)) {
            sysOrderVO.setProductSn(snAndName);
        } else {
            sysOrderVO.setProductName(snAndName);
        }
        sysOrderVO.setEticketUsed(Boolean.TRUE);//有值就行
        RestResponse<PageDto<SysOrderDTO>> orderResponse = orderServiceRemoteService.findPage(getAccessToken(), sysOrderVO);
        if (!orderResponse.success()) {
            throw new BusinessException(orderResponse.getErrorMsg());
        }
        //System.out.println("===" + (System.currentTimeMillis() - s) + "ms");
        //request.setAttribute("queryTypes", QueryTypeEnum.values());
        SysUserDto currentMember = getCurrentMember();
        //仅限管理员
        if (currentMember.getUserType() == SysUserType.admin) {
            UserQueryVo userQueryVo = new UserQueryVo();
            userQueryVo.setPageSize(20);
            userQueryVo.setUserType(SysUserType.supplier);
            RestResponse<PageDto<SysUserDto>> supplierResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
            if (!supplierResponse.success()) {
                throw new BusinessException(supplierResponse.getErrorMsg());
            }
            PageDto<SysUserDto> supplierPage = supplierResponse.getData();
            SysSightVO sysSightVO = new SysSightVO();
            sysSightVO.setPageSize(20);
            RestResponse<PageDto<SysSightDTO>> sightResponse = sightRemoteService.findPage(getAccessToken(), sysSightVO);
            if (!sightResponse.success()) {
                throw new BusinessException(sightResponse.getErrorMsg());
            }
            PageDto<SysSightDTO> sightPage = sightResponse.getData();
            if (supplierPage != null) {
                request.setAttribute("supplierList", supplierPage.getRecords());
            }
            if (sightPage != null) {
                request.setAttribute("sightList", sightPage.getRecords());
            }
        }

        RestResponse<List<SysOrderSourceDTO>> orderSourceResponse = orderSourceRemoteService.findEffectiveList(getAccessToken(), getCurrentModuleId(request));
        if (!orderSourceResponse.success()) {
            throw new BusinessException(orderSourceResponse.getErrorMsg());
        }
        List<SysOrderSourceDTO> orderSourcePage = orderSourceResponse.getData();

        if (orderSourcePage != null) {
            request.setAttribute("orderSources", orderSourcePage);
        }

        List<SaleChannelEnum> list = new ArrayList<>();
        list.add(SaleChannelEnum.BACK_ORDER);
        list.add(SaleChannelEnum.OTA_ORDER);
        list.add(SaleChannelEnum.QR_CODE_PAY);
        list.add(SaleChannelEnum.INTERNAL_ORDER);
        list.add(SaleChannelEnum.WAP_SHOP);
        list.add(SaleChannelEnum.WX_APPLET);
        list.add(SaleChannelEnum.PC_SHOP);
        request.setAttribute("queryDto", sysOrderVO);
        request.setAttribute("snAndName", snAndName);
        request.setAttribute("saleChannels", list);
        request.setAttribute("payStatusList", OrderPayStatusEnum.values());
        request.setAttribute("payMethodList", PayMethodEnum.values());
        request.setAttribute("refundStatusList", RefundStatusEnum.values());
        request.setAttribute("shippingStatusList", ShippingStatusEnum.values());
        request.setAttribute("flagCollapsedx", RequestUtils.getString(request, "flagCollapsed", "false"));
        request.setAttribute("currentMember", currentMember);
        request.setAttribute("page", orderResponse.getData());
        return "/tickets/eticket/order_list";
    }

    /**
     * 验票查询
     */
    @RequestMapping(value = "/queryUnConsumeList", method = RequestMethod.GET)
    public String queryUnConsumeList(@RequestParam String sn, ModelMap model) {
        Assert.hasLength(sn, "请输入电子票或手机号码");
        String eticket = null;
        String phone = null;
        String orderId = null;
        if (sn.length() == 12) {
            eticket = sn;
        } else if (sn.length() == 11) {
            phone = sn;
        } else {
            orderId = sn;
        }
        RestResponse<List<SysEticketDTO>> restResponse = eticketRemoteService.queryUnConsumeEticket(getAccessToken(), eticket, orderId, phone);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("list", restResponse.getData());
        model.addAttribute("sn", sn);
        return "/tickets/consume/query_eticket";
    }

    /**
     * 消费电子票
     *
     * @param sn
     * @return
     */
    @RequestMapping(value = "/consumeByIds", method = RequestMethod.POST)
    public String consumeEticket(Long[] ids, String sn,RedirectAttributes redirectAttributes) {
        Assert.notNull(ids, "ids不能为空");
        RestResponse<Integer> restResponse = eticketRemoteService.consumeEticket(getAccessToken(), ids, ConsumeTypeEnum.ONLINE_BACK);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        addFlashMessage(redirectAttributes,"成功消费"+restResponse.getData()+"张！");
        return "redirect:queryUnConsumeList?sn=" + sn;
    }

    /**
     * 结算
     */
    @ResponseBody
    @RequestMapping(value = "/settle", method = RequestMethod.POST)
    public Object settle(Long[] ids) {
        return "";
    }

    /**
     * 删除
     */
    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public Object delete(Long[] ids) {

        return "";
    }

}