package com.qmx.admin.controller.hotel;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelInfoRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelProductImpowerRateRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelProductImpowerRemoteService;
import com.qmx.admin.remoteapi.hotel.HotelProductRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.api.enumerate.SysUserType;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.coreservice.api.user.query.UserQueryVo;
import com.qmx.hotel.api.dto.HotelInfoDto;
import com.qmx.hotel.api.dto.HotelProductDto;
import com.qmx.hotel.api.dto.HotelProductImpowerDto;
import com.qmx.hotel.api.dto.HotelProductImpowerRateDto;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by earnest on 2017/11/10 0010.
 */
@Controller
@RequestMapping("/HotelProductImpower")
public class HotelProductImpowerController extends BaseController {
    @Autowired
    private HotelProductImpowerRemoteService hotelProductImpowerRemoteService;
    @Autowired
    private HotelInfoRemoteService hotelInfoRemoteService;
    @Autowired
    private HotelProductRemoteService hotelProductRemoteService;
    @Autowired
    private HotelProductImpowerRateRemoteService hotelProductImpowerRateRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    /**
     * 授权信息列表
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(HotelProductImpowerDto dto, ModelMap modelMap) {
        RestResponse<PageDto<HotelProductImpowerDto>> restResponse = hotelProductImpowerRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/hotel/hotelproductimpower/list";
    }


    /**
     * 选择授权产品页面d
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/chooseProduct")
    public JSONObject chooseProduct(HotelProductImpowerDto hotelProductImpowerDto) {
        Assert.notNull(hotelProductImpowerDto.getHid(), "酒店id不能为空");
        JSONObject jsonObject = new JSONObject();
        SysUserDto sysUserDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        Map<String, String> map = new LinkedHashMap<>();
        if (sysUserDto.getUserType() == SysUserType.distributor) {
            //根据酒店id查询授权的产品
            RestResponse<List<HotelProductImpowerDto>> response = hotelProductImpowerRemoteService.getImpowerByHid(getAccessToken(), hotelProductImpowerDto);
            if (!response.success()) {
                throw new BusinessException(response.getErrorMsg());
            }
            if (!response.getData().isEmpty()) {
                for (HotelProductImpowerDto dto : response.getData()) {
                    map.put(String.valueOf(dto.getProductId()), hotelProductRemoteService.getHotelProductById(getAccessToken(), dto.getProductId()).getData().getName());
                }
            }
        } else {
            if (sysUserDto.getUserType() == SysUserType.employee) {
                SysUserDto userDto = sysUserRemoteService.findById(sysUserDto.getMemberId()).getData();
                if (userDto.getUserType() == SysUserType.distributor) {
                    //根据酒店id查询授权的产品
                    RestResponse<List<HotelProductImpowerDto>> response = hotelProductImpowerRemoteService.getImpowerByHid(getAccessToken(), hotelProductImpowerDto);
                    if (!response.success()) {
                        throw new BusinessException(response.getErrorMsg());
                    }
                    if (!response.getData().isEmpty()) {
                        for (HotelProductImpowerDto dto : response.getData()) {
                            map.put(String.valueOf(dto.getProductId()), hotelProductRemoteService.getHotelProductById(getAccessToken(), dto.getProductId()).getData().getName());
                        }
                    }
                } else {
                    RestResponse<List<HotelProductDto>> restResponse = hotelProductRemoteService.getHotelProductByHid(getAccessToken(), hotelProductImpowerDto.getHid());
                    if (!restResponse.success()) {
                        throw new BusinessException(restResponse.getErrorMsg());
                    }
                    if (!restResponse.getData().isEmpty()) {
                        for (HotelProductDto hotelProductDto : restResponse.getData()) {
                            map.put(String.valueOf(hotelProductDto.getId()), hotelProductDto.getName());
                        }
                    }
                }
            } else {
                RestResponse<List<HotelProductDto>> restResponse = hotelProductRemoteService.getHotelProductByHid(getAccessToken(), hotelProductImpowerDto.getHid());
                if (!restResponse.success()) {
                    throw new BusinessException(restResponse.getErrorMsg());
                }
                if (!restResponse.getData().isEmpty()) {
                    for (HotelProductDto hotelProductDto : restResponse.getData()) {
                        map.put(String.valueOf(hotelProductDto.getId()), hotelProductDto.getName());
                    }
                }
            }
        }
        jsonObject.put("hid", String.valueOf(hotelProductImpowerDto.getHid()));
        jsonObject.put("data", map);
        return jsonObject;
    }

    /**
     * 添加授权信息跳转页面
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(HotelProductImpowerDto dto, ModelMap modelMap, HttpServletRequest request) {
        String[] distributorIds = request.getParameterValues("userId");
        String str = StringUtils.join(distributorIds, ",");
        if (distributorIds.length < 1) {
            throw new RuntimeException("授权异常，请重新授权!");
        }
        RestResponse<HotelProductDto> restResponse = hotelProductRemoteService.getHotelProductById(getAccessToken(), dto.getProductId());
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("data", restResponse.getData());
        modelMap.addAttribute("distributorId", str);
        return "/hotel/hotelproductimpower/add";
    }


    /**
     * 获取供应商下面的酒店
     *
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/addImpower")
    public String addImpower(ModelMap modelMap) {
        LinkedHashMap<String, Object> map = new LinkedHashMap<>();
        SysUserDto sysUserDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        //如果当前登录用户是分销商
        if (sysUserDto.getUserType() == SysUserType.distributor) {
            //先查询该分销商获得授权的产品
            RestResponse<List<HotelProductImpowerDto>> response = hotelProductImpowerRemoteService.getImpowerByDistributor(getAccessToken(), sysUserDto.getId());
            if (!response.success()) {
                throw new BusinessException(response.getErrorMsg());
            }
            modelMap.addAttribute("impowerHotel", response.getData());
        } else {
            if (sysUserDto.getUserType() == SysUserType.employee) {
                SysUserDto userDto = sysUserRemoteService.findById(sysUserDto.getMemberId()).getData();
                if (userDto.getUserType() == SysUserType.distributor) {
                    //先查询该分销商获得授权的产品
                    RestResponse<List<HotelProductImpowerDto>> response = hotelProductImpowerRemoteService.getImpowerByDistributor(getAccessToken(), userDto.getId());
                    if (!response.success()) {
                        throw new BusinessException(response.getErrorMsg());
                    }
                    modelMap.addAttribute("impowerHotel", response.getData());
                } else {
                    RestResponse<List<HotelInfoDto>> restResponse = hotelInfoRemoteService.findAll(getAccessToken());
                    if (!restResponse.success()) {
                        throw new BusinessException(restResponse.getErrorMsg());
                    }
                    modelMap.addAttribute("hotelInfo", restResponse.getData());
                }
            } else {
                RestResponse<List<HotelInfoDto>> restResponse = hotelInfoRemoteService.findAll(getAccessToken());
                if (!restResponse.success()) {
                    throw new BusinessException(restResponse.getErrorMsg());
                }
                modelMap.addAttribute("hotelInfo", restResponse.getData());
            }
        }

        return "/hotel/hotelproductimpower/addimpower";
    }

    /**
     * 保存授权信息
     *
     * @param dto
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(HotelProductImpowerDto dto, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        Assert.notNull(dto.getHid(), "酒店id不能为空");
        Assert.notNull(dto.getProductId(), "产品id不能为空");
        String data = request.getParameter("datePriceData");
        String distributorId = request.getParameter("distributorId");
        String[] strings = distributorId.split(",");
        for (String string : strings) {
            dto.setDistributor(Long.parseLong(string.trim()));
            RestResponse restResponse = hotelProductImpowerRemoteService.createHotelProductImpower(getAccessToken(), dto, data);
            if (!restResponse.success()) {
                throw new BusinessException(restResponse.getErrorMsg());
            }
        }
        redirectAttributes.addFlashAttribute("msg", "保存成功");
        return "redirect:list";
    }

    /**
     * 获取价格信息返回到日历上
     *
     * @param productId
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/getRate")
    public String getRate(Long productId, ModelMap modelMap) {
        HotelProductImpowerRateDto dto = new HotelProductImpowerRateDto();
        dto.setImpowerProductId(productId);
        RestResponse<List<HotelProductImpowerRateDto>> restResponse = hotelProductImpowerRateRemoteService.getRateByProductId(getAccessToken(), productId);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONObject obj = new JSONObject();
        for (HotelProductImpowerRateDto hotelProductImpowerRateDto : restResponse.getData()) {
            JSONObject json = new JSONObject();
            json.put("id", hotelProductImpowerRateDto.getImpowerProductId());
            json.put("sellPrice", hotelProductImpowerRateDto.getSettlementPrice());
            json.put("suggestPrice", hotelProductImpowerRateDto.getAdvisePrice());
            json.put("stock", hotelProductImpowerRateDto.getStock());
            obj.put(hotelProductImpowerRateDto.getDate(), json);
        }
        modelMap.addAttribute("distribution", obj.toString());
        return "/hotel/hotelproductimpower/getrate";
    }

    /**
     * 根据授权id修改授权信息
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/editRate")
    public String editRate(Long id, ModelMap modelMap) {
        Assert.notNull(id, "授权id不能为空");
        RestResponse<HotelProductImpowerDto> restResponse = hotelProductImpowerRemoteService.getHotelProductImpowerById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        JSONObject obj = new JSONObject();
        for (HotelProductImpowerRateDto dto : restResponse.getData().getRateDtos()) {
            JSONObject json = new JSONObject();
            json.put("id", dto.getImpowerProductId());
            json.put("sellPrice", dto.getSettlementPrice());
            json.put("suggestPrice", dto.getAdvisePrice());
            json.put("stock", dto.getStock());
            obj.put(dto.getDate(), json);
        }
        modelMap.addAttribute("distribution", obj.toString());
        modelMap.addAttribute("dto", restResponse.getData());
        return "/hotel/hotelproductimpower/editrate";
    }

    /**
     * 更新授权信息
     *
     * @param dto
     * @param request
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(HotelProductImpowerDto dto, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        String datePriceData = request.getParameter("datePriceData");
        RestResponse<HotelProductImpowerDto> restResponse = hotelProductImpowerRemoteService.updateImpowerAndRate(getAccessToken(), dto, datePriceData);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addFlashAttribute("msg", "修改成功");
        return "redirect:list";
    }

    /**
     * 根据ajax批量删除授权信息
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
                hotelProductImpowerRemoteService.deleteHotelProductImpower(getAccessToken(), Long.parseLong(s));
                jsonObject.put("data", "1");
            }
        } catch (Exception e) {
            jsonObject.put("data", "2");
            e.printStackTrace();
        }
        return jsonObject;
    }

   /* @RequestMapping(value = "/listDistributorForAuthorize")
    public String listDistributorForAuthorize(ModelMap modelMap) {
        //查询供应商下面的分销商
        UserQueryVo userQueryVo = new UserQueryVo();
        SysUserDto sysUserDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (sysUserDto.getUserType() == SysUserType.supplier) {
            userQueryVo.setUserType(SysUserType.distributor);
        }
        if (sysUserDto.getUserType() == SysUserType.distributor) {
            userQueryVo.setUserType(SysUserType.distributor2);
        }
        if (sysUserDto.getUserType() == SysUserType.admin) {
            return "/hotel/hotelproductimpower/listdistributorforauthorize";
        }
        if (sysUserDto.getUserType() == SysUserType.employee) {
            SysUserDto userDto = sysUserRemoteService.findById(sysUserDto.getMemberId()).getData();
            if (userDto.getUserType() == SysUserType.supplier) {
                userQueryVo.setUserType(SysUserType.distributor);
            } else if (userDto.getUserType() == SysUserType.distributor) {
                userQueryVo.setUserType(SysUserType.distributor2);
            } else if (sysUserDto.getUserType() == SysUserType.admin) {
                return "/hotel/hotelproductimpower/listdistributorforauthorize";
            }
        }
        RestResponse<PageDto<SysUserDto>> response = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        modelMap.addAttribute("page", response.getData());
        return "/hotel/hotelproductimpower/listdistributorforauthorize";
    }*/

    @RequestMapping(value = "/getUser")
    public String getUser(SysUserDto dto, ModelMap model) {
        //查询供应商下面的分销商
        UserQueryVo userQueryVo = new UserQueryVo();
        SysUserDto sysUserDto = sysUserRemoteService.getCurrentTokenUser(getAccessToken()).getData();
        if (sysUserDto.getUserType() == SysUserType.supplier) {
            userQueryVo.setUserType(SysUserType.distributor);
        }
        if (sysUserDto.getUserType() == SysUserType.distributor) {
            userQueryVo.setUserType(SysUserType.distributor2);
        }
        if (sysUserDto.getUserType() == SysUserType.admin) {
            return "/hotel/hotelproductimpower/getUser";
        }
        if (sysUserDto.getUserType() == SysUserType.employee) {
            SysUserDto userDto = sysUserRemoteService.findById(sysUserDto.getMemberId()).getData();
            if (userDto.getUserType() == SysUserType.supplier) {
                userQueryVo.setUserType(SysUserType.distributor);
            } else if (userDto.getUserType() == SysUserType.distributor) {
                userQueryVo.setUserType(SysUserType.distributor2);
            } else if (sysUserDto.getUserType() == SysUserType.admin) {
                return "/hotel/hotelproductimpower/getUser";
            }
        }
        RestResponse<PageDto<SysUserDto>> response = sysUserRemoteService.findPage(getAccessToken(), userQueryVo);
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        model.addAttribute("dto", dto);
        model.addAttribute("page", response.getData());
        return "/hotel/hotelproductimpower/userlist";
    }

    /**
     * 根据分销商查询获得授权的产品
     *
     * @return
     */
    @RequestMapping(value = "/getImpower")
    public String getImpower(ModelMap modelMap, HotelProductImpowerDto dto) {
        RestResponse<PageDto<HotelProductImpowerDto>> restResponse = hotelProductImpowerRemoteService.getImpowerProduct(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //获取所有的酒店名称
        List<HotelProductImpowerDto> list = restResponse.getData().getRecords();
        Map<String, String> hidMap = new HashMap<>();
        if (!list.isEmpty()) {
            for (HotelProductImpowerDto hotelProductImpowerDto : list) {
                hidMap.put(String.valueOf(hotelProductImpowerDto.getHid()), hotelProductImpowerDto.getHidName());
            }
        }
        modelMap.addAttribute("page", restResponse.getData());
        modelMap.addAttribute("hidMap", hidMap);
        modelMap.addAttribute("dto", dto);
        return "/hotel/hotelproduct/impowerlist";
    }

    /**
     * 查看授权产品的详情信息
     *
     * @param id
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/check")
    public String check(Long id, ModelMap modelMap) {
        RestResponse<HotelProductImpowerDto> restResponse = hotelProductImpowerRemoteService.getHotelProductImpowerById(getAccessToken(), id);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        //查询酒店信息
        RestResponse response = hotelInfoRemoteService.getHotelInfoById(getAccessToken(), restResponse.getData().getHid());
        if (!response.success()) {
            throw new BusinessException(response.getErrorMsg());
        }
        JSONObject obj = new JSONObject();
        for (HotelProductImpowerRateDto hotelProductImpowerRateDto : restResponse.getData().getRateDtos()) {
            JSONObject json = new JSONObject();
            json.put("id", hotelProductImpowerRateDto.getImpowerProductId());
            json.put("sellPrice", hotelProductImpowerRateDto.getSettlementPrice());
            json.put("suggestPrice", hotelProductImpowerRateDto.getAdvisePrice());
            json.put("stock", hotelProductImpowerRateDto.getStock());
            obj.put(hotelProductImpowerRateDto.getDate(), json);
        }
        modelMap.addAttribute("distribution", obj.toString());
        modelMap.addAttribute("hotel", response.getData());
        modelMap.addAttribute("dto", restResponse.getData());
        return "/hotel/hotelproductimpower/check";
    }
}
