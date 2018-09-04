package com.qmx.admin.controller.hotel;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.hotel.HotelInfoRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelRoomTypeRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.hotel.api.dto.HotelInfoDto;
import com.qmx.hotel.api.dto.HotelRoomOccupyDto;
import com.qmx.hotel.api.dto.HotelRoomStockDto;
import com.qmx.hotel.api.dto.HotelRoomTypeDto;
import com.qmx.hotel.api.enumerate.RoomOccupyTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by earnest on 2017/10/13 0013.
 */
@Controller
@RequestMapping("/hotelRoomType")
public class HotelRoomTypeController extends BaseController {
    @Autowired
    private HotelRoomTypeRemoteService hotelRoomTypeRemoteService;
    @Autowired
    private HotelInfoRemoteService hotelInfoRemoteService;

    /**
     * 根据酒店id查询酒店的所有房型
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/getList")
    public String getList(ModelMap modelMap, HotelRoomTypeDto dto) {
        Assert.notNull(dto.getHid(), "酒店id不能为空");
        RestResponse<PageDto<HotelRoomTypeDto>> restResponse = hotelRoomTypeRemoteService.getHotelRoomByHid(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/hotel/hotelroomtype/getlist";
    }

    /**
     * 添加酒店房型跳转页面
     *
     * @param modelMap
     * @param hid
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(ModelMap modelMap, Long hid) {
        modelMap.addAttribute("hid", hid);
        return "/hotel/hotelroomtype/add";
    }

    /**
     * 根据酒店id添加酒店房型
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(RedirectAttributes redirectAttributes, HotelRoomTypeDto dto, HttpServletRequest request) {
        Assert.notNull(dto.getName(), "房型名称不能为空");
        Assert.notNull(dto.getHid(), "酒店id不能为空");
        String datePriceData = request.getParameter("datePriceData");
        RestResponse<HotelRoomTypeDto> restResponse = hotelRoomTypeRemoteService.saveHotelRoom(getAccessToken(), dto, datePriceData);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:getList?hid=" + dto.getHid();
    }

    /**
     * 根据房型id查询具体的房型信息
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/edit")
    public String edit(ModelMap modelMap, Long id) {
        Assert.notNull(id, "id不能为空");
        RestResponse<HotelRoomTypeDto> restResponse = hotelRoomTypeRemoteService.getHotelRoomById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<HotelRoomStockDto>> response = hotelRoomTypeRemoteService.getHotelRoomStockById(getAccessToken(), id);
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        JSONObject obj = new JSONObject();
        for (HotelRoomStockDto hotelRoomStockDto : response.getData()) {
            JSONObject json = new JSONObject();
            json.put("stock", hotelRoomStockDto.getStock());
            obj.put(hotelRoomStockDto.getDate(), json);
        }
        modelMap.addAttribute("distribution", obj.toString());
        modelMap.addAttribute("dto", restResponse.getData());
        return "/hotel/hotelroomtype/edit";
    }

    /**
     * 更新房型信息
     *
     * @param dto
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(RedirectAttributes redirectAttributes, HotelRoomTypeDto dto, HttpServletRequest request) {
        Assert.notNull(dto, "房型信息不能为空");
        String datePriceData = request.getParameter("datePriceData");
        RestResponse<HotelRoomTypeDto> restResponse = hotelRoomTypeRemoteService.updateHotelRoom(getAccessToken(), dto, datePriceData);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        return "redirect:getList?hid=" + dto.getHid();
    }

    /**
     * 根据房型id删除该房型
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(RedirectAttributes redirectAttributes, Long id, Long hid) {
        Assert.notNull(id, "id不能为空");
        RestResponse<Boolean> restResponse = hotelRoomTypeRemoteService.deleteHotelRoom(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "删除成功");
        return "redirect:getList?hid=" + hid;
    }

    /**
     * 根据ajax批量删除房型信息
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
                System.err.println(s);
                hotelRoomTypeRemoteService.deleteHotelRoom(getAccessToken(), Long.parseLong(s));
                jsonObject.put("data", "1");
            }
        } catch (Exception e) {
            jsonObject.put("data", "2");
        }
        return jsonObject;
    }

    /**
     * 查询所有的酒店名称
     *
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/findAllHotel")
    public String findAllHotel(ModelMap modelMap) {
        RestResponse<List<HotelInfoDto>> restResponse = hotelInfoRemoteService.findAll(getAccessToken());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", restResponse.getData());
        return "/hotel/hotelroomtype/choose";
    }

    /**
     * 跳转房型占用页面
     *
     * @param rid
     * @param name
     * @param hid
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/addOccupy")
    public String addOccupy(Long rid, String name, Long hid, ModelMap modelMap) {
        RestResponse<List<HotelRoomOccupyDto>> restResponse = hotelRoomTypeRemoteService.getHotelRoomOccupyByRid(getAccessToken(), rid);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        if (!restResponse.getData().isEmpty()) {
            JSONObject obj = new JSONObject();
            for (HotelRoomOccupyDto hotelRoomOccupyDto : restResponse.getData()) {
                JSONObject json = new JSONObject();
                json.put("id", String.valueOf(hotelRoomOccupyDto.getId()));
                json.put("stock", hotelRoomOccupyDto.getStock());
                json.put("sellPrice", hotelRoomOccupyDto.getOccupyType().getType());
                obj.put(hotelRoomOccupyDto.getDate(), json);
            }
            modelMap.addAttribute("distribution", obj.toString());
        }
        modelMap.addAttribute("name", name);
        modelMap.addAttribute("rid", rid);
        modelMap.addAttribute("hid", hid);
        modelMap.addAttribute("data", RoomOccupyTypeEnum.values());
        return "/hotel/hotelroomtype/addoccupy";
    }


    /**
     * 保存或更新占用信息
     *
     * @param rid
     * @param request
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/saveOrUpdateOccupy")
    public String saveOrUpdateOccupy(Long rid, Long hid, String occupyType, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        String datePriceData = request.getParameter("datePriceData");
        RestResponse restResponse = hotelRoomTypeRemoteService.saveOrUpdateHotelOccupy(getAccessToken(), rid, datePriceData);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "操作成功");
        return "redirect:getList?hid=" + hid;
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
        RestResponse<Integer> restResponse = hotelRoomTypeRemoteService.getRoomStockByDateAndRoomId(getAccessToken(), roomId, startTime, endTime);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("stock", restResponse.getData());
        return jsonObject;
    }

    /**
     * 查询房型详情信息
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/disPlay")
    public String disPlay(Long id, ModelMap modelMap) {
        Assert.notNull(id, "房型id不能为空");
        RestResponse<HotelRoomTypeDto> restResponse = hotelRoomTypeRemoteService.getHotelRoomById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        RestResponse<List<HotelRoomStockDto>> response = hotelRoomTypeRemoteService.getHotelRoomStockById(getAccessToken(), id);
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        JSONObject obj = new JSONObject();
        for (HotelRoomStockDto hotelRoomStockDto : response.getData()) {
            JSONObject json = new JSONObject();
            json.put("stock", hotelRoomStockDto.getStock());
            obj.put(hotelRoomStockDto.getDate(), json);
        }
        modelMap.addAttribute("distribution", obj.toString());
        modelMap.addAttribute("dto", restResponse.getData());
        return "/hotel/hotelroomtype/display";
    }
}
