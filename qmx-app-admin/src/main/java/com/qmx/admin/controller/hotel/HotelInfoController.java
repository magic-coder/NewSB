package com.qmx.admin.controller.hotel;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelImageRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelInfoRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.hotel.api.dto.HotelImageDto;
import com.qmx.hotel.api.dto.HotelInfoDto;
import com.qmx.hotel.api.dto.HotelRoomStockDto;
import com.qmx.hotel.api.dto.HotelRoomTypeDto;
import com.qmx.hotel.api.enumerate.ImageAttributeEnum;
import com.qmx.hotel.api.enumerate.ImageTypeEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/hotelInfo")
public class HotelInfoController extends BaseController {
    @Autowired
    private HotelInfoRemoteService hotelInfoRemoteService;
    @Autowired
    private HotelImageRemoteService hotelImageRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;


    @RequestMapping(value = "/list")
    public String list(HotelInfoDto dto, ModelMap model) {
        RestResponse<PageDto<HotelInfoDto>> restResponse = hotelInfoRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<HotelInfoDto> list = restResponse.getData().getRecords();
        model.addAttribute("dto", dto);
        model.addAttribute("page", restResponse.getData());
        return "/hotel/hotelinfo/list";
    }

    @RequestMapping(value = "/add")
    public String add(ModelMap modelMap) {
       /* List<SysDictDTO> facilitiesList = sysDictRemoteService.findListByType("facilities").getData();
        List<SysDictDTO> serviceList = sysDictRemoteService.findListByType("service").getData();*/
        List<String> facilitiesList = Arrays.asList("西式餐厅", "中式餐厅", "残疾人设施", "室外游泳池", "室内游泳池", "会议室"
                , "健身房", "SPA", "无烟房", "商务中心", "酒吧", "桑拿", "棋牌室", "无烟房", "免费停车场");
        List<String> serviceList = Arrays.asList("早餐服务", "接站服务", "接机服务", "接待外宾", "洗衣服务", "行李寄存"
                , "看护小孩服务", "租车", "携带宠物", "叫醒服务");

        modelMap.addAttribute("attributes", ImageAttributeEnum.values());
        modelMap.addAttribute("types", ImageTypeEnum.values());
        modelMap.addAttribute("facilitiesList", facilitiesList);
        modelMap.addAttribute("serviceList", serviceList);
        return "/hotel/hotelinfo/add";
    }

    @RequestMapping(value = "/edit")
    public String edit(Long id, ModelMap model) {
        Assert.notNull(id, "id不能为空");
        List<String> facilitiesList = Arrays.asList("西式餐厅", "中式餐厅", "残疾人设施", "室外游泳池", "室内游泳池", "会议室"
                , "健身房", "SPA", "无烟房", "商务中心", "酒吧", "桑拿", "棋牌室", "无烟房", "免费停车场");
        List<String> serviceList = Arrays.asList("早餐服务", "接站服务", "接机服务", "接待外宾", "洗衣服务", "行李寄存"
                , "看护小孩服务", "租车", "携带宠物", "叫醒服务");
        RestResponse<HotelInfoDto> dto = hotelInfoRemoteService.getHotelInfoById(getAccessToken(), id);

        if (!dto.success()) {
            throw new BusinessException(dto.getErrorMsg());
        }
        model.addAttribute("dto", dto.getData());
        model.addAttribute("facilitiesList", facilitiesList);
        model.addAttribute("serviceList", serviceList);
        return "/hotel/hotelinfo/edit";
    }

    /**
     * 保存酒店信息
     *
     * @param hotelInfoDto
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(HotelInfoDto hotelInfoDto, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        Assert.notNull(hotelInfoDto, "用户信息不能为空");
        Assert.hasLength(hotelInfoDto.getName(), "酒店名称不能为空");
        //获取图片集合
        List<HotelImageDto> images = HotelImageDto.toEntitys(request);
        hotelInfoDto.setImages(images);
        //获取房型集合
        List<HotelRoomTypeDto> rooms = toEntitys(request);
        hotelInfoDto.setRoomTypes(rooms);

        RestResponse<HotelInfoDto> restResponse = hotelInfoRemoteService.createHotelInfo(getAccessToken(), hotelInfoDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:list";
    }

    /**
     * @param request
     * @return
     */
    public static List<HotelRoomTypeDto> toEntitys(HttpServletRequest request) {
        List<HotelRoomTypeDto> list = new ArrayList();
        //获取房型的数据
        String[] roomTypes = request.getParameterValues("roomTypeData");
        //获取房型相应的库存数据
        String[] roomStocks = request.getParameterValues("roomTypeStock");
        if (roomTypes.length > 0) {
            for (int i = 1; i < roomTypes.length; i++) {
                if (roomTypes[i] != "") {
                    HotelRoomTypeDto hotelRoomTypeDto = new HotelRoomTypeDto();
                    JSONObject jsStr = JSONObject.parseObject(roomTypes[i]);
                    List<HotelRoomStockDto> stockList = new ArrayList<>();
                    if (roomStocks.length > 0) {
                        JSONObject stockStr = JSONObject.parseObject(roomStocks[i]);
                        for (Object key : stockStr.keySet()) {
                            String date = key.toString();
                            JSONObject json = stockStr.getJSONObject(key.toString());
                            HotelRoomStockDto dto = new HotelRoomStockDto();
                            dto.setDate(date);
                            dto.setStock(new Integer(json.getString("stock")));
                            stockList.add(dto);
                        }
                    }
                    hotelRoomTypeDto.setName(jsStr.getString("roomName"));
                    hotelRoomTypeDto.setFloor(jsStr.getString("floor"));
                    hotelRoomTypeDto.setWindowType(Integer.parseInt(jsStr.getString("windowType")));
                    hotelRoomTypeDto.setBedType(jsStr.getString("bedType"));
                    hotelRoomTypeDto.setBedSize(jsStr.getString("bedSize"));
                    hotelRoomTypeDto.setArea(jsStr.getString("area"));
                    hotelRoomTypeDto.setMaxOccupancy(Integer.parseInt(jsStr.getString("maxOccupancy")));
                    hotelRoomTypeDto.setRoomStocks(stockList);
                    list.add(hotelRoomTypeDto);
                }

            }
        }
        return list;
    }

    @RequestMapping(value = "/update")
    public String update(HotelInfoDto hotelInfoDto, RedirectAttributes redirectAttributes) {
        Assert.notNull(hotelInfoDto, "用户信息不能为空");
        RestResponse<HotelInfoDto> restResponse = hotelInfoRemoteService.updateHotelInfo(getAccessToken(), hotelInfoDto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(Long id, RedirectAttributes redirectAttributes) {
        Assert.notNull(id, "用户id不能为空");
        RestResponse<Boolean> restResponse = hotelInfoRemoteService.deleteHotelInfo(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "删除成功");
        return "redirect:list";
    }

    /**
     * 根据酒店id查询该酒店所有图片
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/imgList")
    public String imgList(HotelImageDto dto, ModelMap modelMap, HttpServletRequest request) {
        Assert.notNull(dto.getHid(), "酒店id不能为空");
        String s = request.getParameter("attribute");
        if (!StringUtils.isEmpty(s)) {
            dto.setAttribute(ImageAttributeEnum.valueOf(s));
        }
        RestResponse<PageDto<HotelImageDto>> restResponse = hotelImageRemoteService.getHotelImageByHid(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        modelMap.addAttribute("attribute", ImageAttributeEnum.values());
        modelMap.addAttribute("type", ImageTypeEnum.values());
        return "/hotel/hotelinfo/imglist";
    }

    /**
     * 根据图片id查询图片信息
     *
     * @param imgId
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/editImg")
    public String editImg(Long imgId, ModelMap modelMap) {
        Assert.notNull(imgId, "图片id不能为空");
        RestResponse<Map<String, Object>> restResponse = hotelImageRemoteService.getHotelImageById(getAccessToken(), imgId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", restResponse.getData());
        modelMap.addAttribute("attribute", ImageAttributeEnum.values());
        modelMap.addAttribute("type", ImageTypeEnum.values());
        return "/hotel/hotelinfo/editimg";
    }

    /**
     * 根据图片id更新图片信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/updateImg")
    public String updateImg(HotelImageDto dto, RedirectAttributes redirectAttributes) {
        Assert.notNull(dto, "更新信息不能为空");
        Assert.notNull(dto.getId(), "图片id不能为空");
        RestResponse<HotelImageDto> restResponse = hotelImageRemoteService.updateHotelImage(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "更新成功");
        return "redirect:imgList?hid=" + dto.getHid();
    }

    /**
     * 添加图片跳转页面
     *
     * @param hid 酒店id
     * @return
     */
    @RequestMapping(value = "/addImg")
    public String addImg(Long hid, ModelMap modelMap) {
        modelMap.addAttribute("hid", hid);
        modelMap.addAttribute("attribute", ImageAttributeEnum.values());
        modelMap.addAttribute("type", ImageTypeEnum.values());
        return "/hotel/hotelinfo/addimg";
    }

    /**
     * 保存图片信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/saveImg")
    public String saveImg(/*@RequestParam("file") MultipartFile file,*/ HttpServletRequest request,
                          HotelImageDto dto, RedirectAttributes redirectAttributes) {
        Assert.notNull(dto, "图片信息不能为空");
        Assert.notNull(dto.getHid(), "酒店id不能为空");
        String str = request.getParameter("imgString");
        String hid = request.getParameter("hid");
        str = HtmlUtils.htmlUnescape(str);
        String[] strs = str.split(",");
        RestResponse restResponse = new RestResponse();
        for (String s : strs) {
            String[] strings = s.substring(0, s.length() - 1).replaceAll("-", ",").split(",");
            dto.setHid(Long.parseLong(hid));
            dto.setType(ImageTypeEnum.valueOf(strings[0]));
            dto.setAttribute(/*strings[1]*/ImageAttributeEnum.valueOf(strings[1]));

            dto.setUrl(strings[3]);
            restResponse = hotelImageRemoteService.addHotelImage(getAccessToken(), dto);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:list";
    }

    /**
     * @param request
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/saveAllImg")
    public String saveAllImg(HttpServletRequest request, HotelImageDto dto, RedirectAttributes redirectAttributes) {
        saveImg(request, dto, redirectAttributes);
        return "redirect:imgList?hid=" + dto.getHid();
    }

    /**
     * 根据图片id删除图片信息
     *
     * @param imgId              图片id
     * @param hid                酒店id
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/deleteImg")
    public String deleteImg(Long imgId, Long hid, RedirectAttributes redirectAttributes) {
        Assert.notNull(imgId, "图片id不能为空");
        RestResponse restResponse = hotelImageRemoteService.deleteHotelImage(getAccessToken(), imgId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "删除成功");
        return "redirect:imgList?hid=" + hid;
    }

    /**
     * 根据ajax批量删除酒店基础信息
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
                hotelInfoRemoteService.deleteHotelInfo(getAccessToken(), Long.parseLong(s));
                jsonObject.put("data", "1");
            }
        } catch (Exception e) {
            jsonObject.put("data", "2");
            e.printStackTrace();
        }
        return jsonObject;
    }

    /**
     * 根据ajax批量删除酒店图片信息
     *
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/deleteImgAll")
    public JSONObject deleteImgAll(String ids) {
        JSONObject jsonObject = new JSONObject();
        try {
            String[] id = ids.split(",");
            for (String s : id) {
                hotelImageRemoteService.deleteHotelImage(getAccessToken(), Long.parseLong(s));
                jsonObject.put("data", "1");
            }
        } catch (Exception e) {
            jsonObject.put("data", "2");
            e.printStackTrace();
        }
        return jsonObject;
    }

    /**
     * 获取普通供应商
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getSupplierByAdmin")
    public Object getSupplierByAdmin(Integer page, String q) {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        UserQueryVo userQueryVo = new UserQueryVo();
        userQueryVo.setUserType(SysUserType.supplier);
        userQueryVo.setSupplierFlag(Boolean.FALSE);
        userQueryVo.setPageIndex(page);
        userQueryVo.setUsername(q);
        //userQueryVo.setGroupSupplierId(941911937119309826L);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        for (SysUserDto sysUserDto : restResponse.getData().getRecords()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", String.valueOf(sysUserDto.getId()));
            map.put("account", sysUserDto.getAccount());
            map.put("username", sysUserDto.getUsername());
            rows.add(map);
        }
        result.put("total", restResponse.getData().getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    /**
     * 获取特殊供应商
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getSpecialSupplierByAdmin")
    public Object getSpecialSupplierByAdmin(Integer page, String q) {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        UserQueryVo userQueryVo = new UserQueryVo();
        userQueryVo.setUserType(SysUserType.supplier);
        userQueryVo.setSupplierFlag(Boolean.TRUE);
        userQueryVo.setPageIndex(page);
        userQueryVo.setUsername(q);
        RestResponse<PageDto<SysUserDto>> restResponse = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        for (SysUserDto sysUserDto : restResponse.getData().getRecords()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", String.valueOf(sysUserDto.getId()));
            map.put("account", sysUserDto.getAccount());
            map.put("username", sysUserDto.getUsername());
            rows.add(map);
        }
        result.put("total", restResponse.getData().getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    /**
     * 查看酒店详情信息
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/disPlay")
    public String disPlay(Long id, ModelMap modelMap) {
        Assert.notNull(id, "酒店id不能为空");
        RestResponse<HotelInfoDto> restResponse = hotelInfoRemoteService.getHotelInfoById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        List<String> facilitiesList = Arrays.asList("西式餐厅", "中式餐厅", "残疾人设施", "室外游泳池", "室内游泳池", "会议室"
                , "健身房", "SPA", "无烟房", "商务中心", "酒吧", "桑拿", "棋牌室", "无烟房", "免费停车场");
        List<String> serviceList = Arrays.asList("早餐服务", "接站服务", "接机服务", "接待外宾", "洗衣服务", "行李寄存"
                , "看护小孩服务", "租车", "携带宠物", "叫醒服务");

        modelMap.addAttribute("facilitiesList", facilitiesList);
        modelMap.addAttribute("serviceList", serviceList);
        modelMap.addAttribute("dto", restResponse.getData());
        return "/hotel/hotelinfo/disPlay";
    }
}
