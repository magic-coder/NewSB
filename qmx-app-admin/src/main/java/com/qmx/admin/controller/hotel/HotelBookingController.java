package com.qmx.admin.controller.hotel;

import com.alibaba.fastjson.JSONArray;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.hotel.*;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.hotel.api.dto.HotelProductDto;
import com.qmx.hotel.api.dto.HotelProductImpowerDto;
import com.qmx.hotel.api.dto.HotelProductImpowerRateDto;
import com.qmx.hotel.api.dto.HotelProductRateDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * 酒店预订控制器
 * Created by zcl on 2017/11/1.
 */
@Controller
@RequestMapping("/hotel/hotelBooking")
public class HotelBookingController extends BaseController {
    @Autowired
    private HotelInfoRemoteService hotelInfoRemoteService;
    @Autowired
    private HotelProductRemoteService hotelProductRemoteService;
    @Autowired
    private HotelProductRateRemoteService hotelProductRateRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private HotelProductImpowerRemoteService hotelProductImpowerRemoteService;
    @Autowired
    private HotelProductImpowerRateRemoteService hotelProductImpowerRateRemoteService;
    Logger logger = LoggerFactory.getLogger(HotelBookingController.class);

    /**
     * 查询所有的酒店名称,跳转到产品预订页面
     *
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/findAllHotel")
    public String findAllHotel(ModelMap modelMap) {
        return "/hotel/hotelbooking/choose";
    }

    /**
     * 查询该时间段库存库存大于0的酒店
     *
     * @param sTime 入住时间
     * @param eTime 离店时间
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/findHotel")
    public Map findHotel(String sTime, String eTime) {
        Assert.notNull(sTime, "入住时间不能为空");
        Assert.notNull(eTime, "离店时间不能为空");
        //查询该时间段库存库存大于0的酒店
        RestResponse<Map> restResponse = hotelInfoRemoteService.findHotelByTime(getAccessToken(), sTime, eTime);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());//BusinessException 业务异常类
        }
        return restResponse.getData();
    }

    /**
     * 查询出该酒店下该时间段内所有产品的最低库存量
     *
     * @param hotelProductDto
     * @param sTime           开始时间
     * @param eTime           结束时间
     */
    @ResponseBody
    @RequestMapping(value = "/findProductLowStock")
    public Map findProductLowStock(HotelProductDto hotelProductDto, HotelProductImpowerDto hotelProductImpowerDto, String sTime, String eTime) {
        Assert.notNull(hotelProductDto.getHid(), "酒店id不能为空");
        Assert.notNull(sTime, "开始时间不能为空");
        Assert.notNull(sTime, "离店时间不能为空");
        SysUserDto sysUserDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        Map map = new LinkedHashMap();

        if (sysUserDto.getUserType() == SysUserType.employee) {
            SysUserDto sysUserMemberDto = sysUserRemoteService.findById(sysUserDto.getMemberId()).getData();
            if (sysUserMemberDto.getUserType() == SysUserType.supplier || sysUserMemberDto.getUserType() == SysUserType.admin) {
                //获取员管理员与员工或者供应商员工的最低库存
                RestResponse<Map<String, HotelProductDto>> mapRestResponse = hotelProductRateRemoteService.getHotelProductRate(getAccessToken(), hotelProductDto.getHid(), sTime, eTime);
                if (!mapRestResponse.success()) {
                    throw new BusinessException(mapRestResponse.getErrorMsg());//BusinessException 业务异常类
                }
                map = mapRestResponse.getData();
            } else {
                RestResponse<Map<String, HotelProductDto>> mapRestResponse = hotelProductImpowerRateRemoteService.getHotelImpowerLowStock(hotelProductImpowerDto, getAccessToken(), sTime, eTime);
                if (!mapRestResponse.success()) {
                    throw new BusinessException(mapRestResponse.getErrorMsg());//BusinessException 业务异常类
                }
                map = mapRestResponse.getData();
            }
        }

        if (sysUserDto.getUserType() == SysUserType.supplier || sysUserDto.getUserType() == SysUserType.admin) {
            //查询出供应商或者管理员酒店下该时间段内所有产品的最低库存
            RestResponse<Map<String, HotelProductDto>> mapRestResponse = hotelProductRateRemoteService.getHotelProductRate(getAccessToken(), hotelProductDto.getHid(), sTime, eTime);
            if (!mapRestResponse.success()) {
                throw new BusinessException(mapRestResponse.getErrorMsg());//BusinessException 业务异常类
            }
            map = mapRestResponse.getData();
        }

        if (sysUserDto.getUserType() == SysUserType.distributor || sysUserDto.getUserType() == SysUserType.distributor2) {
            //查询该酒店时间段内的该产品的最低库存
            RestResponse<Map<String, HotelProductDto>> mapRestResponse = hotelProductImpowerRateRemoteService.getHotelImpowerLowStock(hotelProductImpowerDto, getAccessToken(), sTime, eTime);
            if (!mapRestResponse.success()) {
                throw new BusinessException(mapRestResponse.getErrorMsg());//BusinessException 业务异常类
            }
            map = mapRestResponse.getData();
        }
        return map;
    }

    /**
     * 添加订单
     *
     * @param hotelProductDto
     * @param modelMap        返回数据
     * @param sTime           入住时间
     * @param eTime           离店时间
     * @param stock           最低库存量
     * @return
     */
    @RequestMapping(value = "/add")
    public String addOrder(HotelProductDto hotelProductDto, ModelMap modelMap, String sTime, String eTime,
                           Integer stock, HttpServletRequest httpRequest) {
        Assert.notNull(hotelProductDto.getId(), "产品id不能为空");
        Assert.notNull(hotelProductDto.getHid(), "酒店id不能为空");
        Assert.notNull(sTime, "开始时间不能为空");
        Assert.notNull(eTime, "结束时间不能为空");
        if (stock == 0) {
            throw new RuntimeException("所选日期库存不足，请重新选择！");
        }

        SysUserDto sysUserDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (sysUserDto.getUserType() == SysUserType.admin || sysUserDto.getUserType() == SysUserType.supplier) {
            //查询时间段内该产品每一天的单价
            RestResponse<HotelProductRateDto> hotelProductRateDto = hotelProductRateRemoteService.getRateInTime(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
            //去除离店时间的价格信息
            List<HotelProductRateDto> hotelProductRateDtoList = hotelProductRateDto.getData().getHotelProductRateDtos();
            modelMap.addAttribute("rateDtoList", hotelProductRateDtoList);
            modelMap.addAttribute("rateDto", hotelProductRateDto.getData());
        }

        if (sysUserDto.getUserType() == SysUserType.distributor || sysUserDto.getUserType() == SysUserType.distributor2) {
            RestResponse<HotelProductImpowerRateDto> productImpowerRateDto = hotelProductImpowerRateRemoteService.getRateInTimeAndPid(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
            List<HotelProductImpowerRateDto> hotelProductImpowerRateDtoList = productImpowerRateDto.getData().getHotelProductImpowerRateDtos();
            modelMap.addAttribute("rateDtoList", hotelProductImpowerRateDtoList);
            modelMap.addAttribute("rateDto", productImpowerRateDto.getData());
        }

        if (sysUserDto.getUserType() == SysUserType.employee) {

            SysUserDto sysUserMemberDto = sysUserRemoteService.findById(sysUserDto.getMemberId()).getData();

            if (sysUserMemberDto.getUserType() == SysUserType.supplier || sysUserMemberDto.getUserType() == SysUserType.admin) {
                RestResponse<HotelProductRateDto> hotelProductRateDto = hotelProductRateRemoteService.getRateInTime(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
                List<HotelProductRateDto> hotelProductRateDtoList = hotelProductRateDto.getData().getHotelProductRateDtos();
                modelMap.addAttribute("rateDtoList", hotelProductRateDtoList);
                modelMap.addAttribute("rateDto", hotelProductRateDto.getData());
            } else {
                RestResponse<HotelProductImpowerRateDto> productImpowerRateDto = hotelProductImpowerRateRemoteService.getRateInTimeAndPid(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
                List<HotelProductImpowerRateDto> hotelProductImpowerRateDtoList = productImpowerRateDto.getData().getHotelProductImpowerRateDtos();
                modelMap.addAttribute("rateDtoList", hotelProductImpowerRateDtoList);
                modelMap.addAttribute("rateDto", productImpowerRateDto.getData());
            }
        }

        //根据产品id查询产品信息
        RestResponse<HotelProductDto> response = hotelProductRemoteService.getHotelProduct(getAccessToken(), hotelProductDto.getId());
        //联系人信息
        String contactsStr = response.getData().getContacts();
        JSONArray contactArry = JSONArray.parseArray(contactsStr);
        List<String> contactList = new ArrayList<String>();
        for (Object data : contactArry) {
            contactList.add(data.toString());
        }

        //入住人信息展示 1表示需要入住人信息，2表示不需要入住人信息
        List<String> checkInInfoList = new ArrayList<String>();
        if (response.getData().getCheckIn() == 1) {
            String checkInInfoStr = response.getData().getCheckInInfo();
            JSONArray checkInInfoArry = JSONArray.parseArray(checkInInfoStr);
            for (Object data : checkInInfoArry) {
                checkInInfoList.add(data.toString());
            }
        }

        //入住的天数
        int daysBetween = DateUtil.getDayBetween(DateUtil.parse(sTime), DateUtil.parse(eTime));
        modelMap.addAttribute("days", daysBetween);
        modelMap.addAttribute("stock", stock);
        modelMap.addAttribute("dto", response.getData());
        modelMap.addAttribute("sTime", sTime);
        modelMap.addAttribute("eTime", eTime);
        modelMap.addAttribute("contactList", contactList);
        modelMap.addAttribute("checkInInfoList", checkInInfoList);
        return "/hotel/hotelbooking/add";
    }


    /**
     * 修改时间
     *
     * @param sTime           入住时间
     * @param eTime           离店世家
     * @param hotelProductDto
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/mTime")
    public Map mTime(String sTime, String eTime, HotelProductDto hotelProductDto, HotelProductImpowerDto hotelProductImpowerDto) {
        Assert.notNull(sTime, "入住时间不能为空");
        Assert.notNull(eTime, "离店时间不能为空");
        Assert.notNull(hotelProductDto.getHid(), "酒店id不能为空");
        Assert.notNull(hotelProductDto.getId(), "产品id不能为空");
        //获取该产品的最小库存、总价格
        Integer stock = 0;
        Double total = 0.0;
        String jsonArrayDate = "";
        String jsonArrayDatePrice = "";
        //获取当前登录用户
        SysUserDto sysUserDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        RestResponse<HotelProductRateDto> hotelProductRateDto = new RestResponse<HotelProductRateDto>();
        if (sysUserDto.getUserType() == SysUserType.supplier || sysUserDto.getUserType() == SysUserType.admin) {
            //产品每一天的价格
            hotelProductRateDto = hotelProductRateRemoteService.getRateInTime(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
            stock = hotelProductRateRemoteService.getHotelProductRateByTimeAndPid(getAccessToken(), hotelProductDto, sTime, eTime).getData().getStock();
            total = hotelProductRateDto.getData().getTotal();
            jsonArrayDate = hotelProductRateDto.getData().getJsonArrayDate();
            jsonArrayDatePrice = hotelProductRateDto.getData().getJsonArrayDatePrice();
        }

        RestResponse<HotelProductImpowerRateDto> productImpowerRateDto = new RestResponse<HotelProductImpowerRateDto>();
        if (sysUserDto.getUserType() == SysUserType.distributor || sysUserDto.getUserType() == SysUserType.distributor2) {
            productImpowerRateDto = hotelProductImpowerRateRemoteService.getRateInTimeAndPid(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
            stock = hotelProductImpowerRateRemoteService.getHotelProductImpowerRateByTimePid(getAccessToken(), hotelProductImpowerDto, sTime, eTime).getData().getStock();
            total = productImpowerRateDto.getData().getTotal();
            jsonArrayDate = productImpowerRateDto.getData().getJsonArrayDate();
            jsonArrayDatePrice = productImpowerRateDto.getData().getJsonArrayDatePrice();
        }

        if (sysUserDto.getUserType() == SysUserType.employee) {
            //获取员工所属人
            SysUserDto sysUserMemberDto = sysUserRemoteService.findById(sysUserDto.getMemberId()).getData();
            if (sysUserMemberDto.getUserType() == SysUserType.admin || sysUserMemberDto.getUserType() == SysUserType.supplier) {
                hotelProductRateDto = hotelProductRateRemoteService.getRateInTime(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
                stock = hotelProductRateRemoteService.getHotelProductRateByTimeAndPid(getAccessToken(), hotelProductDto, sTime, eTime).getData().getStock();
                total = hotelProductRateDto.getData().getTotal();
                jsonArrayDate = hotelProductRateDto.getData().getJsonArrayDate();
                jsonArrayDatePrice = hotelProductRateDto.getData().getJsonArrayDatePrice();

            } else {
                productImpowerRateDto = hotelProductImpowerRateRemoteService.getRateInTimeAndPid(getAccessToken(), hotelProductDto.getId(), sTime, eTime);
                stock = hotelProductImpowerRateRemoteService.getHotelProductImpowerRateByTimePid(getAccessToken(), hotelProductImpowerDto, sTime, eTime).getData().getStock();
                total = productImpowerRateDto.getData().getTotal();
                jsonArrayDate = productImpowerRateDto.getData().getJsonArrayDate();
                jsonArrayDatePrice = productImpowerRateDto.getData().getJsonArrayDatePrice();
            }
        }

        if (!hotelProductRateDto.success()) {
            throw new BusinessException(hotelProductRateDto.getErrorMsg());//BusinessException 业务异常类
        }
        if (!productImpowerRateDto.success()) {
            throw new BusinessException(productImpowerRateDto.getErrorMsg());//BusinessException 业务异常类
        }

        //入住的天数
        Integer daysBetween = DateUtil.getDayBetween(DateUtil.parse(sTime), DateUtil.parse(eTime));
        Map mapData = new HashMap();
        mapData.put("total", total);
        mapData.put("stock", stock);
        mapData.put("jsonArrayDate", jsonArrayDate);
        mapData.put("jsonArrayDatePrice", jsonArrayDatePrice);
        mapData.put("daysBetween", daysBetween);
        return mapData;
    }

    /**
     * 获取当日之后该产品库存量大于0的时间
     *
     * @param pId 产品id
     */
    @ResponseBody
    @RequestMapping(value = "/productStock")
    public List<String> productStock(Long pId) {
        RestResponse<List<String>> restResponse = hotelProductRateRemoteService.getProductRateByProductId(getAccessToken(), pId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return restResponse.getData();
    }
    /**
     * 根据产品id获取产品信息和价格信息
     *
     * @param productId
     * @param modelMap
     * @return
     */
   /* @RequestMapping(value = "/getHotelProductAndRateByProductId", method = RequestMethod.GET)
    public String getHotelProductAndRateByProductId(Long productId, ModelMap modelMap) {
        Assert.notNull(productId, "产品id不能为空");
        List<HotelProductDto> list = new ArrayList<>();
        RestResponse<HotelProductDto> restResponseProduct = hotelProductRemoteService.
                getHotelProductById(getAccessToken(), productId);
        list.add(restResponseProduct.getData());
        String roomFacilities = restResponseProduct.getData().getRoomFacilities();
        String service = restResponseProduct.getData().getService();
        List<Object> serviceList = new ArrayList<>();
        if (!org.apache.commons.lang.StringUtils.isEmpty(service)) {
            JSONArray jsonArray = JSONArray.parseArray(service);
            for (Object o : jsonArray) {
                serviceList.add(o);
            }
        }
        List<Object> bianliList = new ArrayList<>();
        List<Object> meitiList = new ArrayList<>();
        List<Object> foodList = new ArrayList<>();
        List<Object> yushiList = new ArrayList<>();
        if (!StringUtils.isEmpty(roomFacilities)) {
            JSONArray jsonObject = JSONArray.parseArray(roomFacilities);
            for (Object object : jsonObject) {
                String bianli = ((JSONObject) object).getString("便利设施");
                String meiti = ((JSONObject) object).getString("媒体科技");
                String food = ((JSONObject) object).getString("食品和饮品");
                String yushi = ((JSONObject) object).getString("浴室");
                if (!org.apache.commons.lang.StringUtils.isEmpty(bianli)) {
                    JSONArray array = JSONArray.parseArray(bianli);
                    for (Object o : array) {
                        bianliList.add(o);
                    }
                }
                if (!org.apache.commons.lang.StringUtils.isEmpty(meiti)) {
                    JSONArray array = JSONArray.parseArray(meiti);
                    for (Object o : array) {
                        meitiList.add(o);
                    }
                }
                if (!org.apache.commons.lang.StringUtils.isEmpty(food)) {
                    JSONArray array = JSONArray.parseArray(food);
                    for (Object o : array) {
                        foodList.add(o);
                    }
                }
                if (!org.apache.commons.lang.StringUtils.isEmpty(yushi)) {
                    JSONArray array = JSONArray.parseArray(yushi);
                    for (Object o : array) {
                        yushiList.add(o);
                    }
                }
            }
        }
        SysUserDto sysUserDto = sysUserRemoteService.getCurrentUser(getAccessToken()).getData();
        if (sysUserDto.getUserType() == SysUserType.group_supplier||sysUserDto.getUserType() == SysUserType.supplier) {
            RestResponse<List<HotelProductRateDto>> restResponseRate = hotelProductRateRemoteService.
                    getRateByProductId(getAccessToken(), productId);
            if (!restResponseRate.success()) {
                throw new BusinessException(restResponseRate.getErrorMsg());
            }
            JSONObject obj = new JSONObject();
            for (HotelProductRateDto hotelProductRateDto : restResponseRate.getData()) {
                JSONObject json = new JSONObject();
                json.put("id", hotelProductRateDto.getProductId());
                json.put("sellPrice", hotelProductRateDto.getPrice());
                json.put("suggestPrice", hotelProductRateDto.getMarketPrice());
                json.put("stock", hotelProductRateDto.getStock());
                json.put("type", "1");
                obj.put(hotelProductRateDto.getDate(), json);
            }

            modelMap.addAttribute("distribution", obj.toString());
        }
        if (sysUserDto.getUserType() == SysUserType.distributor ||
                sysUserDto.getUserType() == SysUserType.distributor2) {
            //先根据产品id和分销商id查询授权信息
            RestResponse<HotelProductImpowerDto> restResponse = hotelProductImpowerRemoteService.
                    getProductImpowerByUserIdAndProductId(getAccessToken(), sysUserDto.getId(), productId);
            RestResponse<List<HotelProductImpowerRateDto>> restResponseRate = hotelProductImpowerRateRemoteService.
                    getRateByProductId(getAccessToken(), restResponse.getData().getId());
            if (!restResponseRate.success()) {
                throw new BusinessException(restResponseRate.getErrorMsg());
            }
            JSONObject obj = new JSONObject();
            for (HotelProductImpowerRateDto hotelProductImpowerRateDto : restResponseRate.getData()) {
                JSONObject json = new JSONObject();
                json.put("id", hotelProductImpowerRateDto.getId());
                json.put("sellPrice", hotelProductImpowerRateDto.getSettlementPrice());
                json.put("suggestPrice", hotelProductImpowerRateDto.getAdvisePrice());
                json.put("stock", hotelProductImpowerRateDto.getStock());
                json.put("type", "2");
                obj.put(hotelProductImpowerRateDto.getDate(), json);
            }
            modelMap.addAttribute("distribution", obj.toString());
        }
        modelMap.addAttribute("serviceList", serviceList);
        modelMap.addAttribute("dto", restResponseProduct.getData());
        modelMap.addAttribute("bianliList", bianliList);
        modelMap.addAttribute("meitiList", meitiList);
        modelMap.addAttribute("foodList", foodList);
        modelMap.addAttribute("yushiList", yushiList);

        return "/hotel/hotelBooking/info";
    }*/
}
