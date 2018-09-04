package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysDictRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.coreservice.api.user.dto.SysDictDTO;
import com.qmx.coreservice.api.user.query.SysDictVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @Author liubin
 * @Description 字典
 * @Date Created on 2017/12/27 11:16.
 * @Modified By
 */
@Controller
@RequestMapping("/dict")
public class DictController extends BaseController {

	@Autowired
	private SysDictRemoteService sysDictRemoteService;

	/**
	 * 添加
	 */
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(ModelMap model) {
		return "/user/dict/add";
	}

	/**
	 * 保存
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(SysDictDTO sysDictDTO) {
		Assert.notNull(sysDictDTO,"字典信息不能为空");
		Assert.notNull(sysDictDTO.getType(),"字典类型不能为空");
		Assert.notNull(sysDictDTO.getCode(),"字典code不能为空");
		Assert.notNull(sysDictDTO.getCodeText(),"字典说明不能为空");
		RestResponse<SysDictDTO> restResponse = sysDictRemoteService.createDict(getAccessToken(),sysDictDTO);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.GET)
	public String edit(Long id, ModelMap model) {
		Assert.notNull(id,"字典Id不能为空");
		RestResponse<SysDictDTO> restResponse = sysDictRemoteService.getDictById(id);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		model.addAttribute("dto", restResponse.getData());
		return "/user/dict/edit";
	}

	/**
	 * 更新
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String update(SysDictDTO sysDictDTO) {
		Assert.notNull(sysDictDTO,"字典信息不能为空");
		Assert.notNull(sysDictDTO.getId(),"字典Id不能为空");
		Assert.notNull(sysDictDTO.getType(),"字典类型不能为空");
		Assert.notNull(sysDictDTO.getCode(),"字典code不能为空");
		Assert.notNull(sysDictDTO.getCodeText(),"字典说明不能为空");
		RestResponse<SysDictDTO> restResponse = sysDictRemoteService.updateDict(getAccessToken(),sysDictDTO);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(ModelMap model, SysDictVO sysDictVO) {
		RestResponse<PageDto<SysDictDTO>> restResponse = sysDictRemoteService.findPage(getAccessToken(),sysDictVO);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		model.addAttribute("queryDto",sysDictVO);
		model.addAttribute("page", restResponse.getData());
		return "/user/dict/list";
	}

	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String delete(Long id) {
		Assert.notNull(id,"字典Id不能为空");
		RestResponse<Boolean> restResponse = sysDictRemoteService.deleteDictById(getAccessToken(),id);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		return "redirect:list";
	}

}