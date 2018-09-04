package com.qmx.admin.controller.tickets;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.tickets.TicketsStockRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.tickets.api.dto.SysTicketsStockDTO;
import com.qmx.tickets.api.query.SysTicketsStockVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Author liubin
 * @Description 门票库存管理
 * @Date Created on 2017/12/19 16:20.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/stock")
public class TicketsStockController extends BaseController {

    @Autowired
    private TicketsStockRemoteService ticketsStockRemoteService;

    @RequestMapping("/list")
    public String list(HttpServletRequest request, SysTicketsStockVO sysTicketsStockVO) {
        RestResponse<PageDto<SysTicketsStockDTO>> restResponse = ticketsStockRemoteService.findPage(getAccessToken(), sysTicketsStockVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryVo", sysTicketsStockVO);
        request.setAttribute("page", restResponse.getData());
        return "/tickets/stock/list";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response) {
        return "/tickets/stock/add";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysTicketsStockDTO> restResponse = ticketsStockRemoteService.findById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysTicketsStockDTO sysTicketsStockDTO = restResponse.getData();
        request.setAttribute("dto", sysTicketsStockDTO);
        return "/tickets/stock/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(SysTicketsStockDTO sysTicketsStockDTO) {
        Assert.notNull(sysTicketsStockDTO, "库存信息不能为空");
        RestResponse<SysTicketsStockDTO> restResponse = ticketsStockRemoteService.createStock(getAccessToken(), sysTicketsStockDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(SysTicketsStockDTO sysTicketsStockDTO) {
        Assert.notNull(sysTicketsStockDTO, "库存信息不能为空");
        RestResponse<SysTicketsStockDTO> restResponse = ticketsStockRemoteService.updateStock(getAccessToken(), sysTicketsStockDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = ticketsStockRemoteService.deleteStock(getAccessToken(), new Long[]{id});
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }
}
