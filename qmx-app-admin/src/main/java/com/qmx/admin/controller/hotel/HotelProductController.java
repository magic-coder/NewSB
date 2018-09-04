package com.qmx.admin.controller.hotel;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.hotel.HotelInfoRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelProductRateRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelProductRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelRoomTypeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.hotel.api.dto.HotelInfoDto;
import com.qmx.hotel.api.dto.HotelProductDto;
import com.qmx.hotel.api.dto.HotelProductRateDto;
import com.qmx.hotel.api.dto.HotelRoomTypeDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created by earnest on 2017/10/13 0013.
 */
@Controller
@RequestMapping("/hotelProduct")
public class HotelProductController extends BaseController {
    @Autowired
    private HotelProductRemoteService hotelProductRemoteService;
    @Autowired
    private HotelRoomTypeRemoteService hotelRoomTypeRemoteService;
    @Autowired
    private HotelProductRateRemoteService hotelProductRateRemoteService;
    @Autowired
    private HotelInfoRemoteService hotelInfoRemoteService;

    /**
     * 酒店产品列表
     *
     * @param model
     * @param dto
     * @return
     */
    @RequestMapping(value = "/getList")
    public String getList(ModelMap model, HotelProductDto dto) {
        RestResponse<PageDto<HotelProductDto>> restResponse = hotelProductRemoteService.findAll(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());//BusinessException 业务异常类
        }
        Map<String, String> hidMap = new HashMap<>();
        //获取酒店信息，用于条件查询
        for (HotelProductDto hotelProductDto : restResponse.getData().getRecords()) {
            hidMap.put(String.valueOf(hotelProductDto.getHid()), hotelInfoRemoteService.getHotelInfoById(getAccessToken(), hotelProductDto.getHid()).getData().getName());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        model.addAttribute("hidMap", hidMap);
        return "/hotel/hotelproduct/getlist";
    }

    /**
     * 添加酒店产品跳转页面
     *
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap model, HotelRoomTypeDto dto) {
        //查询所有的酒店
        RestResponse<List<HotelInfoDto>> restResponse = hotelInfoRemoteService.findAll(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("data", roomFacilitiesAndServer());
        model.addAttribute("hid", dto.getHid());
        model.addAttribute("startTime", getStartTime());
        model.addAttribute("endTime", getEndTime());
        model.addAttribute("hotel", restResponse.getData());
        return "/hotel/hotelproduct/add";
    }


    /**
     * 添加酒店产品
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(HotelProductDto dto, HttpServletRequest request) {
        /*Assert.notNull(dto, "产品信息不能为空");
        Assert.notNull(dto.getRid(), "酒店房型id不能为空");
        String service = request.getParameter("pro_value");
        String roomFacilities = request.getParameter("pro_value1");
        String contacts = request.getParameter("pro_value2");
        String checkInInfo = request.getParameter("pro_value3");
        dto.setService(service);
        dto.setRoomFacilities(roomFacilities);
        dto.setContacts(contacts);
        dto.setCheckInInfo(checkInInfo);
        RestResponse<HotelProductDto> restResponse = hotelProductRemoteService.createHotelProduct(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());//BusinessException 业务异常类
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("id", String.valueOf(restResponse.getData().getId()));
        return jsonObject;*/
        String datePriceData = request.getParameter("datePriceData");
        JSONObject object = new JSONObject();
        //获取便利设施
        String[] amenities = request.getParameterValues("amenities");
        if (amenities != null && amenities.length > 0) {
            object.put("便利设施", amenities);
        }
        //获取媒体科技
        String[] media = request.getParameterValues("media");
        if (media != null && media.length > 0) {
            object.put("媒体科技", media);
        }
        //获取食品和饮品
        String[] foods = request.getParameterValues("foods");
        if (foods != null && foods.length > 0) {
            object.put("食品和饮品", foods);
        }
        //获取浴室
        String[] shower = request.getParameterValues("shower");
        if (shower != null && shower.length > 0) {
            object.put("浴室", shower);
        }
        dto.setRoomFacilities(object.toJSONString());
        RestResponse<HotelProductDto> restResponse = hotelProductRemoteService.createHotelProduct(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());//BusinessException 业务异常类
        }
        getDatePriceData(datePriceData, restResponse.getData());
        return "redirect:getList";
    }

    /**
     * 根据产品id查询产品信息
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        Assert.notNull(id, "产品id不能为空");
        RestResponse<HotelProductDto> restResponse = hotelProductRemoteService.getHotelProductById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        model.addAttribute("dto", restResponse.getData());
        model.addAttribute("data", roomFacilitiesAndServer());
        model.addAttribute("distribution", editAllRate(id));
        model.addAttribute("startTime", getStartTime());
        model.addAttribute("endTime", getEndTime());
        return "/hotel/hotelproduct/edit";
    }

    /**
     * 根据产品id更新产品信息
     *
     * @param hotelProductDto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(HotelProductDto hotelProductDto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        Assert.notNull(hotelProductDto, "产品信息不能为空");
        /*String service = request.getParameter("pro_value");
        String roomFacilities = request.getParameter("pro_value1");
        String contacts = request.getParameter("pro_value2");
        String checkInInfo = request.getParameter("pro_value3");*/
        String datePriceData = request.getParameter("datePriceData");
        /*hotelProductDto.setService(service);
        hotelProductDto.setRoomFacilities(roomFacilities);
        hotelProductDto.setContacts(contacts);
        hotelProductDto.setCheckInInfo(checkInInfo);*/
        JSONObject object = new JSONObject();
        //获取便利设施
        String[] amenities = request.getParameterValues("amenities");
        if (amenities != null && amenities.length > 0) {
            object.put("便利设施", amenities);
        }
        //获取媒体科技
        String[] media = request.getParameterValues("media");
        if (media != null && media.length > 0) {
            object.put("媒体科技", media);
        }
        //获取食品和饮品
        String[] foods = request.getParameterValues("foods");
        if (foods != null && foods.length > 0) {
            object.put("食品和饮品", foods);
        }
        //获取浴室
        String[] shower = request.getParameterValues("shower");
        if (shower != null && shower.length > 0) {
            object.put("浴室", shower);
        }
        hotelProductDto.setRoomFacilities(object.toJSONString());
        RestResponse<HotelProductDto> restResponse = hotelProductRemoteService.updateHotelProduct(getAccessToken(), hotelProductDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        updateAllRate(datePriceData, hotelProductDto.getId(), hotelProductDto.getRid());
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        return "redirect:getList";
    }

    /**
     * 根据产品id删除产品
     *
     * @param id
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long id, Long hid, RedirectAttributes redirectAttributes) {
        Assert.notNull(id, "产品id不能为空");
        RestResponse<Boolean> restResponse = hotelProductRemoteService.deleteHotelProduct(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "删除成功");
        return "redirect:getList";
    }


    /**
     * 获取日历上传的数据
     *
     * @param datePriceData
     * @param productDto
     * @return
     */
    //@RequestMapping(value = "/getDatePriceData")
    public void getDatePriceData(String datePriceData, HotelProductDto productDto) {
        /*String datePriceData = request.getParameter("datePriceData");
        String productId = request.getParameter("productId");
        String roomId = request.getParameter("roomId");*/
        datePriceData = HtmlUtils.htmlUnescape(datePriceData);
        List<HotelProductRateDto> list = new ArrayList<>();
        if (StringUtils.isNotEmpty(datePriceData)) {
            JSONObject obj = JSONObject.parseObject(datePriceData);
            if (!obj.isEmpty()) {
                for (Object key : obj.keySet()) {
                    String date = key.toString();
                    if (StringUtils.isEmpty(date)) {
                        continue;
                    }
                    if (!DateUtil.isValidDate(date)) {
                        continue;
                    }
                    JSONObject json = obj.getJSONObject(key.toString());
                    HotelProductRateDto dto = new HotelProductRateDto();
                    dto.setProductId(productDto.getId());
                    dto.setDate(date);
                    //通过日期来查询是否设置了房型库存
                    RestResponse<Integer> restResponse = hotelProductRemoteService.getRoomStockByDateAndRoomId(getAccessToken(), productDto.getRid(), date, date);
                    if (!restResponse.success()) {
                        throw new BusinessException(restResponse.getErrorMsg());
                    }

                    dto.setPrice(new Double(json.getString("sellPrice")));
                    dto.setMarketPrice(new Double(json.getString("suggestPrice")));
                    if (restResponse.getData() == null) {
                        dto.setStock(0);
                    } else {
                        dto.setStock(new Integer(json.getString("stock")));
                        list.add(dto);
                    }
                }
            }
        }
        //循环list，执行添加操作
        for (HotelProductRateDto dto : list) {
            RestResponse restResponse = hotelProductRateRemoteService.saveProductRate(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        }
    }


    /**
     * 编辑产品价格页面
     *
     * @param rateId
     * @return
     */
    public String editAllRate(Long rateId) {
        Assert.notNull(rateId, "产品id不能空");
        RestResponse<List<HotelProductRateDto>> restResponse = hotelProductRateRemoteService.getRateByProductId(getAccessToken(), rateId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONObject obj = new JSONObject();
        for (HotelProductRateDto hotelProductRateDto : restResponse.getData()) {
            JSONObject json = new JSONObject();
            json.put("id", hotelProductRateDto.getId() + "");
            json.put("sellPrice", hotelProductRateDto.getPrice());
            json.put("suggestPrice", hotelProductRateDto.getMarketPrice());
            json.put("stock", hotelProductRateDto.getStock());
            obj.put(hotelProductRateDto.getDate(), json);
        }
        return obj.toString();
    }

    /**
     * 批量修改价格信息
     *
     * @param datePriceData
     * @param productId
     * @param roomId
     */
    public void updateAllRate(String datePriceData, Long productId, Long roomId) {
        datePriceData = HtmlUtils.htmlUnescape(datePriceData);
        List<HotelProductRateDto> list = new ArrayList<>();
        List<String> dateList = new ArrayList<>();
        if (StringUtils.isNotEmpty(datePriceData)) {
            JSONObject obj = JSONObject.parseObject(datePriceData);
            if (!obj.isEmpty()) {
                for (Object key : obj.keySet()) {
                    String date = key.toString();
                    if (!DateUtil.isValidDate(date)) {
                        continue;
                    }
                    JSONObject json = obj.getJSONObject(key.toString());
                    HotelProductRateDto dto = new HotelProductRateDto();
                    if (!StringUtils.isEmpty(json.getString("id"))) {
                        dto.setId(new Long(json.getString("id")));
                    }
                    dto.setProductId(productId);
                    dto.setDate(date);
                    //通过日期来查询是否设置了房型库存
                    RestResponse<Integer> restResponse = hotelProductRemoteService.getRoomStockByDateAndRoomId(getAccessToken(), roomId, date, date);
                    if (!restResponse.success()) {
                        throw new BusinessException(restResponse.getErrorMsg());
                    }

                    dto.setPrice(new Double(json.getString("sellPrice")));
                    dto.setMarketPrice(new Double(json.getString("suggestPrice")));
                    dto.setEnable(true);
                    if (restResponse.getData() == null) {
                        dto.setStock(0);
                    } else {
                        dto.setStock(new Integer(json.getString("stock")));
                        list.add(dto);
                        dateList.add(dto.getDate());
                    }
                }
            }
        }
        //查询该产品已存在的价格信息
        RestResponse<List<HotelProductRateDto>> restResponse = hotelProductRateRemoteService.getRateByProductId(getAccessToken(), productId);
        Map<String, Long> existMap = new LinkedHashMap<>();
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        for (HotelProductRateDto dto : restResponse.getData()) {
            existMap.put(dto.getDate(), dto.getId());
        }
        for (HotelProductRateDto dto : list) {
            if (existMap.keySet().contains(dto.getDate())) {
                dto.setId(existMap.get(dto.getDate()));
                hotelProductRateRemoteService.updateProductRate(getAccessToken(), dto);
                existMap.remove(dto.getDate());
            } else {
                hotelProductRateRemoteService.saveProductRate(getAccessToken(), dto);
            }
        }
        //如果map不为空，则删除存在的日期价格
        if (!existMap.isEmpty()) {
            for (String s : existMap.keySet()) {
                hotelProductRateRemoteService.deleteHotelProductRateById(getAccessToken(), existMap.get(s));
            }
        }
    }

    /**
     * 根据ajax批量删除酒店产品信息
     *
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/deleteAll")
    public JSONObject deleteAll(String ids) {
        JSONObject jsonObject = new JSONObject();
        try {
            String[] id = ids.split(",");
            for (String s : id) {
                hotelProductRemoteService.deleteHotelProduct(getAccessToken(), Long.parseLong(s));
                jsonObject.put("data", "1");
            }
        } catch (Exception e) {
            jsonObject.put("data", "2");
            e.printStackTrace();
        }
        return jsonObject;
    }


    /**
     * 根据房型id和日段获取房型库存
     *
     * @param roomId
     * @param startTime
     * @param endTime
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getStock")
    public JSONObject getStock(Long roomId, String startTime, String endTime) {
        RestResponse<Integer> restResponse = hotelProductRemoteService.getRoomStockByDateAndRoomId(getAccessToken(), roomId, startTime, endTime);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("stock", restResponse.getData());
        return jsonObject;
    }

    /**
     * 设置房间设施和服务
     *
     * @return
     */
    public Map<String, List<String>> roomFacilitiesAndServer() {
        List<String> amenitiesList = Arrays.asList("雨伞", "多种规格电源插座", "110V电压插座", "空调", "书桌", "熨衣设备", "房内保险箱", "电风扇", "沙发",
                "衣柜/衣橱", "220V电压插座", "坐卧两用长沙发", "电子秤", "开夜床", "闹钟", "针线包", "单一规格电源插座", "遮光窗帘", "手动窗帘");
        List<String> mediaList = Arrays.asList("国内长途电话", "国际长途电话", "有线频道", "液晶电视机", "卫星频道", "电视机", "电话");
        List<String> foodsList = Arrays.asList("电热水壶", "咖啡壶/茶壶", "免费瓶装水", "小冰箱", "迷你吧", "咖啡机");
        List<String> showerList = Arrays.asList("24小时热水", "拖鞋", "浴室化妆放大镜", "浴衣", "浴缸", "独立淋浴间", "吹风机", "免费洗漱用品(6样以上)", "淋浴", "洗浴间电话", "浴室", "公用吹风机");
        List<String> serversList = Arrays.asList("连通房", "行政酒廊", "唤醒服务", "欢迎礼品", "免费报纸");
        Map<String, List<String>> map = new HashMap<>();
        map.put("amenitiesList", amenitiesList);
        map.put("mediaList", mediaList);
        map.put("foodsList", foodsList);
        map.put("showerList", showerList);
        map.put("serversList", serversList);
        return map;
    }

    /**
     * 获取开始时间段
     *
     * @return
     */
    public List<String> getStartTime() {
        List<String> startTimeList = Arrays.asList("00:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00",
                "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00");
        return startTimeList;
    }

    /**
     * 获取结束时间段
     *
     * @return
     */
    public List<String> getEndTime() {
        List<String> endTimeList = Arrays.asList("1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00",
                "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "00:00");
        return endTimeList;
    }

    /**
     * 根据酒店id查询所有房型
     *
     * @param hid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/findAllRoom")
    public JSONObject getRoomByHid(Long hid) {
        Assert.notNull(hid, "酒店id不能为空");
        RestResponse<List<HotelRoomTypeDto>> restResponse = hotelRoomTypeRemoteService.getRoomByHid(getAccessToken(), hid);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        Map<String, Object> map = new LinkedHashMap<>();
        for (HotelRoomTypeDto hotelRoomTypeDto : restResponse.getData()) {
            map.put(String.valueOf(hotelRoomTypeDto.getId()), hotelRoomTypeDto.getName());
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("data", map);
        return jsonObject;
    }

    /**
     * 查看产品详情信息
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/disPlay")
    public String disPlay(Long id, ModelMap modelMap) {
        Assert.notNull(id, "产品id不能为空");
        RestResponse<HotelProductDto> restResponse = hotelProductRemoteService.getHotelProductById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", restResponse.getData());
        modelMap.addAttribute("data", roomFacilitiesAndServer());
        modelMap.addAttribute("distribution", editAllRate(id));
        modelMap.addAttribute("startTime", getStartTime());
        modelMap.addAttribute("endTime", getEndTime());
        return "/hotel/hotelproduct/display";
    }
}
