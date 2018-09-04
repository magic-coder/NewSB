package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysPayRefundRemoteService;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.coreservice.api.pay.dto.SysPayRefundDTO;
import com.qmx.coreservice.api.pay.query.SysPayRefundVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @Author liubin
 * @Description 支付退款管理
 * @Date Created on 2018/1/2 15:30.
 * @Modified By
 */
@Controller
@RequestMapping("/pay/refund")
public class RefundOrderController extends BaseController {

	@Autowired
	private SysPayRefundRemoteService sysPayRefundRemoteService;

	/**
	 * 列表
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(ModelMap model, SysPayRefundVO sysPayRefundVO) {
		RestResponse<PageDto<SysPayRefundDTO>> restResponse = sysPayRefundRemoteService.findPage(getAccessToken(),sysPayRefundVO);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		model.addAttribute("queryDto",sysPayRefundVO);
		model.addAttribute("page", restResponse.getData());
		return "/sys_common/refund_order/list";
	}

	/**
	 * 查询退款状态（支付宝，微信都可以用）
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/getRefundStatus", method = RequestMethod.POST)
	public String getRefundStatus(Long id) {
		Assert.notNull(id,"id不能为空");
		RestResponse restResponse = sysPayRefundRemoteService.queryChannelRefundInfo(getAccessToken(),null,null,id+"");
		return JSONUtil.toJson(restResponse);
	}

	/**
	 * 删除
	 */
	/*@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String delete(Long id) {
		Assert.notNull(id,"字典Id不能为空");
		RestResponse<Boolean> restResponse = sysPayRefundRemoteService.
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		return "redirect:list";
	}*/

}