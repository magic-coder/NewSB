package com.qmx.admin.controller.shop.commodity;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.shop.commodity.ProductInfoRemoteService;
import com.qmx.admin.remoteapi.shop.commodity.StorageRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.shop.api.dto.commodity.ProductInfoDto;
import com.qmx.shop.api.dto.commodity.StorageDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by zcl on 2018/3/23.
 */
@Controller("/commodity/storage")
@RequestMapping("/commodity/storage")
public class StorageController extends BaseController {
    @Autowired
    private ProductInfoRemoteService productInfoRemoteService;
    @Autowired
    private StorageRemoteService storageRemoteService;
    /**
     * 获取商品所有的入库信息
     *
     * @param dto
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String storageList(StorageDto dto, ModelMap modelMap) {
        RestResponse<PageDto<StorageDto>> restResponse = storageRemoteService.findList(getAccessToken(), dto);
        if (!restResponse.success()) {
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto", dto);
        modelMap.addAttribute("page", restResponse.getData());
        return "/shop/commodity/info/storagelist";
    }

    /**
     * 跳转商品入库页面
     *
     * @param cid
     * @param modelMap
     * @return
     */
    @RequestMapping(value = "/storage", method = RequestMethod.GET)
    public String storage(Long cid, ModelMap modelMap) {
        Assert.notNull(cid,"商品id不能为空");
        RestResponse<ProductInfoDto> restResponse=productInfoRemoteService.getById(getAccessToken(),cid);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        modelMap.addAttribute("dto",restResponse.getData());
        return "/shop/commodity/info/storage";
    }

    /**
     * 通过ajax获取入库信息
     *
     * @param dto
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getStorage", method = RequestMethod.POST)
    public JSONObject getStorage(StorageDto dto) {
        JSONObject object = new JSONObject();
        RestResponse<StorageDto> restResponse = storageRemoteService.createDto(getAccessToken(), dto);
        if (!restResponse.success()) {
            object.put("data", "2");
            throw new BusinessException(restResponse.getErrorMsg());
        } else {
            object.put("data", "1");
        }
        return object;
    }
}
