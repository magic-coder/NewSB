package com.qmx.admin.controller.tickets;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserApiRemoteService;
import com.qmx.admin.remoteapi.tickets.SightRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysDeptDto;
import com.qmx.coreservice.api.user.dto.SysUserApiDTO;
import com.qmx.tickets.api.dto.SysSightDTO;
import com.qmx.tickets.api.query.SysSightVO;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * @Author liubin
 * @Description 景点管理
 * @Date Created on 2017/11/27 14:21.
 * @Modified By
 */
@Controller
@RequestMapping("/tickets/sight")
public class SightController extends BaseController {

    @Autowired
    private SightRemoteService sightRemoteService;


    @RequestMapping("/list")
    public String list(HttpServletRequest request, HttpServletResponse response, SysSightVO sysSightVO){
        RestResponse<PageDto<SysSightDTO>> restResponse = sightRemoteService.findPage(getAccessToken(),sysSightVO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        request.setAttribute("sysSightVO",sysSightVO);
        request.setAttribute("page",restResponse.getData());
        return "/tickets/sight/list";
    }

    /**
     * 票型下拉菜单
     * @param q
     * @param page
     * @param row
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/listForJson", method = RequestMethod.POST)
    public Object listForJson(@RequestParam(defaultValue = "") String q,
                      @RequestParam(defaultValue = "1") Integer page,
                      @RequestParam(defaultValue = "10") Integer row) {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();

        SysSightVO sysSightVO = new SysSightVO();
        sysSightVO.setPageIndex(page);
        sysSightVO.setPageSize(row);

        RestResponse<PageDto<SysSightDTO>> restResponse = sightRemoteService.findPage(getAccessToken(),sysSightVO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }

        PageDto<SysSightDTO> pageDto = restResponse.getData();
        for (SysSightDTO sightDTO : pageDto.getRecords()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", sightDTO.getId()+"");
            map.put("sightName", sightDTO.getSightName());
            map.put("code", sightDTO.getCode());
            map.put("address", sightDTO.getAddress());
            map.put("type", sightDTO.getSightType());
            rows.add(map);
        }
        result.put("total", pageDto.getTotal());
        result.put("rows", rows);
        result.put("footer", null);
        return result;
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(HttpServletRequest request, HttpServletResponse response){

        return "/tickets/sight/add";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(HttpServletRequest request, HttpServletResponse response,Long id){
        Assert.notNull(id,"id不能为空");
        RestResponse<SysSightDTO> restResponse = sightRemoteService.findById(getAccessToken(),id);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        SysSightDTO sysSightDTO = restResponse.getData();
        List<String> focusImages = new ArrayList<>();
        if(!StringUtils.isEmpty(sysSightDTO.getFocusImages())){
            String[] images = StringUtils.split(sysSightDTO.getFocusImages(),",");
            if(images != null){
                focusImages = Arrays.asList(images);
            }
        }
        request.setAttribute("sightImages",focusImages);
        request.setAttribute("sightInfo",sysSightDTO);
        return "/tickets/sight/edit";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(HttpServletRequest request, HttpServletResponse response,
                       SysSightDTO sysSightDTO,String[] focusimagepath,RedirectAttributes redirectAttributes){
        Assert.notNull(sysSightDTO,"景区信息不能为空");
        /*String focusImages = "";
        for (String image : focusimagepath) {
            if(StringUtils.isEmpty(image)){
                continue;
            }
            focusImages +=image+",";
        }
        if(!StringUtils.isEmpty(focusImages)){
            focusImages = focusImages.substring(0,focusImages.length()-1);
        }*/
        //sysSightDTO.setFocusImages(focusImages);
        RestResponse<SysDeptDto> restResponse = sightRemoteService.saveSight(getAccessToken(),sysSightDTO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"保存成功");
        return "redirect:list";
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(HttpServletRequest request, HttpServletResponse response,
                         SysSightDTO sysSightDTO,String[] focusimagepath){
        Assert.notNull(sysSightDTO,"景区信息不能为空");
        /*String focusImages = "";
        for (String image : focusimagepath) {
            if(StringUtils.isEmpty(image)){
                continue;
            }
            focusImages +=image+",";
        }
        if(!StringUtils.isEmpty(focusImages)){
            focusImages = focusImages.substring(0,focusImages.length()-1);
        }
        sysSightDTO.setFocusImages(focusImages);*/
        RestResponse<SysDeptDto> restResponse = sightRemoteService.updateSight(getAccessToken(),sysSightDTO);
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        return "redirect:list";
    }

    @RequestMapping(value = "/delete")
    public String delete(HttpServletRequest request, HttpServletResponse response,
                         Long id,RedirectAttributes redirectAttributes){
        Assert.notNull(id,"id不能为空");
        RestResponse<Boolean> restResponse = sightRemoteService.deleteSight(getAccessToken(),new Long[]{id});
        if(!restResponse.success()){
            throw new BusinessException(restResponse.getErrorMsg());
        }
        redirectAttributes.addAttribute(FLASH_MESSAGE_ATTRIBUTE_NAME,"删除成功");
        return "redirect:list";
    }
}
