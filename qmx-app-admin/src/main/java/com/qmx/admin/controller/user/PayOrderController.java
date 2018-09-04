package com.qmx.admin.controller.user;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.*;
import com.qmx.base.api.dto.PageDto;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.utils.JSONUtil;
import com.qmx.coreservice.api.pay.constant.PayConstant;
import com.qmx.coreservice.api.pay.dto.SysMchPayConfigDto;
import com.qmx.coreservice.api.pay.dto.SysPayOrderDto;
import com.qmx.coreservice.api.pay.dto.SysPayRefundDTO;
import com.qmx.coreservice.api.pay.dto.request.SysPayRequestDTO;
import com.qmx.coreservice.api.pay.dto.request.SysRefundRequestDTO;
import com.qmx.coreservice.api.pay.query.SysPayOrderVo;
import com.qmx.coreservice.api.user.enumerate.TradingTypeEnum;
import org.apache.commons.lang.RandomStringUtils;
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
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * @Author liubin
 * @Description 字典
 * @Date Created on 2017/12/27 11:16.
 * @Modified By
 */
@Controller
@RequestMapping("/pay/order")
public class PayOrderController extends BaseController {

	private static final Logger logger = LoggerFactory.getLogger(PayOrderController.class);
	@Autowired
	private SysPayOrderRemoteService sysPayOrderRemoteService;
	@Autowired
	private SysMchPayConfigRemoteService sysMchPayConfigRemoteService;
	@Autowired
	private SysPayRefundRemoteService sysPayRefundRemoteService;
	@Autowired
	private QueryPayOrderRemoteService queryPayOrderRemoteService;

	/**
	 * 添加
	 */
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(ModelMap model) {

		RestResponse<List<SysMchPayConfigDto>> restResponse = sysMchPayConfigRemoteService.findAllConfig(getAccessToken());
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		model.addAttribute("configDtos",restResponse.getData());
		model.addAttribute("tradeTypes", TradingTypeEnum.values());
		model.addAttribute("body","测试body-"+ RandomStringUtils.randomAlphabetic(6));
		model.addAttribute("device","device-"+RandomStringUtils.randomAlphabetic(6));
		model.addAttribute("attach","attach-"+RandomStringUtils.randomAlphabetic(6));
		model.addAttribute("mchOrderId","mchOrderId"+System.currentTimeMillis());
		model.addAttribute("subject","测试subject-"+RandomStringUtils.randomAlphabetic(6));
		model.addAttribute("notifyUrl","http://gds.qmx028.com");
		return "/sys_common/pay_order/add";
	}

	/**
	 * "extra":"{\"openId\":\"op_fHwAN4EjdZE4f9jHvosbrT-y4\",\"attach\":\"WEBSITE\"}
	 * 保存
	 */
	@RequestMapping(value = "/savePayOrderInfo", method = RequestMethod.POST)
	public String savePayOrderInfo(HttpServletRequest request, HttpServletResponse response,
								   Long configId, BigDecimal amount, String body,
								   String clientIp, String device, String openId, String productId,
								   String attach, String mchOrderId, String subject,
								   String notifyUrl, String sceneInfo, String authCode, TradingTypeEnum tradingType) {

		Assert.notNull(configId,"配置信息不能为空");
		Assert.notNull(amount,"支付金额不能为空");
		Assert.notNull(body,"body不能为空");
		Assert.notNull(subject,"subject不能为空");
		Assert.notNull(mchOrderId,"mchOrderId不能为空");
		Assert.notNull(tradingType,"tradingType不能为空");

		RestResponse<SysMchPayConfigDto> configResponse = sysMchPayConfigRemoteService.queryById(getAccessToken(),configId);
		if(!configResponse.success()){
			throw new BusinessException(configResponse.getErrorMsg());
		}

		SysMchPayConfigDto sysMchPayConfigDto = configResponse.getData();
		if(sysMchPayConfigDto == null){
			throw new BusinessException("未找到配置信息");
		}
		//SysPayOrderDto sysPayOrderDto = new SysPayOrderDto();
		SysPayRequestDTO payDTO = new SysPayRequestDTO();
		payDTO.setAmount(amount);
		payDTO.setBody(body);
		payDTO.setClientIp(clientIp);
		payDTO.setDevice(device);
		payDTO.setMchOrderId(mchOrderId);
		payDTO.setMchId(sysMchPayConfigDto.getMemberId());
		payDTO.setChannelNo(sysMchPayConfigDto.getPayChannelNo());
		payDTO.setNotifyUrl(notifyUrl);
		payDTO.setSubject(subject);
		payDTO.setTradingScene("TradingScene测试");
		payDTO.setTradingType(tradingType);
		payDTO.setProductId(productId);
		payDTO.setOpenId(openId);
		payDTO.setSceneInfo(sceneInfo);

		//JSONObject jsonObject = new JSONObject();
		//jsonObject.put("attach",attach);
		if(PayConstant.PAY_CHANNEL_WX_JSAPI.equals(sysMchPayConfigDto.getPayChannelNo())){
			Assert.notNull(openId,"openId不能为空");
			//jsonObject.put("openId",openId);
		}else if(PayConstant.PAY_CHANNEL_WX_NATIVE.equals(sysMchPayConfigDto.getPayChannelNo())){
			Assert.notNull(productId,"productId不能为空");
			//jsonObject.put("productId",productId);
		}else if(PayConstant.PAY_CHANNEL_WX_MWEB.equals(sysMchPayConfigDto.getPayChannelNo())){
			Assert.notNull(sceneInfo,"sceneInfo不能为空");
			//jsonObject.put("sceneInfo",sceneInfo);
		}else if(PayConstant.PAY_CHANNEL_ALIPAY_BAR.equals(sysMchPayConfigDto.getPayChannelNo()) ||
				PayConstant.PAY_CHANNEL_WX_MICROPAY.equals(sysMchPayConfigDto.getPayChannelNo())){
			Assert.hasText(authCode,"authCode不能为空");
			payDTO.setAuthCode(authCode);
		}
		//payDTO.setExtra(jsonObject.toJSONString());
		RestResponse<SysPayOrderDto> restResponse = sysPayOrderRemoteService.payOrder(payDTO);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		SysPayOrderDto resultOrder = restResponse.getData();
		Map<String,Object> result = resultOrder.getPayResult();
		logger.info("支付返回内容："+ JSONUtil.toJson(result));
		if(PayConstant.PAY_CHANNEL_ALIPAY_PC.equals(sysMchPayConfigDto.getPayChannelNo())||
				PayConstant.PAY_CHANNEL_ALIPAY_WAP.equals(sysMchPayConfigDto.getPayChannelNo())){
			request.setAttribute("body",result.get("payUrl").toString());
		}else{
			request.setAttribute("body",result.toString());
		}
		return "/sys_common/pay_order/pay_result";
	}

	/**
	 * 编辑
	 */
	/*@RequestMapping(value = "/edit", method = RequestMethod.GET)
	public String edit(Long id, ModelMap model) {
		Assert.notNull(id,"字典Id不能为空");
		RestResponse<SysDictDTO> restResponse = sysDictRemoteService.getDictById(getAccessToken(),id);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		model.addAttribute("dto", restResponse.getData());
		return "/user/refund_order/edit";
	}*/

	/**
	 * 更新状态
	 */
	@ResponseBody
	@RequestMapping(value = "/updateStatus", method = RequestMethod.POST)
	public Object updateStatus(Long id) {
		Assert.notNull(id,"id不能为空");
		RestResponse<SysPayOrderDto> restResponse = queryPayOrderRemoteService.queryUpdatePayOrderStatus(null,id,null);
		/*if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}*/
		return restResponse;
	}

	@ResponseBody
	@RequestMapping(value = "/getPayOrderStatus", method = RequestMethod.POST)
	public String getPayOrderStatus(Long id) {
		Assert.notNull(id,"id不能为空");
		RestResponse<SysPayOrderDto> restResponse = queryPayOrderRemoteService.queryChannelOrderResult(getAccessToken(),null,id,null);
		return JSONUtil.toJson(restResponse);
	}

	/**
	 * 查询退款状态（仅微信可用，因为支付宝查询退款，退款单号必填）
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/getRefundStatus", method = RequestMethod.POST)
	public String getRefundStatus(Long id) {
		Assert.notNull(id,"id不能为空");
		RestResponse restResponse = sysPayRefundRemoteService.queryChannelRefundInfo(getAccessToken(),id+"",null,null);
		return JSONUtil.toJson(restResponse);
	}

	/**
	 * 退款
	 * @return
	 */
	@RequestMapping(value = "/prePayRefund", method = RequestMethod.GET)
	public String prePayRefund(HttpServletRequest request,String orderId){
		request.setAttribute("orderId",orderId);
		return "/sys_common/pay_order/refund_dialog";
	}

	/**
	 * 退款
	 * @param orderId
	 * @param amount
	 * @param desc
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/doPayRefund", method = RequestMethod.POST)
	public Object doPayRefund(String orderId,BigDecimal amount,String desc){

		Assert.notNull(orderId,"订单号不能为空");
		Assert.notNull(amount,"退款金额不能为空");
		String refundSn = System.currentTimeMillis()+"";
		SysRefundRequestDTO refundDTO = new SysRefundRequestDTO();
		refundDTO.setRefundDesc(desc);
		refundDTO.setPayOrderId(Long.parseLong(orderId));
		refundDTO.setMchRefundSn(refundSn);
		refundDTO.setRefundFee(amount);
		RestResponse<SysPayRefundDTO> restResponse = sysPayRefundRemoteService.refundOrder(getAccessToken(),refundDTO);
		return restResponse;
	}

	/**
	 * 列表
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(ModelMap model, SysPayOrderVo sysPayOrderVo) {
		RestResponse<PageDto<SysPayOrderDto>> restResponse = queryPayOrderRemoteService.findPage(getAccessToken(),sysPayOrderVo);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		model.addAttribute("queryDto",sysPayOrderVo);
		model.addAttribute("page", restResponse.getData());
		return "/sys_common/pay_order/list";
	}

	/**
	 * 删除
	 */
	/*@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String delete(Long id) {
		Assert.notNull(id,"字典Id不能为空");
		RestResponse<Boolean> restResponse = sysDictRemoteService.deleteDictById(getAccessToken(),id);
		if(!restResponse.success()){
			throw new BusinessException(restResponse.getErrorMsg());
		}
		return "redirect:list";
	}*/

}