package com.qmx.admin.controller.tickets;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SmsTemplateRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.tickets.*;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.base.core.utils.RequestUtils;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.tickets.api.dto.SysDistributionDTO;
import com.qmx.tickets.api.dto.SysDistributionPriceDTO;
import com.qmx.tickets.api.dto.SysTicketsDTO;
import com.qmx.tickets.api.query.SysDistributionVO;
import com.qmx.tickets.api.query.SysTicketsVO;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.*;

/**
 * @Author liubin
 * @Description 产品授权管理
 * @Date Created on 2017/12/6 10:31.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/distribution")
public class DistributionController extends BaseController {

    private static final String DISTRIBUTION = "distributions";
    private static final String PRODUCTID = "productId";
    private static final String bookRuleName = "bookRuleName";
    private static final String consumeRuleName = "consumeRuleName";
    private static final String refundRuleName = "refundRuleName";

    /*@Autowired
    private TicketsTypeRemoteService ticketsTypeRemoteService;
    @Autowired
    private SmsTemplateRemoteService smsTemplateRemoteService;*/
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TicketsRemoteService ticketsRemoteService;
    @Autowired
    private DistributionRemoteService distributionRemoteService;
    /*@Autowired
    private BookRuleRemoteService bookRuleRemoteService;
    @Autowired
    private ConsumeRuleRemoteService consumeRuleRemoteService;
    @Autowired
    private RefundRuleRemoteService refundRuleRemoteService;*/


    @RequestMapping("/list")
    public String ticketsList(
            HttpServletRequest request, SysDistributionVO distributionVO) {
        SysUserDto currentMember = getCurrentMember();
        if(currentMember.getUserType() != SysUserType.admin){
            distributionVO.setSupplierId(currentMember.getId());
        }
        RestResponse<PageDto<SysDistributionDTO>> restResponse = distributionRemoteService.findPageWithBasic(getAccessToken(), distributionVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryVO", distributionVO);
        request.setAttribute("page", restResponse.getData());
        return "/tickets/distribution/list";
    }

    /**
     * 按产品授权
     *
     * @param request
     */
    @RequestMapping(value = "/addByProduct", method = RequestMethod.GET)
    public String addByProduct(HttpServletRequest request) {
        return "/tickets/distribution/authorize";
    }

    /**
     * 获取产品授权列表（下拉菜单使用）
     *
     * @param q
     * @param page
     * @param row
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/listProductAuthorizeJson", method = RequestMethod.POST)
    public Object listProductAuthorizeJson(
            @RequestParam(defaultValue = "") String q, @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer row) {
        SysTicketsVO sysTicketsVO = new SysTicketsVO();
        sysTicketsVO.setName(q);
        sysTicketsVO.setPageIndex(page);
        sysTicketsVO.setPageSize(row);
        RestResponse<PageDto<SysTicketsDTO>> restResponse = distributionRemoteService.findPageForDistribution(getAccessToken(), sysTicketsVO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<>();
        PageDto<SysTicketsDTO> sysTicketsDTO = restResponse.getData();
        for (SysTicketsDTO product : sysTicketsDTO.getRecords()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", product.getId() + "");
            map.put("sn", product.getSn());
            map.put("ticketTypeName", product.getTicketTypeName() == null ? "" : product.getTicketTypeName());
            map.put("name", product.getName() == null ? "" : product.getName());
            rows.add(map);
        }
        result.put("total", sysTicketsDTO.getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    /**
     * 获取授权分销列表
     *
     * @param request
     * @param userQueryVo
     * @return
     */
    @RequestMapping(value = "/listDistributorForAuthorize", method = RequestMethod.GET)
    public String listDistributorForAuthorize(HttpServletRequest request, UserQueryVo userQueryVo) {

        SysUserDto sysUserDto = getCurrentMember();
        userQueryVo.setUserType(SysUserType.distributor);
        if (sysUserDto.getUserType() == SysUserType.admin) {
            //管理员查一级
            userQueryVo.setLevel(1);
        } else if (sysUserDto.getUserType() == SysUserType.supplier) {
            //供应商查一级
            userQueryVo.setLevel(1);
        } else if (sysUserDto.getUserType() == SysUserType.distributor) {
            //分销商查二级
            userQueryVo.setLevel(2);
        } else {
            //其他(暂时限定员工)
            userQueryVo.setUserType(SysUserType.employee);
        }

        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("queryDto", userQueryVo);
        request.setAttribute("page", restResponse.getData());
        return "/tickets/distribution/list_distributor_for_authorize";
    }


    /**
     * 保存授权基本信息
     */
    @RequestMapping(value = "/saveDistributionByProduct", method = RequestMethod.POST)
    public String saveDistributionByProduct(
            HttpServletRequest request, @RequestParam Long productId,
            @RequestParam Long[] distributor) {

        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(productId);
        SysTicketsDTO ticketsDTO = restResponse.getData();
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        if (ticketsDTO == null) {
            throw new BusinessException("没有此产品");
        }

        List<Long> distributionIds = new ArrayList<>();
        //List<SysDistributionDTO> distributions = new ArrayList<>();
        for (int i = 0; distributor != null && i < distributor.length; i++) {
            Long pid = distributor[i];
            distributionIds.add(pid);
        }

        //放入session方便下一步操作
        request.getSession().setAttribute(DISTRIBUTION, distributionIds);
        request.getSession().setAttribute(PRODUCTID, productId);

        SysUserDto sysUserDto = getCurrentMember();
        if (sysUserDto.getUserType() == SysUserType.admin || sysUserDto.getUserType() == SysUserType.supplier) {
            //跳转到选择规则页面
            return "redirect:selectAuthorizeRule";
        }
        return "redirect:batchEditAuthorize";
    }

    /**
     * 选择规则页面
     * selectAuthorizeRule
     *
     * @param request
     * @return
     */
    @RequestMapping("/selectAuthorizeRule")
    public String selectAuthorizeRule(HttpServletRequest request) {
        Long productId = (Long) request.getSession().getAttribute(PRODUCTID);
        if (productId == null) {
            throw new BusinessException("授权异常，未获取到产品id");
        }

        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(productId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysTicketsDTO sysTicketsDTO = restResponse.getData();
        if (sysTicketsDTO == null) {
            throw new BusinessException("未找到门票信息");
        }
        request.setAttribute("dto", sysTicketsDTO);
        return "/tickets/distribution/select_authorize_rule";
    }

    /**
     * 跳转批量更新
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/batchEditAuthorize")
    public String batchEditAuthorize(HttpServletRequest request, ModelMap model) {

        List<Long> lists = (List<Long>) request.getSession().getAttribute(DISTRIBUTION);
        Long productId = (Long) request.getSession().getAttribute(PRODUCTID);
        if (lists == null || lists.size() == 0 || productId == null) {
            throw new BusinessException("授权异常，请重新授权");
        }

        SysUserDto sysUserDto = getCurrentMember();
        if (sysUserDto.getUserType() == SysUserType.admin || sysUserDto.getUserType() == SysUserType.supplier) {
            Long bookRuleId = RequestUtils.getLong(request, "defaultBookRuleId", null);
            Long consumeRuleId = RequestUtils.getLong(request, "defaultConsumeRuleId", null);
            Long refundRuleId = RequestUtils.getLong(request, "defaultRefundRuleId", null);
            Assert.notNull(bookRuleId, "bookRuleId不能为空");
            Assert.notNull(consumeRuleId, "consumeRuleId不能为空");
            Assert.notNull(refundRuleId, "refundRuleId不能为空");
            //放入session方便下一步操作
            request.getSession().setAttribute(bookRuleName, bookRuleId);
            request.getSession().setAttribute(consumeRuleName, consumeRuleId);
            request.getSession().setAttribute(refundRuleName, refundRuleId);
        }else{
            RestResponse<SysDistributionDTO> restResponse = distributionRemoteService.findDistribution(getAccessToken(),sysUserDto.getId(),productId);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            request.setAttribute("pDistribution",restResponse.getData());
        }

        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(productId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        String distribution = "";
        RestResponse<Map<Long, SysUserDto>> distributionList = sysUserRemoteService.findByIds(lists);
        if (!distributionList.success()) {
            throw new BusinessException(distributionList.getErrorMsg());
        }

        Map<Long, SysUserDto> userDtoMap = distributionList.getData();
        for (SysUserDto dto : userDtoMap.values()) {
            distribution += dto.getUsername() + ",";
        }

        model.addAttribute("distribution", distribution);
        model.addAttribute("product", restResponse.getData());
        return "/tickets/distribution/batch_edit";
    }

    /**
     * 执行批量更新
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/batchUpdateAuthorize", method = RequestMethod.POST)
    public String batchUpdateAuthorize(
            HttpServletRequest request, ModelMap model) {

        List<Long> lists = (List<Long>) request.getSession().getAttribute(DISTRIBUTION);
        Long productId = (Long) request.getSession().getAttribute(PRODUCTID);
        Long bookRuleId = (Long) request.getSession().getAttribute(bookRuleName);
        Long consumeRuleId = (Long) request.getSession().getAttribute(consumeRuleName);
        Long refundRuleId = (Long) request.getSession().getAttribute(refundRuleName);
        if (lists == null || lists.size() == 0 || productId == null) {
            throw new BusinessException("授权异常，请重新授权");
        }
        SysUserDto sysUserDto = getCurrentMember();
        if (sysUserDto.getUserType() == SysUserType.admin || sysUserDto.getUserType() == SysUserType.supplier) {
            if (bookRuleId == null || consumeRuleId == null || refundRuleId == null) {
                throw new BusinessException("授权异常2，请重新授权");
            }
        }
        //Integer stockNum = RequestUtils.getInt(request, "totalStock", -1);//日历库存授权时能用上
        int specifyDate = RequestUtils.getInt(request, "specifyDate", 0);
        //int customSaleFlag = RequestUtils.getInt(request, "customSaleFlag", 0);
        String weeks = RequestUtils.getString(request, "weeks", null);
        //int useEffectiveDay = RequestUtils.getInt(request, "useEffectiveDay", 0);

        //售卖日期
        String saleStartTime = RequestUtils.getString(request, "saleStartTime", null);
        String saleEndTime = RequestUtils.getString(request, "saleEndTime", null);

        Date saleStart = null;
        Date saleEnd = null;
        if(saleStartTime != null && saleEndTime != null){
            try{
                saleStart = DateUtil.parse(saleStartTime,"yyyy-MM-dd HH:mm:ss");
                saleEnd = DateUtil.parse(saleEndTime,"yyyy-MM-dd HH:mm:ss");
            }catch (Exception e){
                throw new ValidationException("售卖日期格式错误");
            }
        }
        //长期售卖
        String beginDate = RequestUtils.getString(request, "beginDate", null);
        String endDate = RequestUtils.getString(request, "endDate", null);
        Integer stock = RequestUtils.getInt(request, "stock", -1);//手动填写库存
        BigDecimal suggestPrice = RequestUtils.getBigDecimal(request, "suggestPrice", null);
        BigDecimal authPrice = RequestUtils.getBigDecimal(request, "authPrice", null);

        RestResponse<SysTicketsDTO> restResponse = ticketsRemoteService.findById(productId);
        if (!restResponse.success()) {
            throw new ValidationException(restResponse.getErrorMsg());
        }

        SysTicketsDTO product = restResponse.getData();
        if (product == null) {
            throw new ValidationException("授权异常，请重新授权");
        }

        String datePriceData = request.getParameter("datePriceData");
        datePriceData = HtmlUtils.htmlUnescape(datePriceData);

        List<SysDistributionDTO> distributionDTOList = new ArrayList<>();
        for (Long distId : lists) {

            SysDistributionDTO sysDistributionDTO = new SysDistributionDTO();
            sysDistributionDTO.setSaleStartTime(saleStart);
            sysDistributionDTO.setSaleEndTime(saleEnd);
            sysDistributionDTO.setMemberId(distId);
            sysDistributionDTO.setProductId(productId);
            sysDistributionDTO.setBookRuleId(bookRuleId);
            sysDistributionDTO.setConsumeRuleId(consumeRuleId);
            sysDistributionDTO.setRefundRuleId(refundRuleId);
            sysDistributionDTO.setWeeks(weeks);
            //sysDistributionDTO.setCustomSaleFlag(customSaleFlag == 1);
            sysDistributionDTO.setVsdate(beginDate);
            sysDistributionDTO.setVedate(endDate);
            sysDistributionDTO.setUseEffectiveDay(1);//当天有效
            //sysDistributionDTO.setStock(stock);
            //如果需要指定日期
            sysDistributionDTO.setSpecifyDate(specifyDate == 1);
            List<SysDistributionPriceDTO> priceList = new ArrayList<>();
            if (sysDistributionDTO.getSpecifyDate()) {
                sysDistributionDTO.setStock(stock);
                JSONObject obj = JSONObject.parseObject(datePriceData);
                if (!obj.isEmpty()) {
                    BigDecimal datePrice;
                    for (Object key : obj.keySet()) {
                        String date = key.toString();
                        if (StringUtils.isEmpty(date)) {
                            throw new ValidationException("有空日期");
                        }
                        if (!DateUtil.isValidDate(date)) {
                            continue;
                        }
                        JSONObject json = obj.getJSONObject(key.toString());
                        SysDistributionPriceDTO price = new SysDistributionPriceDTO();
                        //不用设置id服务端已自动添加
                        //price.setPdPriceId(pId);
                        //price.setDistributionId(productDistribution);

                        price.setUseDate(date);
                        price.setSuggestPrice(new BigDecimal(json.getString("suggestPrice")));
                        datePrice = new BigDecimal(json.getString("sellPrice"));
                        price.setAuthPrice(datePrice);
                        price.setStock(new Integer(json.getString("stock")));
                        priceList.add(price);
                        //newPriceMap.put(date, price.getSellPrice());
                    }
                }
            } else {
                //长期售卖
                sysDistributionDTO.setStock(stock);
                //sysDistributionDTO.setVsdate(beginDate);
                //sysDistributionDTO.setVedate(endDate);
                sysDistributionDTO.setSuggestPrice(suggestPrice);
                sysDistributionDTO.setAuthPrice(authPrice);
            }

            sysDistributionDTO.setDistributionPrices(priceList);
            distributionDTOList.add(sysDistributionDTO);
        }
        RestResponse<Boolean> distributionResponse = distributionRemoteService.batchCreateSysDistribution(getAccessToken(), distributionDTOList);
        if (!distributionResponse.success()) {
            throw new BusinessException(distributionResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 查看
     */
    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public String view(Long id, ModelMap model) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysDistributionDTO> pd = distributionRemoteService.findById(id);
        if (!pd.success()) {
            throw new BusinessException(pd.getErrorMsg());
        }
        SysDistributionDTO distributionDTO = pd.getData();
        String jsonData = "{}";
        JSONObject obj = new JSONObject();
        List<SysDistributionPriceDTO> distPrices = distributionDTO.getDistributionPrices();
        if (distributionDTO.getSpecifyDate() && distPrices != null) {
            for (SysDistributionPriceDTO dprice : distPrices) {
                JSONObject json = new JSONObject();
                json.put("id", dprice.getId() + "");
                json.put("sellPrice", dprice.getAuthPrice());
                json.put("suggestPrice", dprice.getSuggestPrice());
                json.put("stock", dprice.getStock());
                obj.put(dprice.getUseDate(), json);
            }
            jsonData = obj.toJSONString();
        }
        model.addAttribute("datePriceData", jsonData);
        model.addAttribute("distribution", distributionDTO);
        return "/tickets/distribution/view";
    }


    /**
     * 编辑授权
     */
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(Long id, ModelMap model) {
        Assert.notNull(id, "id不能为空");
        RestResponse<SysDistributionDTO> pd = distributionRemoteService.findById(id);
        if (!pd.success()) {
            throw new BusinessException(pd.getErrorMsg());
        }
        SysDistributionDTO distributionDTO = pd.getData();
        String jsonData = "{}";
        JSONObject obj = new JSONObject();
        List<SysDistributionPriceDTO> distPrices = distributionDTO.getDistributionPrices();
        if (distributionDTO.getSpecifyDate()) {
            if (distPrices != null) {
                for (SysDistributionPriceDTO dprice : distPrices) {
                    JSONObject json = new JSONObject();
                    json.put("id", dprice.getId() + "");
                    json.put("sellPrice", dprice.getAuthPrice());
                    json.put("suggestPrice", dprice.getSuggestPrice());
                    json.put("stock", dprice.getStock());
                    obj.put(dprice.getUseDate(), json);
                }
                jsonData = obj.toJSONString();
            }
        } else {
            obj.put("beginDate", distributionDTO.getVsdate());
            obj.put("endDate", distributionDTO.getVedate());
            obj.put("suggestPrice", distributionDTO.getSuggestPrice());
            obj.put("sellPrice", distributionDTO.getAuthPrice());
            obj.put("stock", distributionDTO.getStock());
            obj.put("cannotUseDay", distributionDTO.getCannotUseDays());
            //{"beginDate":"2017-12-08","endDate":"2017-12-08","suggestPrice":"22","sellPrice":"20","stock":"9999","cannotUseDay":""}
        }

        if(distributionDTO.getParentId() != null){
            RestResponse<SysDistributionDTO> restResponse = distributionRemoteService.findById(distributionDTO.getParentId());
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
            SysDistributionDTO pDistribution = restResponse.getData();
            model.addAttribute("pDistribution",pDistribution);
        }
        model.addAttribute("datePriceData", jsonData);
        model.addAttribute("distribution", distributionDTO);
        return "/tickets/distribution/edit";
    }


    /**
     * 更新授权
     *
     * @param id
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/updateDistribution", method = RequestMethod.POST)
    public String updateDistribution(Long id, HttpServletRequest request, ModelMap model) {
        Assert.notNull(id, "授权id信息不能为空");
        RestResponse<SysDistributionDTO> pd = distributionRemoteService.findById(id);
        if (!pd.success()) {
            throw new BusinessException(pd.getErrorMsg());
        }
        SysDistributionDTO distributionDTO = pd.getData();
        if (distributionDTO == null) {
            throw new BusinessException("未找到授权信息");
        }
        //Integer stockNum = RequestUtils.getInt(request, "totalStock", -1);//日历库存授权时能用上
        String datePriceData = request.getParameter("datePriceData");
        int specifyDate = RequestUtils.getInt(request, "specifyDate", 0);
        datePriceData = HtmlUtils.htmlUnescape(datePriceData);
        //int customSaleFlag = RequestUtils.getInt(request, "customSaleFlag", 0);
        String weeks = RequestUtils.getString(request, "weeks", null);
        //int useEffectiveDay = RequestUtils.getInt(request, "useEffectiveDay", 0);

        //售卖日期
        String saleStartTime = RequestUtils.getString(request, "saleStartTime", null);
        String saleEndTime = RequestUtils.getString(request, "saleEndTime", null);
        Date saleStart = null;
        Date saleEnd = null;
        if(saleStartTime != null && saleEndTime != null){
            try{
                saleStart = DateUtil.parse(saleStartTime,"yyyy-MM-dd HH:mm:ss");
                saleEnd = DateUtil.parse(saleEndTime,"yyyy-MM-dd HH:mm:ss");
            }catch (Exception e){
                throw new ValidationException("售卖日期格式错误");
            }
        }
        //预定规则
        Long bookRuleId = RequestUtils.getLong(request, "bookRuleId", null);
        Long consumeRuleId = RequestUtils.getLong(request, "consumeRuleId", null);
        Long refundRuleId = RequestUtils.getLong(request, "refundRuleId", null);

        //长期售卖
        String beginDate = RequestUtils.getString(request, "beginDate", null);
        String endDate = RequestUtils.getString(request, "endDate", null);
        Integer stock = RequestUtils.getInt(request, "stock", -1);//手动填写库存
        BigDecimal suggestPrice = RequestUtils.getBigDecimal(request, "suggestPrice", null);
        BigDecimal authPrice = RequestUtils.getBigDecimal(request, "authPrice", null);

        //如果需要指定日期
        distributionDTO.setSaleStartTime(saleStart);
        distributionDTO.setSaleEndTime(saleEnd);
        distributionDTO.setSpecifyDate(specifyDate == 1);
        distributionDTO.setBookRuleId(bookRuleId);
        distributionDTO.setConsumeRuleId(consumeRuleId);
        distributionDTO.setRefundRuleId(refundRuleId);
        distributionDTO.setWeeks(weeks);
        //distributionDTO.setCustomSaleFlag(customSaleFlag == 1);
        distributionDTO.setVsdate(beginDate);
        distributionDTO.setVedate(endDate);
        distributionDTO.setUseEffectiveDay(1);//当天有效
        List<SysDistributionPriceDTO> priceList = new ArrayList<>();
        //Map<String,BigDecimal> newPriceMap = new HashMap<>();
        if (distributionDTO.getSpecifyDate()) {
            distributionDTO.setStock(stock);
            if (StringUtils.isNotEmpty(datePriceData)) {
                JSONObject obj = JSONObject.parseObject(datePriceData);
                if (!obj.isEmpty()) {
                    //BigDecimal datePrice = BigDecimal.ZERO;
                    for (Object key : obj.keySet()) {
                        String date = key.toString();
                        if (StringUtils.isEmpty(date)) {
                            throw new ValidationException("有空日期");
                        }
                        if (!DateUtil.isValidDate(date)) {
                            continue;
                        }
                        JSONObject json = obj.getJSONObject(key.toString());
                        SysDistributionPriceDTO price = new SysDistributionPriceDTO();
                        price.setUseDate(date);
                        price.setSuggestPrice(new BigDecimal(json.getString("suggestPrice")));
                        //datePrice = new BigDecimal(json.getString("sellPrice"));
                        price.setAuthPrice(new BigDecimal(json.getString("sellPrice")));
                        price.setStock(new Integer(json.getString("stock")));
                        priceList.add(price);
                    }
                }
            }
        } else {
            distributionDTO.setStock(stock);
            distributionDTO.setVsdate(beginDate);
            distributionDTO.setVedate(endDate);
            distributionDTO.setSuggestPrice(suggestPrice);
            distributionDTO.setAuthPrice(authPrice);
        }

        distributionDTO.setDistributionPrices(priceList);
        RestResponse<SysDistributionDTO> restResponse = distributionRemoteService.createSysDistribution(getAccessToken(), distributionDTO);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    /**
     * 删除授权信息
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id) {
        Assert.notNull(id, "授权id信息不能为空");
        RestResponse<Boolean> restResponse = distributionRemoteService.deleteDistribution(getAccessToken(),new Long[]{id});
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

}
